//
//  XVTableViewRefreshState.swift
//  XIAVAN
//
//  Created by zuer on 2021/9/9.
//

import UIKit


struct XVRefreshOption: OptionSet {
    let rawValue: Int
    static let refresh = XVRefreshOption(rawValue: 1 << 0)
    static let loading = XVRefreshOption(rawValue: 1 << 1)
    
    static let all: XVRefreshOption = [.refresh, .loading]
}

public class XVRefreshComponent {
    enum Event {
        case refresh
        case load
    }
    
    enum Result {
        case success(items: Int)
        case failed
    }
    
    struct Page {
        var index: Int
        var size: Int
    }
    
    struct Status {
        var loading: Bool
        var loaded: Bool
        var needReloaded: Bool
    }
    
    typealias Completion = (String, Result, Error?) -> Void
    typealias Entry = (String, Event, @escaping Completion) -> Void
    
    private weak var _scrollView: UIScrollView?
    private var _status: Status
    private var _option: XVRefreshOption
    
    var page: Page
    
    var refreshClosure: Entry?
    var nomoreClosure: (() -> Void)?

    
    init(scrollView: UIScrollView, option: XVRefreshOption = .all, pageSize: Int = 20) {
        _scrollView = scrollView
        _option = option
        _status = Status(loading: false, loaded: false, needReloaded: false)
        //默认一页加载20
        page = Page(index: 1, size: pageSize)
                
        if option.contains(.refresh) {
//            _scrollView?.addPullToRefresh { [weak self] in self?.fetch(by: .refresh) }
        }
        if option.contains(.loading) {
//            _scrollView?.addInfiniteScrolling { [weak self] in self?.fetch(by: .load) }
        }
    }
}

extension XVRefreshComponent {
    func reload() {
        setNeedReload()
        load()
    }
    func load() {
        if _status.loading {
            return
        }
        //未加载
        if !_status.loaded {
            self.fetch(by: .refresh)
        //需要强制更新
        }else if _status.needReloaded {
            _status.needReloaded = false
            self.fetch(by: .refresh)
        }
    }
    
    func hasLoad() -> Bool {
        return _status.loaded
    }
        
    func setNeedReload() {
        _status.needReloaded = true
    }
}

extension XVRefreshComponent {
    private func fetch(by event: Event) {
        _status.loading = true
        //重置索引
        if event == .refresh {
            page.index = 1
        }
        //fetch
        let uuid = UUID().uuidString
        self.refreshClosure?(uuid, event) { [weak self] uuidKey, result, error in
            guard let self = self, uuid == uuidKey else { return }
            
            self._status.loading = false
            //结果
            switch result {
            case .success(let items):
                //event
                switch event {
                case .refresh:
                    self.page.index += 1
                    self._status.loaded = true
                    break
                case .load:
                    self.page.index += 1
                    break
                }
                //to stop refresh header and footer
//                self._scrollView?.stopPullToRefresh()

                //no more datas
                if items < self.page.size {
                    self.nomoreClosure?()
//                    self._scrollView?.noticeNoMoreData()
                }
                break
                
            default:
//                self._scrollView?.stopPullToRefresh()
                break
            }
        }
    }
}
