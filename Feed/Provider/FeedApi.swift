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
//  FeedApi.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 13/7/2564 BE.
//

import Core
import Moya

enum FeedApi {
    case getHashtags
    case getFeeds(String, String)
}

extension FeedApi: TargetType {
    var baseURL: URL {
        return URL(string: Environment.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .getHashtags:
            return "/hashtags"
        case .getFeeds(let featureSlug, let circleSlug):
            return "/feeds/\(featureSlug)/\(circleSlug)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHashtags:
            return .get
        case .getFeeds(_, _):
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getHashtags:
            if let path = ConfigBundle.feed.path(forResource: "Hashtag", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    return data
                } catch {
                    return Data()
                }
            } else {
                return Data()
            }
        case .getFeeds(_, _):
            if let path = ConfigBundle.feed.path(forResource: "Feeds", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    return data
                } catch {
                    return Data()
                }
            } else {
                return Data()
            }
        }
    }
    
    var task: Task {
        switch self {
        case .getHashtags:
            return .requestPlain
        case .getFeeds(_, _):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
