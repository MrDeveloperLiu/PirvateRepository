//
//  XVCollectionViewBuilder.swift
//  RTSwift
//
//  Created by zuer on 2021/9/14.
//

import UIKit

class XVCollectionViewBuilder: CollectionBuilder {
    
    typealias ItemType = XVCollectionViewItem
        
    var uiUpdater: UpdaterClosure?
    var uiSelecter: SelectClosure?
    
    var datasource: XVCollectionViewDatasource?
    var delegate: XVCollectionViewDelegate?
    
    weak var collectionView: UICollectionView?
    
    var state: CollectionState<ItemType> = CollectionState(sections: [], event: .none) {
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
    
    func sectionWithIndexPath(_ indexPath: IndexPath) -> Int {
        return indexPath.section
    }
    
    func rowWithIndexPath(_ indexPath: IndexPath) -> Int {
        return indexPath.item
    }
}
