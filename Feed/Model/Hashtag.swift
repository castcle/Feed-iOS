//
//  Hashtag.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 13/7/2564 BE.
//

import SwiftyJSON

// MARK: - Hashtag
public enum HashtagKey: String, Codable {
    case id
    case slug
    case name
    case key
    case created
    case updated
}

public class Hashtag: NSObject {
    let id: String
    let slug: String
    let name: String
    let key: String
    let created: String
    let updated: String
    
    init(json: JSON) {
        self.id = json[HashtagKey.id.rawValue].stringValue
        self.slug = json[HashtagKey.slug.rawValue].stringValue
        self.name = json[HashtagKey.name.rawValue].stringValue
        self.key = json[HashtagKey.key.rawValue].stringValue
        self.created = json[HashtagKey.created.rawValue].stringValue
        self.updated = json[HashtagKey.updated.rawValue].stringValue
    }
}
