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
