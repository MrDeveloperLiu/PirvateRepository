//
//  UICollectionView+Builder.swift
//  XIAVAN
//
//  Created by zuer on 2021/9/18.
//

import UIKit

extension UICollectionView {

    enum Kind: Int {
        case header = 0
        case footer = 1
    }
    
    var builder: XVCollectionViewBuilder {
        set {
            objc_setAssociatedObject(self, &XVPublicAssoiatedKey.collectionBuilder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let builder = objc_getAssociatedObject(self, &XVPublicAssoiatedKey.collectionBuilder) as? XVCollectionViewBuilder {
                return builder
            }
            let newValue = XVCollectionViewBuilder(self)
            objc_setAssociatedObject(self, &XVPublicAssoiatedKey.collectionBuilder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newValue
        }
    }
    
    func registerCellClass<Cell: UICollectionViewCell>(_ type: Cell.Type) where Cell: XVSectionItemViews {
        self.register(Cell.classForCoder(), forCellWithReuseIdentifier: Cell.reuseId)
    }
    
    func registerHeaderFooterClass<View: UICollectionReusableView>(_ type: View.Type, kind: Kind) where View: XVSectionItemViews {
        switch kind {
        case .header:
            self.register(View.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: View.reuseId)
            break
        case .footer:
            self.register(View.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: View.reuseId)
            break
        }
    }

}
