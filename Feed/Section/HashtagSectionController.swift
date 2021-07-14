//
//  HashtagSectionController.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 13/7/2564 BE.
//

import Core
import IGListKit

class HashtagSectionController: ListSectionController {
    var hashtagShelf: HashtagShelf?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

// MARK: - Data Provider
extension HashtagSectionController {
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        return HashtagCell.cellSize(width: context.containerSize.width)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(withNibName: FeedNibVars.CollectionViewCell.hashtag, bundle: ConfigBundle.feed, for: self, at: index) as? HashtagCell
        cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
        cell?.hashtagShelf = hashtagShelf
        return cell ?? HashtagCell()
    }
    
    override func didUpdate(to object: Any) {
        hashtagShelf = object as? HashtagShelf
    }
}
