//
//  UIScrollView+Refresh.swift
//  XIAVAN
//
//  Created by zuer on 2021/9/18.
//

import UIKit


extension UIScrollView {
    
    /*
     默认支持下拉刷新与上拉加载
     
     如只想支持一种请调用
     scrollView.refresher = XVRefreshComponent(scrollView: scrollView, option: .refresh)
     scrollView.refresher = XVRefreshComponent(scrollView: scrollView, option: .load)
     */
    
    var refresher: XVRefreshComponent {
        set {
            objc_setAssociatedObject(self, &XVPublicAssoiatedKey.refreshView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let builder = objc_getAssociatedObject(self, &XVPublicAssoiatedKey.refreshView) as? XVRefreshComponent {
                return builder
            }
            let newValue = XVRefreshComponent(scrollView: self)
            objc_setAssociatedObject(self, &XVPublicAssoiatedKey.refreshView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newValue
        }
    }
    
    func setRefreshRequest(with closure: @escaping XVRefreshComponent.Entry) {
        refresher.refreshClosure = closure
    }
    
    func setNomoreDataHandler(with closure: @escaping () -> Void) {
        refresher.nomoreClosure = closure
    }
}

