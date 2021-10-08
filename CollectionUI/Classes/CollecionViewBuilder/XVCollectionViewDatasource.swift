//
//  XVCollectionViewDatasource.swift
//  RTSwift
//
//  Created by zuer on 2021/9/15.
//

import UIKit

class XVCollectionViewDatasource: XVCollectionBuilderGetter<XVCollectionViewBuilder>, UICollectionViewDataSource {
        
    typealias Cell = (UICollectionViewCell & XVSectionItemViews)
    typealias HeaderFooter = (UICollectionReusableView & XVSectionItemViews)

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sectionsGetter = self.sectionsGetter else {
            return 0
        }
        return sectionsGetter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let rowsGetter = self.rowsGetter(section: section) else {
            return 0
        }
        return rowsGetter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = self.rowGetter(indexPath: indexPath) else {
            fatalError("[XVCollectionViewDatasource] something wrong with datas!")
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.identifier, for: indexPath) as? Cell else {
            fatalError("[XVCollectionViewDatasource] we can't take an any useable cell with id|\(item.identifier)! Please Check it!")
        }
        cell.model = item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = self.sectionGetter(section: indexPath.section) else {
            fatalError("[XVCollectionViewDatasource] something wrong with datas!")
        }
        if let header = section.header, indexPath.item == UICollectionView.Kind.header.rawValue {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: header.identifier, for: indexPath) as? HeaderFooter else {
                fatalError("[XVCollectionViewDatasource] we can't take an any useable header with id|\(header.identifier)! Please Check it!")
            }
            view.model = header
            return view
        }else if let footer = section.footer, indexPath.item == UICollectionView.Kind.footer.rawValue {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footer.identifier, for: indexPath) as? HeaderFooter else {
                fatalError("[XVCollectionViewDatasource] we can't take an any useable footer with id|\(footer.identifier)! Please Check it!")
            }
            view.model = footer
            return view
        }
        fatalError("[XVCollectionViewDatasource] viewForSupplementaryElementOfKind logic Error. it can't be execute!")
    }
    
}
