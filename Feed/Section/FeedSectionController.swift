//
//  FeedSectionController.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 15/7/2564 BE.
//

import Core
import Component
import IGListKit

class FeedSectionController: ListSectionController {
    var feed: Feed?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
}

// MARK: - Data Provider
extension FeedSectionController {
    enum FeedCellSection: Int, CaseIterable {
        case header = 0
//        case content
        case footer
    }
    
    override func numberOfItems() -> Int {
        return FeedCellSection.allCases.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        switch index {
        case FeedCellSection.header.rawValue:
            return HeaderFeedCell.cellSize(width: context.containerSize.width)
        case FeedCellSection.footer.rawValue:
            return FooterFeedCell.cellSize(width: context.containerSize.width)
        default:
            return .zero
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        switch index {
        case FeedCellSection.header.rawValue:
            let cell = collectionContext?.dequeueReusableCell(withNibName: FeedNibVars.CollectionViewCell.headerFeed, bundle: ConfigBundle.feed, for: self, at: index) as? HeaderFeedCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.feed = self.feed
            return cell ?? HeaderFeedCell()
        case FeedCellSection.footer.rawValue:
            let cell = collectionContext?.dequeueReusableCell(withNibName: FeedNibVars.CollectionViewCell.footerFeed, bundle: ConfigBundle.feed, for: self, at: index) as? FooterFeedCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.feed = self.feed
            return cell ?? FooterFeedCell()
        default:
            return UICollectionViewCell()
        }
    }
    
    override func didUpdate(to object: Any) {
        self.feed = object as? Feed
    }
}
