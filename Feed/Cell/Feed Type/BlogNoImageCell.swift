//
//  BlogNoImageCell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 22/7/2564 BE.
//

import UIKit
import Core
import Kingfisher
import SwiftColor
import Nantes

class BlogNoImageCell: UICollectionViewCell {

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
            self.headerLabel.font = UIFont.asset(.medium, fontSize: .h2)
            self.headerLabel.textColor = UIColor.Asset.white
            self.detailLabel.font = UIFont.asset(.regular, fontSize: .body)
            self.detailLabel.textColor = UIColor.Asset.lightGray
            
            self.headerLabel.text = feed.feedPayload.contentPayload.header
            self.detailLabel.text = feed.feedPayload.contentPayload.content
            
            self.blogImageView.image = UIColor.Asset.black.toImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func cellSize(width: CGFloat, body: String) -> CGSize {
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
        
        return CGSize(width: width, height: (bodyLabel.frame.height + 30 + CGFloat(imageHeight)))
    }
}
