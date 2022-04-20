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
//  UserToFollowViewModel.swift
//  Feed
//
//  Created by Castcle Co., Ltd. on 21/1/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public final class UserToFollowViewModel {
   
    private var feedRepository: FeedRepository = FeedRepositoryImpl()
    var feedRequest: FeedRequest = FeedRequest()
    var users: [UserInfo] = []
    var meta: Meta = Meta()
    let tokenHelper: TokenHelper = TokenHelper()
    var state: LoadState = .loading
    
    public init() {
        self.tokenHelper.delegate = self
        self.feedRequest.maxResults = 25
        self.getUserSuggestion()
    }
    
    public func reloadData() {
        self.users = []
        self.meta = Meta()
        self.getUserSuggestion()
    }
    
    public func getUserSuggestion() {
        self.feedRequest.userFields = .relationships
        self.feedRepository.getSuggestionFollow(feedRequest: self.feedRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let userData = (json[JsonKey.payload.rawValue].arrayValue).map { UserInfo(json: $0) }
                    self.meta = Meta(json: JSON(json[JsonKey.meta.rawValue].dictionaryValue))
                    self.users.append(contentsOf: userData)
                    self.didLoadSuggestionUserFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    var didLoadSuggestionUserFinish: (() -> ())?
}

extension UserToFollowViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        self.getUserSuggestion()
    }
}
