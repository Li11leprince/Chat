//  

import Foundation
import UIKit

class ChatCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                layoutAttributesForItem(at: layoutAttribute.indexPath).map {
                    layoutAttribute.frame = $0.frame
                    layoutAttribute.transform = $0.transform
                }
            }
        }
        return attributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        attributes.frame.size.width = collectionView?.frame.width ?? 0
        attributes.transform = CGAffineTransform(scaleX: 1, y: -1)
        return attributes
    }
}
