//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  FeedSectionController.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 15/7/2564 BE.
//

import Core
import Networking
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
        case content
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
        case FeedCellSection.content.rawValue:
            if feed?.feedPayload.feedDisplayType == .postImageX1 {
                return ImageX1Cell.cellSize(width: context.containerSize.width, text: feed?.feedPayload.contentPayload.content ?? "")
            } else if feed?.feedPayload.feedDisplayType == .postImageX2 {
                return ImageX2Cell.cellSize(width: context.containerSize.width, text: self.feed?.feedPayload.contentPayload.content ?? "")
            } else if feed?.feedPayload.feedDisplayType == .postImageX3 {
                return ImageX3Cell.cellSize(width: context.containerSize.width, text: self.feed?.feedPayload.contentPayload.content ?? "")
            } else if self.feed?.feedPayload.feedDisplayType == .postImageXMore {
                return ImageXMoreCell.cellSize(width: context.containerSize.width, text: self.feed?.feedPayload.contentPayload.content ?? "")
            } else if self.feed?.feedPayload.feedDisplayType == .postText {
                return TextCell.cellSize(width: context.containerSize.width, text: self.feed?.feedPayload.contentPayload.content ?? "")
            } else if self.feed?.feedPayload.feedDisplayType == .blogImage {
                return BlogCell.cellSize(width: context.containerSize.width, header: self.feed?.feedPayload.contentPayload.header ?? "", body: self.feed?.feedPayload.contentPayload.content ?? "")
            } else if self.feed?.feedPayload.feedDisplayType == .blogNoImage {
                return BlogNoImageCell.cellSize(width: context.containerSize.width, body: self.feed?.feedPayload.contentPayload.content ?? "")
            } else {
                return TextLinkCell.cellSize(width: context.containerSize.width, text: self.feed?.feedPayload.contentPayload.content ?? "")
            }
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
        case FeedCellSection.content.rawValue:
            if self.feed?.feedPayload.feedDisplayType == .postImageX1 {
                let cell = collectionContext?.dequeueReusableCell(withNibName: FeedNibVars.CollectionViewCell.imageX1Cell, bundle: ConfigBundle.feed, for: self, at: index) as? ImageX1Cell
                cell?.backgroundColor = UIColor.Asset.darkGray
                cell?.feed = self.feed
                return cell ?? TextCell()
            } else if self.feed?.feedPayload.feedDisplayType == .postImageX2 {
                let cell = collectionContext?.dequeueReusableCell(withNibName: FeedNibVars.CollectionViewCell.imageX2Cell, bundle: ConfigBundle.feed, for: self, at: index) as? ImageX2Cell
                cell?.backgroundColor = UIColor.Asset.darkGray
                cell?.feed = self.feed
                return cell ?? ImageX2Cell()
            } else if self.feed?.feedPayload.feedDisplayType == .postImageX3 {
                let cell = collectionContext?.dequeueReusableCell(withNibName: FeedNibVars.CollectionViewCell.imageX3Cell, bundle: ConfigBundle.feed, for: self, at: index) as? ImageX3Cell
                cell?.backgroundColor = UIColor.Asset.darkGray
                cell?.feed = self.feed
                return cell ?? ImageX3Cell()
            } else if self.feed?.feedPayload.feedDisplayType == .postImageXMore {
                let cell = collectionContext?.dequeueReusableCell(withNibName: FeedNibVars.CollectionViewCell.imageXMoreCell, bundle: ConfigBundle.feed, for: self, at: index) as? ImageXMoreCell
                cell?.backgroundColor = UIColor.Asset.darkGray
                cell?.feed = self.feed
                return cell ?? ImageXMoreCell()
            } else if self.feed?.feedPayload.feedDisplayType == .postText {
                let cell = collectionContext?.dequeueReusableCell(withNibName: FeedNibVars.CollectionViewCell.postText, bundle: ConfigBundle.feed, for: self, at: index) as? TextCell
                cell?.backgroundColor = UIColor.Asset.darkGray
                cell?.feed = self.feed
                return cell ?? TextCell()
            } else if self.feed?.feedPayload.feedDisplayType == .postLink || self.feed?.feedPayload.feedDisplayType == .postYoutube {
                let cell = collectionContext?.dequeueReusableCell(withNibName: FeedNibVars.CollectionViewCell.postTextLinkCell, bundle: ConfigBundle.feed, for: self, at: index) as? TextLinkCell
                cell?.backgroundColor = UIColor.Asset.darkGray
                cell?.feed = self.feed
                return cell ?? TextLinkCell()
            } else if self.feed?.feedPayload.feedDisplayType == .blogImage {
                let cell = collectionContext?.dequeueReusableCell(withNibName: FeedNibVars.CollectionViewCell.blogCell, bundle: ConfigBundle.feed, for: self, at: index) as? BlogCell
                cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                cell?.feed = self.feed
                return cell ?? BlogCell()
            } else if self.feed?.feedPayload.feedDisplayType == .blogNoImage {
                let cell = collectionContext?.dequeueReusableCell(withNibName: FeedNibVars.CollectionViewCell.blogNoImageCell, bundle: ConfigBundle.feed, for: self, at: index) as? BlogNoImageCell
                cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                cell?.feed = self.feed
                return cell ?? BlogNoImageCell()
            } else {
                return UICollectionViewCell()
            }
        default:
            return UICollectionViewCell()
        }
    }
    
    override func didUpdate(to object: Any) {
        self.feed = object as? Feed
    }
}
