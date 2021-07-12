//
//  PostSectionController.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 12/7/2564 BE.
//

import Core
import IGListKit

class PostSectionController: ListSectionController {
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

// MARK: - Data Provider
extension PostSectionController {
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard
          let context = collectionContext
          else {
            return .zero
        }
        return PostCollectionViewCell.cellSize(width: context.containerSize.width)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(withNibName: FeedNibVars.CollectionViewCell.post, bundle: ConfigBundle.feed, for: self, at: index) ?? PostCollectionViewCell()
        cell.backgroundColor = UIColor.Asset.darkGray
        return cell
    }
}
