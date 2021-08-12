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
//  TextLinkCell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 16/7/2564 BE.
//

import UIKit
import LinkPresentation
import Core
import Networking
import ActiveLabel

class TextLinkCell: UICollectionViewCell {

    @IBOutlet var detailLabel: ActiveLabel! {
        didSet {
            self.detailLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .body)
                label.numberOfLines = 0
                label.enabledTypes = [.mention, .hashtag, .url]
                label.textColor = UIColor.Asset.white
                label.hashtagColor = UIColor.Asset.lightBlue
                label.mentionColor = UIColor.Asset.lightBlue
                label.URLColor = UIColor.Asset.lightBlue
            }
        }
    }
    
    @IBOutlet var linkContainer: UIView!
    
    private var linkView: LPLinkView = LPLinkView(metadata: LPLinkMetadata())
    var feed: Feed? {
        didSet {
            guard let feed = self.feed else { return }
            self.detailLabel.text = feed.feedPayload.contentPayload.content
            self.detailLabel.handleHashtagTap { hashtag in
                let alert = UIAlertController(title: nil, message: "Go to hastag view", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                Utility.currentViewController().present(alert, animated: true, completion: nil)
            }
            self.detailLabel.handleMentionTap { mention in
                let alert = UIAlertController(title: nil, message: "Go to mention view", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                Utility.currentViewController().present(alert, animated: true, completion: nil)
            }
            self.detailLabel.handleURLTap { url in
                let alert = UIAlertController(title: nil, message: "Go to url view", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                Utility.currentViewController().present(alert, animated: true, completion: nil)
            }
            self.addLinkViewToLinkLinkContainer()
            self.fetchPreview(feed: feed)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.linkContainer.custom(cornerRadius: 12)
    }
    
    static func cellSize(width: CGFloat, text: String) -> CGSize {
        let label = ActiveLabel(frame: CGRect(x: 0, y: 0, width: width - 30, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.enabledTypes = [.mention, .hashtag, .url]
        label.text = text
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.asset(.regular, fontSize: .body)
        label.sizeToFit()
        let imageHeight = UIView.aspectRatioCalculator(ratioWidth: 29, ratioHeight: 20, pixelsWidth: Double(width - 30))
        return CGSize(width: width, height: (label.frame.height + 45 + CGFloat(imageHeight)))
    }
    
    private func addLinkViewToLinkLinkContainer() {
        DispatchQueue.main.async {
            self.linkView.frame = self.linkContainer.bounds
            self.linkContainer.addSubview(self.linkView)
            self.linkContainer.sizeToFit()
        }
    }

    private func fetchPreview(feed: Feed) {
        if let link = feed.feedPayload.contentPayload.link.first, let url = URL(string: link.url) {
            let metaDataProvider = LPMetadataProvider()
            
            metaDataProvider.startFetchingMetadata(for: url) { [weak self]  (metaData, error) in
                if let error = error {
                    print(error)
                } else if let metaData = metaData {
                    DispatchQueue.main.async { [weak self] in
                        self?.linkView.metadata = metaData
                    }
                }
            }
        }
    }
}
