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
//  FeedRepository.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 13/7/2564 BE.
//

import Moya
import SwiftyJSON

protocol FeedRepository {
    func getHashtags(_ completion: @escaping (Bool, HashtagShelf) -> ())
    func getFeeds(featureSlug: String, circleSlug: String, _ completion: @escaping (Bool, FeedShelf) -> ())
}

final class FeedRepositoryImpl: FeedRepository {
    private let feedProvider = MoyaProvider<FeedApi>(stubClosure: MoyaProvider.delayedStub(1.0))
    
    func getHashtags(_ completion: @escaping (Bool, HashtagShelf) -> ()) {
        self.feedProvider.request(.getHashtags) { result in
            switch result {
            case .success(let response):
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    completion(true, HashtagShelf(json: json))
                } catch {
                    completion(false, HashtagShelf())
                }
            case .failure:
                completion(false, HashtagShelf())
            }
        }
    }
    
    func getFeeds(featureSlug: String, circleSlug: String, _ completion: @escaping (Bool, FeedShelf) -> ()) {
        self.feedProvider.request(.getFeeds(featureSlug, circleSlug)) { result in
            switch result {
            case .success(let response):
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    completion(true, FeedShelf(json: json))
                } catch {
                    completion(false, FeedShelf())
                }
            case .failure:
                completion(false, FeedShelf())
            }
        }
    }
}
