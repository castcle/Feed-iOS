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
//  BlogCell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 19/7/2564 BE.
//

import UIKit
import Core
import Networking
import Kingfisher
import Nantes

class BlogCell: UICollectionViewCell {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var detailLabel: NantesLabel! {
        didSet {
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue,
                              NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .body)]
            self.detailLabel.attributedTruncationToken = NSAttributedString(string: " Read More...", attributes: attributes)
            self.detailLabel.numberOfLines = 2
        }
    }
    @IBOutlet var blogImageView: UIImageView!
    
    var feed: Feed? {
        didSet {
            guard let feed = self.feed else { return }
            self.headerLabel.font = UIFont.asset(.medium, fontSize: .h3)
            self.headerLabel.textColor = UIColor.Asset.white
            self.detailLabel.font = UIFont.asset(.regular, fontSize: .body)
            self.detailLabel.textColor = UIColor.Asset.lightGray
            
            self.headerLabel.text = feed.feedPayload.contentPayload.header
            self.detailLabel.text = feed.feedPayload.contentPayload.content
            
            let imageUrl = URL(string: feed.feedPayload.contentPayload.cover)
            self.blogImageView.kf.setImage(with: imageUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func cellSize(width: CGFloat, header: String, body: String) -> CGSize {
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width - 30, height: CGFloat.greatestFiniteMagnitude))
        headerLabel.numberOfLines = 2
        headerLabel.text = header
        headerLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        headerLabel.font = UIFont.asset(.medium, fontSize: .h3)
        headerLabel.sizeToFit()
        
        let bodyLabel = NantesLabel(frame: CGRect(x: 0, y: 0, width: width - 30, height: CGFloat.greatestFiniteMagnitude))
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue,
                          NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .body)]
        bodyLabel.attributedTruncationToken = NSAttributedString(string: " Read More...", attributes: attributes)
        bodyLabel.numberOfLines = 2
        bodyLabel.text = body
        bodyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        bodyLabel.font = UIFont.asset(.regular, fontSize: .body)
        bodyLabel.sizeToFit()
        
        let imageHeight = UIView.aspectRatioCalculator(ratioWidth: 16, ratioHeight: 9, pixelsWidth: Double(width))
        
        return CGSize(width: width, height: (headerLabel.frame.height + bodyLabel.frame.height + 35 + CGFloat(imageHeight)))
    }
}
