//
//  XVTableViewBuilder.swift
//  RTSwift
//
//  Created by zuer on 2021/9/10.
//

import UIKit


public class XVTableViewBuilder: CollectionBuilder {
    public typealias ItemType = XVTableViewRow
        
    public var uiUpdater: UpdaterClosure?
    public var uiSelecter: SelectClosure?
    
    var datasource: XVTableViewDatasource?
    var delegate: XVTableViewDelegate?
    
    weak var tableView: UITableView?
    
    public var state: CollectionState<ItemType> = CollectionState(sections: [], event: .none) {
        didSet {
            uiUpdater?(state.event)
        }
    }
    
    init(_ tableView: UITableView) {
        self.tableView = tableView
        self.datasource = XVTableViewDatasource(self)
        self.delegate = XVTableViewDelegate(self)
        tableView.dataSource = datasource
        tableView.delegate = delegate
        self.uiUpdater = { [weak self] _ in
            guard let self = self else {
                return
            }
            self.tableView?.reloadData()
        }
    }
    
    public func sectionWithIndexPath(_ indexPath: IndexPath) -> Int {
        return indexPath.section
    }
    
    public func rowWithIndexPath(_ indexPath: IndexPath) -> Int {
        return indexPath.row
    }

}
