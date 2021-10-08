//
//  XVCollectionViewDelegate.swift
//  RTSwift
//
//  Created by zuer on 2021/9/15.
//

import UIKit

class XVCollectionViewDelegate: XVCollectionBuilderGetter<XVCollectionViewBuilder>, UICollectionViewDelegate {
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let builder = self.builder,
              let rowGetter = self.rowGetter(indexPath: indexPath) else {
            return
        }
        builder.uiSelecter?(true, rowGetter)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let builder = self.builder,
              let rowGetter = self.rowGetter(indexPath: indexPath) else {
            return
        }
        builder.uiSelecter?(false, rowGetter)
    }
    
}
