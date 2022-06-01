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
//  Created by Castcle Co., Ltd. on 13/7/2564 BE.
//

import Core
import Foundation
import Networking
import SwiftyJSON
import RealmSwift
import Defaults

final class FeedViewModel {

    private var feedRepository: FeedRepository = FeedRepositoryImpl()
    var feedRequest: FeedRequest = FeedRequest()
    var hashtagShelf: HashtagShelf = HashtagShelf()
    var feeds: [Feed] = []
    var feedsTemp: [Feed] = []
    var meta: Meta = Meta()
    let tokenHelper: TokenHelper = TokenHelper()
    private var featureSlug: String = "feed"
    private var circleSlug: String = "forYou"
    var state: LoadState = .loading
    var isFirstLaunch: Bool = true
    private var isReset: Bool = true

    // MARK: - Input
    public func getHashtags() {
        self.feedRepository.getHashtags { (success, hashtagShelf) in
            if success {
                self.hashtagShelf = hashtagShelf
                if UserManager.shared.isLogin {
                    self.getFeedsMembers(isReset: true)
                } else {
                    self.getFeedsGuests(isReset: true)
                }
            }
            self.didLoadHashtagsFinish?()
        }
    }

    public func getFeedsGuests(isReset: Bool) {
        self.isReset = isReset
        self.feedRequest.userFields = .none
        self.feedRepository.getFeedsGuests(feedRequest: self.feedRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let shelf = FeedShelf(json: json)
                    self.feedsTemp = []
                    self.feedsTemp.append(contentsOf: shelf.feeds)
                    if isReset {
                        self.feeds = self.feedsTemp
                    } else {
                        self.feeds.append(contentsOf: self.feedsTemp)
                    }
                    self.meta = shelf.meta
                    self.didLoadFeedsFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func getFeedsMembers(isReset: Bool) {
        self.isReset = isReset
        self.feedRequest.userFields = .relationships
        self.feedRepository.getFeedsMembers(featureSlug: self.featureSlug, circleSlug: self.circleSlug, feedRequest: self.feedRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let shelf = FeedShelf(json: json)
                    self.feedsTemp = []
                    self.feedsTemp.append(contentsOf: shelf.feeds)
                    if isReset {
                        self.feeds = self.feedsTemp
                    } else {
                        self.feeds.append(contentsOf: self.feedsTemp)
                    }
                    self.meta = shelf.meta
                    self.didLoadFeedsFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    // MARK: - Output
    var didLoadHashtagsFinish: (() -> Void)?
    var didLoadFeedsFinish: (() -> Void)?

    public init() {
        self.tokenHelper.delegate = self
    }

    private func isSeenContent(feedId: String) -> Bool {
        let seenId = Defaults[.seenId]
        if seenId.isEmpty {
            return false
        } else {
            let seenIdArr = seenId.components(separatedBy: "|")
            if seenIdArr.contains(feedId) {
                return true
            } else {
                return false
            }
        }
    }

    func seenContent(feedId: String) {
        DispatchQueue.background(background: {
            if !self.isSeenContent(feedId: feedId) {
                let engagement = EngagementHelper()
                engagement.seenContent(feedId: feedId)
                let seenId = Defaults[.seenId]
                if seenId.isEmpty {
                    Defaults[.seenId] = feedId
                } else {
                    Defaults[.seenId] = "\(seenId)|\(feedId)"
                }
            }
        })
    }

    func castOffView(feedId: String) {
        DispatchQueue.background(background: {
            let engagement = EngagementHelper()
            engagement.castOffView(feedId: feedId)
        })
    }
}

extension FeedViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if UserManager.shared.isLogin {
            self.getFeedsMembers(isReset: self.isReset)
        } else {
            self.getFeedsGuests(isReset: self.isReset)
        }
    }
}
