//
//  CustomCollectionView.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 26/4/23.
//

import Foundation
import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    private var cache = [UICollectionViewLayoutAttributes]()
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 3
    private var contentHeight: CGFloat = 150
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {return 0}
        return collectionView.bounds.width
    }
    override var collectionViewContentSize: CGSize {
      return CGSize(width: contentWidth, height: contentHeight)
    }
    override init() {
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
        print(collectionView?.numberOfItems(inSection: 0), "🦭")
        guard cache.isEmpty == true, let collectionView = collectionView  else {return}
        let columnWidth = 150
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let frame = CGRect(x: (2 + item * columnWidth), y: 2, width: columnWidth, height: columnWidth)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
        }
        
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in cache {
            if attribute.frame.intersects(rect) {
              visibleLayoutAttributes.append(attribute)
                    }
            }
         return visibleLayoutAttributes
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      return cache[indexPath.item]
    }
}
