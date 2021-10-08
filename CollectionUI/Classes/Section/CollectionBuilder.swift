//
//  CollectionBuilder.swift
//  RTSwift
//
//  Created by zuer on 2021/9/15.
//

import Foundation

struct CollectionState<ItemType>: SectionModelState {
    typealias Item = ItemType
        
    var sections: [Sections]
    var event: SectionModelEvent
}

protocol CollectionBuilder {
    associatedtype ItemType
    
    typealias SelectClosure = (Bool, ItemType) -> Void
    typealias UpdaterClosure = (SectionModelEvent) -> Void
    
    typealias Sections = XVSectionModel<ItemType>
    
    var state: CollectionState<ItemType> {get set}
    
    var uiUpdater: UpdaterClosure? {get set}
    var uiSelecter: SelectClosure? {get set}
    
    func sectionWithIndexPath(_ indexPath: IndexPath) -> Int
    func rowWithIndexPath(_ indexPath: IndexPath) -> Int 
}

extension CollectionBuilder {
    mutating func setUpdateClosure(closure: UpdaterClosure?) {
        self.uiUpdater = closure
    }
    
    mutating func setSelectClosure(closure: SelectClosure?) {
        self.uiSelecter = closure
    }
}


class XVCollectionBuilderGetter<Builder: AnyObject>: NSObject where Builder: CollectionBuilder {
    weak var builder: Builder?
    init(_ builder: Builder) {
        self.builder = builder
    }
}

extension XVCollectionBuilderGetter {
    var sectionsGetter: [Builder.Sections]? {
        guard let builder = self.builder else {
            return nil
        }
        
        return builder.state.sections
    }
    
    func sectionGetter(section: Int) -> Builder.Sections? {
        guard let builder = self.builder else {
            return nil
        }
        let s = builder.state.sections[section]
        return s
    }
    
    func rowsGetter(section: Int) -> [Builder.Sections.Item]? {
        guard let builder = self.builder else {
            return nil
        }
        let s = builder.state.sections[section]
        return s.rows
    }
    
    func rowGetter(indexPath: IndexPath) -> Builder.Sections.Item? {
        guard let builder = self.builder else {
            return nil
        }
        let section = builder.sectionWithIndexPath(indexPath)
        let s = builder.state.sections[section]        
        let row = builder.rowWithIndexPath(indexPath)
        let r = s.rows[row]
        return r
    }
}


