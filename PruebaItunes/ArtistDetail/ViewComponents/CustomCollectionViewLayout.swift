//
//  CustomCollectionView.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 26/4/23.
//

import Foundation
import UIKit

class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    private var cache = [UICollectionViewLayoutAttributes]()
    private var albumList: [AlbumModel]?
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 3
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.bounds.width
    }
    override init() {
        super.init()
    }
    init(albumList: [AlbumModel]) {
        self.albumList = albumList
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
        guard cache.isEmpty == true, let albumList = self.albumList, albumList.count > 0  else {
            return
        }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        var yOffset = [CGFloat]()
        var column = 0
        var line = 0
        xOffset.append(CGFloat(0))
        yOffset.append(CGFloat(0))
        var frame = CGRect(x: xOffset[0], y: yOffset[0], width: columnWidth, height: columnWidth)
        for item in 0 ... (albumList.count) {
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            column = column + 1
            if column % numberOfColumns == 0 {
                column = 0
                xOffset.append(CGFloat(0))
                print(xOffset)
                line = line + 1
                yOffset.append(CGFloat(line) * columnWidth)
                print(yOffset)
            } else {
                xOffset.append(columnWidth * CGFloat(column))
                yOffset.append(CGFloat(line) * columnWidth)
            }
            frame = CGRect(x: xOffset[item], y: yOffset[item], width: columnWidth, height: columnWidth)
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
