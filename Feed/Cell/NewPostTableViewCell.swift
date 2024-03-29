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
//  NewPostTableViewCell.swift
//  Feed
//
//  Created by Castcle Co., Ltd. on 23/9/2564 BE.
//

import UIKit
import Core
import Component
import Profile
import Kingfisher

class NewPostTableViewCell: UITableViewCell {

    @IBOutlet var searchView: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var placeholderLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.searchView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 18, borderWidth: 1, borderColor: UIColor.Asset.darkGraphiteBlue)
        self.profileImage.circle(color: UIColor.Asset.white)
        self.placeholderLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.placeholderLabel.textColor = UIColor.Asset.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell() {
        let url = URL(string: UserManager.shared.avatar)
        self.profileImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.placeholderLabel.text = Localization.Feed.post.text
    }

    @IBAction func postAction(_ sender: Any) {
        let viewController = PostOpener.open(.post(PostViewModel(postType: .newCast)))
        viewController.modalPresentationStyle = .fullScreen
        Utility.currentViewController().present(viewController, animated: true, completion: nil)
    }

    @IBAction func profileAction(_ sender: Any) {
        ProfileOpener.openProfileDetail(UserManager.shared.castcleId, displayName: "")
    }
}
