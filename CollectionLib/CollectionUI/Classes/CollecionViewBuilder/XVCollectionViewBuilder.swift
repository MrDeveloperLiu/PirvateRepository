//
//  XVCollectionViewBuilder.swift
//  RTSwift
//
//  Created by zuer on 2021/9/14.
//

import UIKit

public class XVCollectionViewBuilder: CollectionBuilder {
    
    public typealias ItemType = XVCollectionViewItem
        
    public var uiUpdater: UpdaterClosure?
    public var uiSelecter: SelectClosure?
    
    var datasource: XVCollectionViewDatasource?
    var delegate: XVCollectionViewDelegate?
    
    weak var collectionView: UICollectionView?
    
    public var state: CollectionState<ItemType> = CollectionState(sections: [], event: .none) {
        didSet {
            uiUpdater?(state.event)
        }
    }
    
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.datasource = XVCollectionViewDatasource(self)
        self.delegate = XVCollectionViewDelegate(self)
        collectionView.dataSource = datasource
        collectionView.delegate = delegate
        self.uiUpdater = { [weak self] _ in
            guard let self = self else {
                return
            }
            self.collectionView?.reloadData()
        }
    }
    
    public func sectionWithIndexPath(_ indexPath: IndexPath) -> Int {
        return indexPath.section
    }
    
    public func rowWithIndexPath(_ indexPath: IndexPath) -> Int {
        return indexPath.item
    }
}
