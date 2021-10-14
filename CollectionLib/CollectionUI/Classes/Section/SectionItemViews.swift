//
//  XVTableViewConreteViews.swift
//  RTSwift
//
//  Created by zuer on 2021/9/10.
//

import UIKit

public protocol XVSectionItemViews: AnyObject {
    
    var model: XVSectionItemModel? {set get}
    
    func bind(content: Any?)
 
    func onReversed(changed reversed: Any?)
}

public extension XVSectionItemViews {
    var model: XVSectionItemModel? {
        set{
            objc_setAssociatedObject(self, &XVPublicAssoiatedKey.model, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            subscriblerInstall(model: newValue)
            bind(content: newValue?.content)
        }
        get{
            return objc_getAssociatedObject(self, &XVPublicAssoiatedKey.model) as? XVSectionItemModel
        }
    }
    
    func subscriblerInstall(model: XVSectionItemModel?) {
        model?.subscrible { [weak self] e in
            switch e {
            case .content(_), .state(_):
                self?.bind(content: model?.content)
            case .reversed(let reversed):
                self?.onReversed(changed: reversed)
            }
        }
    }
    
    func onReversed(changed reversed: Any?) {}

    static var reuseId: String { return "\(self)" }
}
