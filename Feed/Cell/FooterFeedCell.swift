//
//  FooterFeedCell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 15/7/2564 BE.
//

import UIKit
import Core

class FooterFeedCell: UICollectionViewCell {

    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var recastLabel: UILabel!
    
    var feed: Feed? {
        didSet {
            self.updateUi()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 55)
    }
    
    private func updateUi() {
        guard let feed = self.feed else { return }
        self.likeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.commentLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.recastLabel.font = UIFont.asset(.regular, fontSize: .overline)
        
        if feed.liked.liked {
            self.likeLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.like), iconColor: UIColor.Asset.lightBlue, postfixText: "  \(String.displayCount(count: feed.liked.count))", postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 14)
        } else {
            self.likeLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.like), iconColor: UIColor.Asset.white, postfixText: "  \(String.displayCount(count: feed.liked.count))", postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 14)
        }
        
        if feed.commented.commented {
            self.commentLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.comment), iconColor: UIColor.Asset.lightBlue, postfixText: "  \(String.displayCount(count: feed.commented.count))", postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 14)
        } else {
            self.commentLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.comment), iconColor: UIColor.Asset.white, postfixText: "  \(String.displayCount(count: feed.commented.count))", postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 14)
        }
        
        if feed.recasted.recasted {
            self.recastLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.recast), iconColor: UIColor.Asset.lightBlue, postfixText: "  \(String.displayCount(count: feed.recasted.count))", postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 14)
        } else {
            self.recastLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.recast), iconColor: UIColor.Asset.white, postfixText: "  \(String.displayCount(count: feed.recasted.count))", postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 14)
        }
    }
    
    @IBAction func likeAction(_ sender: Any) {
        guard let feed = self.feed else { return }
        feed.liked.liked.toggle()
        self.updateUi()
        
        if feed.liked.liked {
            let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
            impliesAnimation.duration = 0.3 * 2
            impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
            self.likeLabel.layer.add(impliesAnimation, forKey: nil)
        }
    }
    
    @IBAction func commentAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Go to comment view", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        Utility.currentViewController().present(alert, animated: true, completion: nil)
    }
    
    @IBAction func recastAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Go to recast view", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        Utility.currentViewController().present(alert, animated: true, completion: nil)
    }
    
}
