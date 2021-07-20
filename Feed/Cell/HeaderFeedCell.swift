//
//  HeaderFeedCell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 15/7/2564 BE.
//

import UIKit
import Core
import SnackBar_swift

public class HeaderFeedCell: UICollectionViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var globalIcon: UIImageView!
    @IBOutlet var verifyIcon: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    
    var feed: Feed? {
        didSet {
            if let feed = self.feed {
                let url = URL(string: feed.author.avatar)
                self.avatarImage.kf.setImage(with: url)
                self.displayNameLabel.text = feed.author.name
                self.dateLabel.text = feed.postDate.timeAgoDisplay()
            } else {
                return
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.displayNameLabel.font = UIFont.asset(.medium, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.dateLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.dateLabel.textColor = UIColor.Asset.lightGray
        
        self.followButton.titleLabel?.font = UIFont.asset(.medium, fontSize: .overline)
        self.followButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        
        self.verifyIcon.image = UIImage.init(icon: .castcle(.verify), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightBlue)
        self.globalIcon.image = UIImage.init(icon: .castcle(.global), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightGray)
        
        self.moreButton.setImage(UIImage.init(icon: .castcle(.ellipsisV), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
    }

    public static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 80)
    }
    
    @IBAction func followAction(_ sender: Any) {
        self.followButton.isHidden = true
        AppSnackBar.make(in: Utility.currentViewController().view, message: "You've followed @{userSlug}", duration: .lengthLong).setAction(with: "Undo", action: {
            self.followButton.isHidden = false
        }).show()
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Go to profile view", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        Utility.currentViewController().present(alert, animated: true, completion: nil)
    }
    
    @IBAction func moreAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Go to more action", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        Utility.currentViewController().present(alert, animated: true, completion: nil)
    }
}

class AppSnackBar: SnackBar {
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = UIColor.Asset.darkGray
        style.textColor = UIColor.Asset.white
        style.font = UIFont.asset(.medium, fontSize: .overline)
        
        style.actionTextColor = UIColor.Asset.lightBlue
        style.actionFont = UIFont.asset(.medium, fontSize: .body)
        style.actionTextColorAlpha = 1.0
        
        return style
    }
}
