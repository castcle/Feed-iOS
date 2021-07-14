//
//  HashtagShelf.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import SwiftyJSON

// MARK: - Hashtag List
public enum HashtagShelfKey: String, Codable {
    case payload
}

class HashtagShelf: NSObject {
    var hashtags: [Hashtag] = []
    
    override init() { }
    
    init(json: JSON) {
        let payload = json[HashtagShelfKey.payload.rawValue].arrayValue
        
        var hashtags: [Hashtag] = []
        payload.forEach() { item in
            hashtags.append(Hashtag(json: item))
        }
        
        self.hashtags = hashtags
    }
}
