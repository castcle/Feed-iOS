//
//  TextLinkCell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 16/7/2564 BE.
//

import UIKit
import LinkPresentation
import Core
import ActiveLabel

class TextLinkCell: UICollectionViewCell {

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
    
    @IBOutlet var linkContainer: UIView!
    
    private var linkView: LPLinkView = LPLinkView(metadata: LPLinkMetadata())
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
            self.addLinkViewToLinkLinkContainer()
            self.fetchPreview(feed: feed)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.linkContainer.custom(cornerRadius: 12)
    }
    
    static func cellSize(width: CGFloat, text: String) -> CGSize {
        let label = ActiveLabel(frame: CGRect(x: 0, y: 0, width: width - 30, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.enabledTypes = [.mention, .hashtag, .url]
        label.text = text
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.asset(.regular, fontSize: .body)
        label.text = text
        label.sizeToFit()
        let imageHeight = UIView.aspectRatioCalculator(ratioWidth: 29, ratioHeight: 20, pixelsWidth: Double(width - 30))
        return CGSize(width: width, height: (label.frame.height + 55 + CGFloat(imageHeight)))
    }
    
    private func addLinkViewToLinkLinkContainer() {
        DispatchQueue.main.async {
            self.linkView.frame = self.linkContainer.bounds
            self.linkContainer.addSubview(self.linkView)
            self.linkContainer.sizeToFit()
        }
    }

    private func fetchPreview(feed: Feed) {
        if let link = feed.link.first, let url = URL(string: link.url) {
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
