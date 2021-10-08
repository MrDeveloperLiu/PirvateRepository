//
//  SectionModel.swift
//  RTSwift
//
//  Created by zuer on 2021/9/14.
//

import UIKit

public struct XVSectionModel<Model> {
    public typealias Item = Model
    public var header: Item?
    public var footer: Item?
    public var rows: [Item] = []
    
    public init(header: Item? = nil, footer: Item? = nil, rows: [Item] = []) {
        self.header = header
        self.footer = footer
        self.rows = rows
    }
}

public extension XVSectionModel {
    func index(of item: Item) -> Int? where Item: Equatable {
        return rows.firstIndex { $0 == item}
    }
}

public class XVSectionItemModel {
    public typealias SubscriptionClosure = (_ subscript: Subscript) -> Void
    public typealias BinderClosure = (_ event: Any) -> Void

    public struct State {
        public var selected: Bool
    }
    public enum Subscript {
        case content(content: Any?)
        case reversed(reversed: Any?)
        case state(s: State)
    }
    /// 状态
    public var state: State = State(selected: false) { didSet { publish(.state(s: state)) } }
    /// 模型对象
    public var content: Any? { didSet { publish(.content(content: content)) } }
    /// 预留字段
    public var reversed: Any? { didSet { publish(.reversed(reversed: reversed)) } }
    /// 存储型字段
    public var stored: Any?
    /// viewClass
    public var viewClass: AnyClass?
    /// 大小
    public var size: CGSize = .zero
    /// 订阅者(用于更新数据)
    fileprivate var UISubscribler: SubscriptionClosure?
    /// UI代理
    fileprivate var UIBinder: BinderClosure?
    /// 唯一标识
    private let id: String = UUID().uuidString
}

extension XVSectionItemModel: Equatable {
    public static func == (lhs: XVSectionItemModel, rhs: XVSectionItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}

public extension XVSectionItemModel {
    /// row 订阅model的更新
    func subscrible(_ subscription: @escaping SubscriptionClosure) {
        UISubscribler = subscription
    }
    func publish(_ e: Subscript) {
        UISubscribler?(e)
    }
    
    /// ui 绑定row发出的事件 (通常由row的订阅者发出，回调给UI事件)
    func binding(_ binder: @escaping BinderClosure) {
        UIBinder = binder
    }
    func on(event: Any) {
        UIBinder?(event)
    }
    
    var identifier: String {
        precondition(viewClass != nil, "[Error]: XVSectionItemModel.viewClass must not be null!")
        return "\(viewClass!.self)"
    }
}

public final class XVTableViewRow: XVSectionItemModel {
    public convenience init(content: Any?, viewClass: AnyClass?, UIBinder: BinderClosure? = nil, size: CGSize = CGSize(width: 0, height: UITableView.automaticDimension)) {
        self.init()
        self.content = content
        self.viewClass = viewClass
        self.UIBinder = UIBinder
        self.size = size
    }
}

public final class XVCollectionViewItem: XVSectionItemModel {
    public convenience init(content: Any?, viewClass: AnyClass?, UIBinder: BinderClosure? = nil, size: CGSize = CGSize(width: 0, height: 0)) {
        self.init()
        self.content = content
        self.viewClass = viewClass
        self.UIBinder = UIBinder
        self.size = size
    }
}

public typealias XVTableViewSection = XVSectionModel<XVTableViewRow>
public typealias XVCollectionViewSection = XVSectionModel<XVCollectionViewItem>
