//
//  XVTableViewHolderDatasource.swift
//  RTSwift
//
//  Created by zuer on 2021/9/10.
//

import UIKit

class XVTableViewDatasource: XVCollectionBuilderGetter<XVTableViewBuilder>, UITableViewDataSource {
    
    typealias Cell = (UITableViewCell & XVSectionItemViews)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsGetter = self.sectionsGetter else {
            return 0
        }
        return sectionsGetter.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowsGetter = self.rowsGetter(section: section) else {
            return 0
        }
        return rowsGetter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.rowGetter(indexPath: indexPath) else {
            fatalError("[XVTableViewDatasource] something wrong with datas!")
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath) as? Cell else {
            fatalError("[XVTableViewDatasource] we can't take an any useable cell with id|\(item.identifier)! Please Check it!")
        }
        cell.model = item
        return cell
    }
    
}
