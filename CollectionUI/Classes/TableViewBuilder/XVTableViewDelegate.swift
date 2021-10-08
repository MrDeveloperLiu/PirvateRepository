//
//  XVTableViewHolderDelegate.swift
//  RTSwift
//
//  Created by zuer on 2021/9/10.
//

import UIKit

class XVTableViewDelegate: XVCollectionBuilderGetter<XVTableViewBuilder>, UITableViewDelegate {
    
    typealias HeaderFooter = (UITableViewHeaderFooterView & XVSectionItemViews)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let builder = self.builder,
              let rowGetter = self.rowGetter(indexPath: indexPath) else {
            return
        }
        builder.uiSelecter?(true, rowGetter)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let builder = self.builder,
              let rowGetter = self.rowGetter(indexPath: indexPath) else {
            return
        }
        builder.uiSelecter?(false, rowGetter)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionGetter = self.sectionGetter(section: section),
              let header = sectionGetter.header else {
            return 0.0
        }
        return header.size.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let sectionGetter = self.sectionGetter(section: section),
              let footer = sectionGetter.footer else {
            return 0.0
        }
        return footer.size.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let rowGetter = self.rowGetter(indexPath: indexPath) else {
            return 0.0
        }
        return rowGetter.size.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionGetter = self.sectionGetter(section: section),
              let header = sectionGetter.header else {
            return nil
        }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.identifier) as? HeaderFooter else {
            fatalError("[XVTableViewDelegate] we can't take an any useable header with id|\(header.identifier)! Please Check it!")
        }
        view.model = header
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let sectionGetter = self.sectionGetter(section: section),
              let footer = sectionGetter.footer else {
            return nil
        }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: footer.identifier) as? HeaderFooter else {
            fatalError("[XVTableViewDelegate] we can't take an any useable footer with id|\(footer.identifier)! Please Check it!")
        }
        view.model = footer
        return view
    }
}
