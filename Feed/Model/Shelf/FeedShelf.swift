//
//  FeedShelf.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import SwiftyJSON

// MARK: - Hashtag List
public enum FeedShelfKey: String, Codable {
    case payload
    case feed
    case pagination
    case suggestion
    case reminder
}

class FeedShelf: NSObject {
    var feeds: [Feed] = []
    
    override init() { }
    
    init(json: JSON) {
        let payload = JSON(json[FeedShelfKey.payload.rawValue].dictionaryValue)
        let feedsJson = payload[FeedShelfKey.feed.rawValue].arrayValue
        
        var feeds: [Feed] = []
        feedsJson.forEach() { item in
            feeds.append(Feed(json: item))
        }
        
        self.feeds = feeds
    }
}
