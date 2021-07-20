//
//  ImageX2Cell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 18/7/2564 BE.
//

import UIKit
import Core
import ActiveLabel
import Lightbox
import Kingfisher

class ImageX2Cell: UICollectionViewCell {

    @IBOutlet var detailLabel: ActiveLabel! {
        didSet {
            self.detailLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .body)
                label.numberOfLines = 0
                label.enabledTypes = [.mention, .hashtag, .url, .email]
                label.textColor = UIColor.Asset.white
                label.hashtagColor = UIColor.Asset.lightBlue
                label.mentionColor = UIColor.Asset.lightBlue
                label.URLColor = UIColor.Asset.lightBlue
            }
        }
    }
    
    @IBOutlet var imageContainer: UIView!
    @IBOutlet var firstImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    
    var feed: Feed? {
        didSet {
            guard let feed = self.feed else { return }
            self.detailLabel.text = feed.content
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
            
            if feed.photo.count >= 2 {
                let firstUrl = URL(string: feed.photo[0].url)
                self.firstImageView.kf.setImage(with: firstUrl)
                
                let secondUrl = URL(string: feed.photo[1].url)
                self.secondImageView.kf.setImage(with: secondUrl)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageContainer.custom(cornerRadius: 12)
    }
    
    static func cellSize(width: CGFloat, text: String) -> CGSize {
        let label = ActiveLabel(frame: CGRect(x: 0, y: 0, width: width - 30, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.enabledTypes = [.mention, .hashtag, .url]
        label.text = text
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.asset(.regular, fontSize: .body)
        label.sizeToFit()
        let imageHeight = UIView.aspectRatioCalculator(ratioWidth: 16, ratioHeight: 9, pixelsWidth: Double(width - 30))
        return CGSize(width: width, height: (label.frame.height + 45 + CGFloat(imageHeight)))
    }
    
    @IBAction func viewFirstImageAction(_ sender: Any) {
        self.openImage(index: 0)
    }
    
    @IBAction func viewSecondImageAction(_ sender: Any) {
        self.openImage(index: 1)
    }
    
    private func openImage(index: Int) {
        if let feed = self.feed, !feed.photo.isEmpty {
            
            var images: [LightboxImage] = []
            feed.photo.forEach { photo in
                images.append(LightboxImage(imageURL: URL(string: photo.url)!))
            }
            
            LightboxConfig.CloseButton.textAttributes = [
                .font: UIFont.asset(.medium, fontSize: .body),
                .foregroundColor: UIColor.Asset.white
              ]
            LightboxConfig.CloseButton.text = "Close"
            
            let controller = LightboxController(images: images, startIndex: index)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.footerView.isHidden = true

            Utility.currentViewController().present(controller, animated: true, completion: nil)
        }
    }
}

extension ImageX2Cell: LightboxControllerPageDelegate {
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) { }
}

extension ImageX2Cell: LightboxControllerDismissalDelegate {
    func lightboxControllerWillDismiss(_ controller: LightboxController) { }
}
