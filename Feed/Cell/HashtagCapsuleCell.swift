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
//  HashtagCapsuleCell.swift
//  Feed
//
//  Created by Castcle Co., Ltd. on 14/7/2564 BE.
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
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .overline)
        self.bgView.capsule(color: UIColor.Asset.cellBackground, borderWidth: 1.0, borderColor: UIColor.Asset.black)
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
        let rect = text.boundingRect(with: CGSize(width: 0, height: 0), options: NSStringDrawingOptions.usesFontLeading, attributes: [NSAttributedString.Key.font: UIFont.asset(.bold, fontSize: .overline)], context: nil)
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
