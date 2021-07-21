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
//  ImageX3Cell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 19/7/2564 BE.
//

import UIKit
import Core
import ActiveLabel
import Lightbox
import Kingfisher

class ImageX3Cell: UICollectionViewCell {

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
    
    @IBOutlet var imageContainer: UIView!
    @IBOutlet var firstImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    @IBOutlet var thirdImageView: UIImageView!
    
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
            
            if feed.feedPayload.contentPayload.photo.count >= 3 {
                let firstUrl = URL(string: feed.feedPayload.contentPayload.photo[0].url)
                self.firstImageView.kf.setImage(with: firstUrl)
                
                let secondUrl = URL(string: feed.feedPayload.contentPayload.photo[1].url)
                self.secondImageView.kf.setImage(with: secondUrl)
                
                let thirdUrl = URL(string: feed.feedPayload.contentPayload.photo[2].url)
                self.thirdImageView.kf.setImage(with: thirdUrl)
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
        let imageHeight = UIView.aspectRatioCalculator(ratioWidth: 1, ratioHeight: 1, pixelsWidth: Double(width - 30))
        return CGSize(width: width, height: (label.frame.height + 45 + CGFloat(imageHeight)))
    }
    
    @IBAction func viewFirstImageAction(_ sender: Any) {
        self.openImage(index: 0)
    }
    
    @IBAction func viewSecondImageAction(_ sender: Any) {
        self.openImage(index: 1)
    }
    
    @IBAction func viewThirdImageAction(_ sender: Any) {
        self.openImage(index: 2)
    }
    
    private func openImage(index: Int) {
        if let feed = self.feed, !feed.feedPayload.contentPayload.photo.isEmpty {
            
            var images: [LightboxImage] = []
            feed.feedPayload.contentPayload.photo.forEach { photo in
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

extension ImageX3Cell: LightboxControllerPageDelegate {
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) { }
}

extension ImageX3Cell: LightboxControllerDismissalDelegate {
    func lightboxControllerWillDismiss(_ controller: LightboxController) { }
}
