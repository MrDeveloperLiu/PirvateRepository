//
//  SectionModelState.swift
//  RTSwift
//
//  Created by zuer on 2021/9/14.
//

import Foundation

public enum SectionModelEvent {
    case none
    
    case refresh
    case load
    
    case updateRow(item: Int, section: Int)
    case updateSection(section: Int)
    
    case deleteRow(item: Int, section: Int)
    case deleteSection(section: Int)
}

public protocol SectionModelState {
    associatedtype Item
    typealias Sections = XVSectionModel<Item>
    
    var sections: [Sections] {get set}
    var event: SectionModelEvent {get set}
 
    init(sections: [Sections], event: SectionModelEvent)
}

// MARK: 操作Section
extension SectionModelState {
    mutating func reset(sections: [Sections]) {
        self = Self.init(sections: sections, event: .refresh)
    }

    mutating func append(sections: [Sections]) {
        var sectionsCopy = self.sections
        sectionsCopy.append(contentsOf: sections)
        self = Self.init(sections: sectionsCopy, event: .load)
    }

    mutating func update(s: Sections, section: Int) {
        var sectionsCopy = self.sections
        sectionsCopy[section] = s
        self = Self.init(sections: sectionsCopy, event: .updateSection(section: section))
    }
    
    mutating func remove(section: Int, needRemoved: Bool = true) {
        var sectionsCopy = self.sections
        sectionsCopy.remove(at: section)
        if sectionsCopy.isEmpty && needRemoved {
            self = Self.init(sections: sectionsCopy, event: .refresh)
        }else{
            self = Self.init(sections: sectionsCopy, event: .deleteSection(section: section))
        }
    }
}

// MARK: 操作Row
extension SectionModelState {
        
    mutating func reset(rows: [Item], section: Int, header: Item? = nil, footer: Item? = nil) {
        var sectionsCopy = sections
        sectionsCopy[section].rows = rows
        if let h = header {
            sectionsCopy[section].header = h
        }
        if let f = footer {
            sectionsCopy[section].footer = f
        }
        self = Self.init(sections: sectionsCopy, event: .refresh)
    }

    mutating func append(rows: [Item], section: Int, header: Item? = nil, footer: Item? = nil) {
        var sectionsCopy = sections
        sectionsCopy[section].rows.append(contentsOf: rows)
        if let h = header {
            sectionsCopy[section].header = h
        }
        if let f = footer {
            sectionsCopy[section].footer = f
        }
        self = Self.init(sections: sectionsCopy, event: .load)
    }
    
    mutating func remove(at index: Int, section: Int, needRemoved: Bool = true) {
        var sectionsCopy = sections
        sectionsCopy[section].rows.remove(at: index)
        if sectionsCopy[section].rows.isEmpty && needRemoved {
            sectionsCopy.remove(at: section)
            self = Self.init(sections: sectionsCopy, event: .refresh)
        }else{            
            self = Self.init(sections: sectionsCopy, event: .deleteRow(item: index, section: section))
        }
    }
    
    mutating func update(at index: Int, item: Item, section: Int, header: Item? = nil, footer: Item? = nil) {
        var sectionsCopy = sections
        sectionsCopy[section].rows[index] = item
        if let h = header {
            sectionsCopy[section].header = h
        }
        if let f = footer {
            sectionsCopy[section].footer = f
        }
        self = Self.init(sections: sectionsCopy, event: .updateRow(item: index, section: section))
    }
    
}
