//
//  HashtagCapsuleCell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import UIKit
import Core

class HashtagCapsuleCell: UICollectionViewCell {

    @IBOutlet var bgView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    private let alphaSelect: CGFloat = 1.0
    private let alphaDeselect: CGFloat = 0.6
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.titleLabel.font = UIFont.asset(.medium, fontSize: .overline)
        self.bgView.capsule(color: UIColor.Asset.darkGray, borderWidth: 1.0, borderColor: UIColor.Asset.black)
        self.titleLabel.textColor = UIColor.Asset.white
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.toggleIsHighlighted()
        }
    }
    
    func toggleIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear], animations: {
            self.alpha = 1
            self.transform = self.isHighlighted ?
                CGAffineTransform.identity.scaledBy(x: 0.90, y: 0.90) :
                CGAffineTransform.identity
        })
    }
    
    static func cellSize(height: CGFloat, text: String) -> CGSize {
        let rect = text.boundingRect(with: CGSize(width: 0, height: 0), options: NSStringDrawingOptions.usesFontLeading, attributes: [NSAttributedString.Key.font : UIFont.asset(.medium, fontSize: .overline)], context: nil)
        return CGSize(width: (rect.width + 40.0), height: height)
    }
    
    func configCell(isSelect: Bool) {
        if isSelect {
            self.bgView.alpha = self.alphaSelect
            self.titleLabel.alpha = self.alphaSelect
        } else {
            self.bgView.alpha = self.alphaDeselect
            self.titleLabel.alpha = self.alphaDeselect
        }
    }

}
