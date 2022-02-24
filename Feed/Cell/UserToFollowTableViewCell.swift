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
//  UserToFollowTableViewCell.swift
//  Feed
//
//  Created by Castcle Co., Ltd.Castcle Co., Ltd. on 21/1/2565 BE.
//

import UIKit
import Core
import Networking
import Profile
import Authen
import Kingfisher

class UserToFollowTableViewCell: UITableViewCell {

    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userNoticeLabel: UILabel!
    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userDescLabel: UILabel!
    @IBOutlet weak var userFollowButton: UIButton!
    @IBOutlet weak var userVerifyImage: UIImageView!
    
    private var userRepository: UserRepository = UserRepositoryImpl()
    private var user: UserInfo = UserInfo()
    let tokenHelper: TokenHelper = TokenHelper()
    private var stage: Stage = .none
    private var userRequest: UserRequest = UserRequest()
    
    enum Stage {
        case followUser
        case unfollowUser
        case none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tokenHelper.delegate = self
        self.userAvatarImage.circle(color: UIColor.Asset.white)
        self.userDisplayNameLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.userDisplayNameLabel.textColor = UIColor.Asset.white
        self.userNoticeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.userNoticeLabel.textColor = UIColor.Asset.white
        self.userIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.userIdLabel.textColor = UIColor.Asset.white
        self.userDescLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.userDescLabel.textColor = UIColor.Asset.white
        self.userVerifyImage.image = UIImage.init(icon: .castcle(.verify), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightBlue)
        self.userFollowButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .small)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configCell(user: UserInfo) {
        self.user = user
        let userAvatar = URL(string: self.user.images.avatar.thumbnail)
        self.userAvatarImage.kf.setImage(with: userAvatar, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.userNoticeLabel.text = self.user.aggregator.message
        self.userDisplayNameLabel.text = self.user.displayName
        self.userIdLabel.text = "@\(self.user.castcleId)"
        self.userDescLabel.text = self.user.overview
        if self.user.verified.official {
            self.userVerifyImage.isHidden = false
        } else {
            self.userVerifyImage.isHidden = true
        }
        if self.user.castcleId == UserManager.shared.rawCastcleId {
            self.userFollowButton.isHidden = true
        } else {
            self.userFollowButton.isHidden = false
        }
        self.updateUserFollow()
    }
    
    private func updateUserFollow() {
        if self.user.followed {
            self.userFollowButton.setTitle("Following", for: .normal)
            self.userFollowButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.userFollowButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1.0, borderColor: UIColor.Asset.lightBlue)
        } else {
            self.userFollowButton.setTitle("Follow", for: .normal)
            self.userFollowButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
            self.userFollowButton.capsule(color: .clear, borderWidth: 1.0, borderColor: UIColor.Asset.lightBlue)
        }
    }
    
    private func followUser() {
        self.stage = .followUser
        let userId: String = UserManager.shared.rawCastcleId
        self.userRepository.follow(userId: userId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    private func unfollowUser() {
        self.stage = .unfollowUser
        let userId: String = UserManager.shared.rawCastcleId
        self.userRepository.unfollow(userId: userId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    @IBAction func userFollowAction(_ sender: Any) {
        if UserManager.shared.isLogin {
            self.userRequest.targetCastcleId = self.user.castcleId
            if self.user.followed {
                self.unfollowUser()
            } else {
                self.followUser()
            }
            self.user.followed.toggle()
            self.updateUserFollow()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
                Utility.currentViewController().presentPanModal(AuthenOpener.open(.signUpMethod) as! SignUpMethodViewController)
            }
        }
    }
    
    @IBAction func userProfileAction(_ sender: Any) {
        ProfileOpener.openProfileDetail(self.user.type, castcleId: self.user.castcleId, displayName: self.user.displayName)
    }
}

extension UserToFollowTableViewCell: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .followUser {
            self.followUser()
        } else if self.stage == .unfollowUser {
            self.unfollowUser()
        }
    }
}
