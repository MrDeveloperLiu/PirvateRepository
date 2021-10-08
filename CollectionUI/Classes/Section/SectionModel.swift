//
//  SectionModel.swift
//  RTSwift
//
//  Created by zuer on 2021/9/14.
//

import UIKit

struct XVSectionModel<Model> {
    typealias Item = Model
    var header: Item?
    var footer: Item?
    var rows: [Item] = []
}

extension XVSectionModel {
    func index(of item: Item) -> Int? where Item: Equatable {
        return rows.firstIndex { $0 == item}
    }
}

class XVSectionItemModel {
    typealias SubscriptionClosure = (_ subscript: Subscript) -> Void
    typealias BinderClosure = (_ event: Any) -> Void

    struct State {
        var selected: Bool
    }
    enum Subscript {
        case content(content: Any?)
        case reversed(reversed: Any?)
        case state(s: State)
    }
    /// 状态
    var state: State = State(selected: false) { didSet { publish(.state(s: state)) } }
    /// 模型对象
    var content: Any? { didSet { publish(.content(content: content)) } }
    /// 预留字段
    var reversed: Any? { didSet { publish(.reversed(reversed: reversed)) } }
    /// 存储型字段
    var stored: Any?
    /// viewClass
    var viewClass: AnyClass?
    /// 大小
    var size: CGSize = .zero
    /// 订阅者(用于更新数据)
    fileprivate var UISubscribler: SubscriptionClosure?
    /// UI代理
    fileprivate var UIBinder: BinderClosure?
    /// 唯一标识
    private let id: String = UUID().uuidString
}

extension XVSectionItemModel: Equatable {
    static func == (lhs: XVSectionItemModel, rhs: XVSectionItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension XVSectionItemModel {
    /// row 订阅model的更新
    func subscrible(_ subscription: @escaping SubscriptionClosure) {
        UISubscribler = subscription
    }
    func publish(_ e: Subscript) {
        UISubscribler?(e)
    }
    
    /// ui 绑定row发出的事件 (通常由row的订阅者发出，回调给UI事件)
    func binding(_ binder: @escaping BinderClosure) {
        UIBinder = binder
    }
    func on(event: Any) {
        UIBinder?(event)
    }
    
    var identifier: String {
        precondition(viewClass != nil, "[Error]: XVSectionItemModel.viewClass must not be null!")
        return "\(viewClass!.self)"
    }
}

final class XVTableViewRow: XVSectionItemModel {
    convenience init(content: Any?, viewClass: AnyClass?, UIBinder: BinderClosure? = nil, size: CGSize = CGSize(width: 0, height: UITableView.automaticDimension)) {
        self.init()
        self.content = content
        self.viewClass = viewClass
        self.UIBinder = UIBinder
        self.size = size
    }
}

final class XVCollectionViewItem: XVSectionItemModel {
    convenience init(content: Any?, viewClass: AnyClass?, UIBinder: BinderClosure? = nil, size: CGSize = CGSize(width: 0, height: 0)) {
        self.init()
        self.content = content
        self.viewClass = viewClass
        self.UIBinder = UIBinder
        self.size = size
    }
}

typealias XVTableViewSection = XVSectionModel<XVTableViewRow>
typealias XVCollectionViewSection = XVSectionModel<XVCollectionViewItem>
