//
//  UITableView+Builder.swift
//  XIAVAN
//
//  Created by zuer on 2021/9/18.
//

import UIKit


extension UITableView {
    
    public var builder: XVTableViewBuilder {
        set {
            objc_setAssociatedObject(self, &XVPublicAssoiatedKey.tableBuilder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let builder = objc_getAssociatedObject(self, &XVPublicAssoiatedKey.tableBuilder) as? XVTableViewBuilder {
                return builder
            }
            let newValue = XVTableViewBuilder(self)
            objc_setAssociatedObject(self, &XVPublicAssoiatedKey.tableBuilder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newValue
        }
    }
    
    public func registerCellClass<Cell: UITableViewCell>(_ type: Cell.Type) where Cell: XVSectionItemViews {
        self.register(Cell.classForCoder(), forCellReuseIdentifier: Cell.reuseId)
    }
    
    public func registerHeaderFooterClass<View: UITableViewHeaderFooterView>(_ type: View.Type) where View: XVSectionItemViews {
        self.register(View.classForCoder(), forHeaderFooterViewReuseIdentifier: View.reuseId)
    }

}
