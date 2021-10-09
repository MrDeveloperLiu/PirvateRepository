//
//  XVCollectionViewLayout.swift
//  RTSwift
//
//  Created by zuer on 2021/9/15.
//

import UIKit


public protocol XVCollectionViewLayoutDelegate {
    
    func layout(itemType layout: XVCollectionViewLayout, section: Int) -> [XVCollectionViewLayout.AttributeType]
    
    func layout(sectionInsets layout: XVCollectionViewLayout, section: Int, type: XVCollectionViewLayout.AttributeType) -> CGFloat
    func layout(sectionSize layout: XVCollectionViewLayout, section: Int, type: XVCollectionViewLayout.AttributeType) -> CGSize
    
    func layout(itemSize layout: XVCollectionViewLayout, indexPath: IndexPath) -> CGSize
    func layout(itemSpacing layout: XVCollectionViewLayout, indexPath: IndexPath) -> CGFloat
    
    func layout(itemLeading layout: XVCollectionViewLayout) -> CGFloat
    func layout(itemTrailing layout: XVCollectionViewLayout) -> CGFloat
    
    func layout(didFinished layout: XVCollectionViewLayout)
}

public extension XVCollectionViewLayoutDelegate {
    func layout(itemType layout: XVCollectionViewLayout, section: Int) -> [XVCollectionViewLayout.AttributeType] {
        let sectionItem = layout.collectionView!.builder.state.sections[section]
        var types: [XVCollectionViewLayout.AttributeType] = [.cell]
        if let _ = sectionItem.header {
            types.append(.header)
        }
        if let _ = sectionItem.footer {
            types.append(.footer)
        }
        return types
    }    
    func layout(sectionInsets layout: XVCollectionViewLayout, section: Int, type: XVCollectionViewLayout.AttributeType) -> CGFloat {
        return 0
    }    
    func layout(sectionSize layout: XVCollectionViewLayout, section: Int, type: XVCollectionViewLayout.AttributeType) -> CGSize {
        let sectionItem = layout.collectionView!.builder.state.sections[section]
        if type == .header, let header = sectionItem.header {
            return header.size
        }
        if type == .footer, let footer = sectionItem.footer {
            return footer.size
        }
        return .zero
    }
    func layout(itemSize layout: XVCollectionViewLayout, indexPath: IndexPath) -> CGSize {
        let sectionItem = layout.collectionView!.builder.state.sections[indexPath.section]
        let rowItem = sectionItem.rows[indexPath.item]
        return rowItem.size
    }
    func layout(itemSpacing layout: XVCollectionViewLayout, indexPath: IndexPath) -> CGFloat {
        return 0
    }
    func layout(itemLeading layout: XVCollectionViewLayout) -> CGFloat {
        return 0
    }
    func layout(itemTrailing layout: XVCollectionViewLayout) -> CGFloat {
        return 0
    }
    func layout(didFinished layout: XVCollectionViewLayout) {
        
    }
}


open class XVCollectionViewLayout: UICollectionViewLayout {
    public typealias Delegate = AnyObject & XVCollectionViewLayoutDelegate
    public enum AttributeType {
        case cell
        case header
        case footer
    }
    public enum Direction {
        case horizontal
        case vertical
        case flow
        case flowFreedom
    }
    
    public weak var delegate: Delegate?
    // 布局方向
    public var direction: Direction = .horizontal
    // flow 模式下仅仅left+right生效
    public var itemsInsets: UIEdgeInsets = .zero
    // flow 模式下垂直距离
    public var itemVerticalMargin: CGFloat = 0
    
    private var attributes: [UICollectionViewLayoutAttributes] = []
    private var viewSize: CGSize = .zero
    private var viewSizeMax: CGSize = .zero    
}

public extension XVCollectionViewLayout {
    
    override func prepare() {
        super.prepare()
        preLayout()
        afterLayout()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        return viewSize
    }    
    
}

//-MARK: Private
extension XVCollectionViewLayout {
    private func preLayout() {
        guard let collectionView = self.collectionView, let delegate = self.delegate else {
            return
        }
        var last: UICollectionViewLayoutAttributes? = nil
        var attributes: [UICollectionViewLayoutAttributes] = []
        
        let sections = 0..<collectionView.numberOfSections
        sections.forEach { section in
                            
            let types = delegate.layout(itemType: self, section: section)
            /// header
            if types.contains(.header) {
                let attribute = layoutHeaderFooterAttribute(from: section, last: last, type: .header)
                attributes.append(attribute)
                last = attribute
            }
            /// cells
            if types.contains(.cell) {
                let rows = 0..<collectionView.numberOfItems(inSection: section)
                rows.forEach { row in
                    let indexPath = IndexPath(item: row, section: section)
                    let attribute: UICollectionViewLayoutAttributes
                    
                    switch direction {
                    case .flow:
                        attribute = layoutAttributeFlow(from: indexPath, last: last, v: collectionView)
                    case .flowFreedom:
                        attribute = layoutAttributeFlowFreedom(from: indexPath, last: last, v: collectionView)
                    default:
                        attribute = layoutAttribute(from: indexPath, last: last, v: collectionView)
                    }
                    
                    attributes.append(attribute)
                    last = attribute
                }
            }
            /// footer
            if types.contains(.footer) {
                let attribute = layoutHeaderFooterAttribute(from: section, last: last, type: .footer)
                attributes.append(attribute)
                last = attribute
            }
            
        }
        self.attributes = attributes
        // content size
        self.preContentSize(last: last)
    }
    
    private func preContentSize(last: UICollectionViewLayoutAttributes?) {
        if let lastFrame = last?.frame {
            let trailing: CGFloat = delegate?.layout(itemTrailing: self) ?? 0
            switch direction {
            case .horizontal:
                viewSize = CGSize(width: lastFrame.maxX + trailing, height: viewSizeMax.height)
            case .vertical, .flow, .flowFreedom:
                viewSize = CGSize(width: viewSizeMax.width, height: lastFrame.maxY + trailing)
            }
        }else{
            viewSize = .zero
        }
    }
    
    private func afterLayout() {
        delegate?.layout(didFinished: self)
    }

}

//-MARK: Header Footer
extension XVCollectionViewLayout {
 
    func layoutHeaderFooterAttribute(from section: Int, last: UICollectionViewLayoutAttributes?, type: XVCollectionViewLayout.AttributeType) -> UICollectionViewLayoutAttributes {
        
        let attribute: UICollectionViewLayoutAttributes
        let horizontal: CGFloat
        let vertical: CGFloat
        let insets = delegate?.layout(sectionInsets: self, section: section, type: type) ?? 0

        switch type {
        case .header:
            let leading: CGFloat = delegate?.layout(itemLeading: self) ?? 0
            horizontal = (section == 0) ? leading : insets
            vertical = (section == 0) ? leading : insets
            
            let indexPath = IndexPath(item: UICollectionView.Kind.header.rawValue, section: section)
            attribute =  UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            break
        case .footer:
            horizontal = insets
            vertical = insets

            let indexPath = IndexPath(item: UICollectionView.Kind.footer.rawValue, section: section)
            attribute =  UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
            break
        default:
            fatalError("[XVCollectionViewLayout] logic wrong!")
        }
                
        let itemSize = delegate?.layout(sectionSize: self, section: section, type: type) ?? .zero

        let x: CGFloat
        let y: CGFloat
                
        switch direction {
        case .horizontal:
            if let lastFrame = last?.frame {
                x = lastFrame.maxX + horizontal
                y = lastFrame.minY
            }else{
                x = horizontal
                y = 0
            }
            break
        case .vertical, .flow, .flowFreedom:
            x = 0
            if let lastFrame = last?.frame {
                y = lastFrame.maxY + vertical
            }else{
                y = vertical
            }
            break
        }
        
        attribute.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
        
        viewSizeMax = CGSize(width: max(viewSizeMax.width, attribute.frame.width), height: max(viewSizeMax.height, attribute.frame.height))
        
        return attribute
    }
    
}

//-MARK: Cells (hor, ver)
extension XVCollectionViewLayout {
    func layoutAttribute(from indexPath: IndexPath, last: UICollectionViewLayoutAttributes?, v: UICollectionView) -> UICollectionViewLayoutAttributes {
                
        let spacing: CGFloat
        if indexPath.item == 0 {
            let insets = delegate?.layout(sectionInsets: self, section: indexPath.section, type: .cell) ?? 0
            let leading: CGFloat = delegate?.layout(itemLeading: self) ?? 0
            switch direction {
            case .horizontal:
                spacing = insets + leading
                break
            case .vertical:
                spacing = insets + leading
                break
            default:
                fatalError("[XVCollectionViewLayout] logic wrong!")
                break
            }
        }else{
            spacing = delegate?.layout(itemSpacing: self, indexPath: indexPath) ?? 0
        }

        let attribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                                        
        let itemSize = delegate?.layout(itemSize: self, indexPath: indexPath) ?? .zero
        
        let x: CGFloat
        let y: CGFloat
        switch direction {
        case .horizontal:
            if let lastFrame = last?.frame {
                x = lastFrame.maxX + spacing
                y = lastFrame.minY
            }else{
                x = spacing
                y = max(0, (v.frame.height - itemSize.height) / 2)
            }
            break
        case .vertical:
            if let lastFrame = last?.frame {
                x = lastFrame.minX
                y = lastFrame.maxY + spacing
            }else{
                x = max(0, (v.frame.width - itemSize.width) / 2)
                y = spacing
            }
            break
        default:
            fatalError("[XVCollectionViewLayout] logic wrong!")
            break
        }
        
        attribute.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
        
        viewSizeMax = CGSize(width: max(viewSizeMax.width, attribute.frame.width), height: max(viewSizeMax.height, attribute.frame.height))
        
        return attribute
    }

}

//-MARK: Cells flow

extension XVCollectionViewLayout {
    func layoutAttributeFlow(from indexPath: IndexPath, last: UICollectionViewLayoutAttributes?, v: UICollectionView) -> UICollectionViewLayoutAttributes {
                
        let attribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                                        
        let itemSize = delegate?.layout(itemSize: self, indexPath: indexPath) ?? .zero
        
        if let collectionView = self.collectionView {
            
            let initialLeft = itemsInsets.left
            let collectionViewWidth = collectionView.frame.width - (itemsInsets.left + itemsInsets.right)
            precondition(collectionViewWidth > 0, "[XVCollectionViewLayout] please check your itemsInsets or collectionView.frame.width. left width is: \(collectionViewWidth), that means something wrong!")
            
            let numberPerRows = collectionViewWidth / itemSize.width
            
            let realRows = floor(numberPerRows)
            let cellsWidth = (realRows * itemSize.width)
            let marginCount = realRows - 1
            
            let horizontalMargin: CGFloat
            if marginCount > 0 {
                horizontalMargin = max(collectionViewWidth - cellsWidth, 0) / marginCount
            }else{
                horizontalMargin = 0
            }
            
            let x: CGFloat
            let y: CGFloat
            
            let width: CGFloat = min(itemSize.width, collectionViewWidth)
            let height: CGFloat = itemSize.height
                        
            if let lastFrame = last?.frame {
                if indexPath.item == 0 {
                    let insets = delegate?.layout(sectionInsets: self, section: indexPath.section, type: .cell) ?? 0
                    x = initialLeft
                    y = lastFrame.maxY + insets
                }else{
                    let nextX = lastFrame.maxX + horizontalMargin
                    // 这里理应是最大X超出，则换行
                    let nextMaxX = nextX + width
                    if nextMaxX > collectionViewWidth {
                        x = initialLeft
                        y = lastFrame.maxY + itemVerticalMargin
                    }else{
                        x = nextX
                        y = lastFrame.minY
                    }
                }
            }else{
                let insets = delegate?.layout(sectionInsets: self, section: indexPath.section, type: .cell) ?? 0
                x = initialLeft
                y = insets
            }
            
            attribute.frame = CGRect(x: x, y: y, width: width, height: height)
        }
                
        viewSizeMax = CGSize(width: max(viewSizeMax.width, attribute.frame.width), height: max(viewSizeMax.height, attribute.frame.height))
        
        return attribute
    }

    func layoutAttributeFlowFreedom(from indexPath: IndexPath, last: UICollectionViewLayoutAttributes?, v: UICollectionView) -> UICollectionViewLayoutAttributes {
                
        let attribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                                        
        let itemSize = delegate?.layout(itemSize: self, indexPath: indexPath) ?? .zero
        
        if let collectionView = self.collectionView {
            
            let initialLeft = itemsInsets.left
            let collectionViewWidth = collectionView.frame.width - (itemsInsets.left + itemsInsets.right)
            precondition(collectionViewWidth > 0, "[XVCollectionViewLayout] please check your itemsInsets or collectionView.frame.width. left width is: \(collectionViewWidth), that means something wrong!")
            
            let spacing = delegate?.layout(itemSpacing: self, indexPath: indexPath) ?? 0

            let x: CGFloat
            let y: CGFloat
            
            let width: CGFloat = min(itemSize.width, collectionViewWidth)
            let height: CGFloat = itemSize.height
                        
            if let lastFrame = last?.frame {
                if indexPath.item == 0 {
                    let insets = delegate?.layout(sectionInsets: self, section: indexPath.section, type: .cell) ?? 0
                    x = initialLeft
                    y = lastFrame.maxY + insets
                }else{
                    let nextX = lastFrame.maxX + spacing
                    // 这里理应是最大X超出，则换行
                    let nextMaxX = nextX + width
                    if nextMaxX > collectionViewWidth {
                        x = initialLeft
                        y = lastFrame.maxY + itemVerticalMargin
                    }else{
                        x = nextX
                        y = lastFrame.minY
                    }
                }
            }else{
                let insets = delegate?.layout(sectionInsets: self, section: indexPath.section, type: .cell) ?? 0
                x = initialLeft
                y = insets
            }
            
            attribute.frame = CGRect(x: x, y: y, width: width, height: height)
        }
                
        viewSizeMax = CGSize(width: max(viewSizeMax.width, attribute.frame.width), height: max(viewSizeMax.height, attribute.frame.height))
        
        return attribute
    }

}
    
