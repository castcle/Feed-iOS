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
//  FeedNibVars.swift
//  Feed
//
//  Created by Castcle Co., Ltd. on 6/7/2564 BE.
//

public struct FeedNibVars {
    // MARK: - View Controller
    public struct ViewController {
        public static let feed = "FeedViewController"
        public static let userToFollow = "UserToFollowViewController"
        public static let quoteCastList = "QuoteCastListViewController"
    }

    // MARK: - View
    public struct Storyboard {
        public static let feed = "Feed"
    }

    // MARK: - TableViewCell
    public struct TableViewCell {
        public static let post = "NewPostTableViewCell"
    }

    // MARK: - CollectionViewCell
    public struct CollectionViewCell {
        public static let hashtag = "HashtagCell"
        public static let hashtagCapsule = "HashtagCapsuleCell"
    }
}
