//
//  PostCollectionViewCell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 12/7/2564 BE.
//

import UIKit
import Core
import Kingfisher

class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet var searchView: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var placeholderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.searchView.custom(color: UIColor.Asset.darkGray, cornerRadius: 18, borderWidth: 2, borderColor: UIColor.Asset.black)
        self.profileImage.circle(color: UIColor.Asset.black)
        self.placeholderLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.placeholderLabel.textColor = UIColor.Asset.lightGray
        
        let url = URL(string: "https://images.mubicdn.net/images/cast_member/2184/cache-2992-1547409411/image-w856.jpg")
        self.profileImage.kf.setImage(with: url)
    }
    
    static func cellSize(width: CGFloat) -> CGSize {
//        let labelBounds = TextSize.size(text, font: MessageCell.font, width: width, insets: CommonInsets)
        return CGSize(width: width, height: 60)
    }
    @IBAction func postAction(_ sender: Any) {
    }
    
    @IBAction func profileAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Go to post view", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
