//
//  NewPostCell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 12/7/2564 BE.
//

import UIKit
import Core
import Kingfisher

class NewPostCell: UICollectionViewCell {

    @IBOutlet var searchView: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var placeholderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.searchView.custom(color: UIColor.Asset.darkGray, cornerRadius: 18, borderWidth: 1, borderColor: UIColor.Asset.darkGraphiteBlue)
        self.profileImage.circle(color: UIColor.Asset.darkGraphiteBlue)
        self.placeholderLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.placeholderLabel.textColor = UIColor.Asset.lightGray
        
        let url = URL(string: "https://images.mubicdn.net/images/cast_member/2184/cache-2992-1547409411/image-w856.jpg")
        self.profileImage.kf.setImage(with: url)
    }
    
    static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 60)
    }
    
    @IBAction func postAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Go to post view", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        Utility.currentViewController().present(alert, animated: true, completion: nil)
    }
    
    @IBAction func profileAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Go to profile view", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        Utility.currentViewController().present(alert, animated: true, completion: nil)
    }
}
