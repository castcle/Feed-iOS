//
//  BlogCell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 19/7/2564 BE.
//

import UIKit

class BlogCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func cellSize(width: CGFloat, header: String, body: String) -> CGSize {
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width - 30, height: CGFloat.greatestFiniteMagnitude))
        headerLabel.numberOfLines = 2
        headerLabel.text = header
        headerLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        headerLabel.font = UIFont.asset(.medium, fontSize: .h3)
        headerLabel.sizeToFit()
        
        let bodyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width - 30, height: CGFloat.greatestFiniteMagnitude))
        bodyLabel.numberOfLines = 2
        bodyLabel.text = body
        bodyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        bodyLabel.font = UIFont.asset(.regular, fontSize: .body)
        bodyLabel.sizeToFit()
        
        let imageHeight = UIView.aspectRatioCalculator(ratioWidth: 16, ratioHeight: 9, pixelsWidth: Double(width))
        
        return CGSize(width: width, height: (headerLabel.frame.height + bodyLabel.frame.height + 35 + CGFloat(imageHeight)))
    }
}
