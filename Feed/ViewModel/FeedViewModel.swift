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
//  FeedViewModel.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 13/7/2564 BE.
//

import Foundation
import Networking
import SwiftyJSON

final class FeedViewModel {
   
    private var feedRepository: FeedRepository = FeedRepositoryImpl()
    var hashtagShelf: HashtagShelf = HashtagShelf()
    var feeds: [Feed] = []
    var pagination: Pagination = Pagination()
    let tokenHelper: TokenHelper = TokenHelper()
    private var featureSlug: String = "feed"
    private var circleSlug: String = "forYou"

    //MARK: Input
    public func getHashtags() {
        self.feedRepository.getHashtags() { (success, hashtagShelf) in
            if success {
                self.hashtagShelf = hashtagShelf
                self.getFeeds()
            }
            self.didLoadHashtagsFinish?()
        }
    }
    
    public func getFeeds() {
        self.feedRepository.getFeeds(featureSlug: self.featureSlug, circleSlug: self.circleSlug) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let shelf = FeedShelf(json: json)
                    self.feeds.append(contentsOf: shelf.feeds)
                    self.pagination = shelf.pagination
                    self.didLoadFeedsFinish?()
                } catch {
                    
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    //MARK: Output
    var didLoadHashtagsFinish: (() -> ())?
    var didLoadFeedsFinish: (() -> ())?
    
    public init() {
        self.tokenHelper.delegate = self
    }
}

extension FeedViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        self.getFeeds()
    }
}
