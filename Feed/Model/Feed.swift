//
//  Feed.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import Core
import SwiftyJSON

// MARK: - Feed
public enum FeedKey: String, Codable {
    case feature
    case type
    case id
    case header
    case content
    case photo
    case link
    case aggregator
    case liked
    case commented
    case recasted
    case author
    case quoteCast
    case created
    case updated
}

public enum FeedType: String, Codable {
    case post
    case blog
    case image
    case shortClip
    case clip
    case live
}

public class Feed: NSObject {
    let feature: Feature
    let type: FeedType
    let id: String
    let header: String
    let content: String
    let photo: [Photo]
    let link: [Link]
    let aggregator: Aggregator
    let liked: Liked
    let commented: Commented
    let recasted: Recasted
    let author: Author
//    let quoteCast: Feed
    let created: String
    let updated: String
    
    var postDate: Date {
        return Date.stringToDate(str: self.updated)
    }
    
    init(json: JSON) {
        
        self.type = FeedType(rawValue: json[FeedKey.type.rawValue].stringValue) ?? .post
        self.id = json[FeedKey.id.rawValue].stringValue
        self.header = json[FeedKey.header.rawValue].stringValue
        self.content = json[FeedKey.content.rawValue].stringValue
        self.created = json[FeedKey.created.rawValue].stringValue
        self.updated = json[FeedKey.updated.rawValue].stringValue
        
        // MARK: - Object
        self.feature = Feature(json: JSON(json[FeedKey.feature.rawValue].dictionaryObject ?? [:]))
        self.aggregator = Aggregator(json: JSON(json[FeedKey.aggregator.rawValue].dictionaryObject ?? [:]))
        self.liked = Liked(json: JSON(json[FeedKey.liked.rawValue].dictionaryObject ?? [:]))
        self.commented = Commented(json: JSON(json[FeedKey.commented.rawValue].dictionaryObject ?? [:]))
        self.recasted = Recasted(json: JSON(json[FeedKey.recasted.rawValue].dictionaryObject ?? [:]))
        self.author = Author(json: JSON(json[FeedKey.author.rawValue].dictionaryObject ?? [:]))
//        self.quoteCast = Feed(json: JSON(json[FeedKey.quoteCast.rawValue].dictionaryObject ?? [:]))
        
        // MARK: - Photo
        let photoJson = json[FeedKey.photo.rawValue].arrayValue
        var photoArr: [Photo] = []
        photoJson.forEach { item in
            photoArr.append(Photo(json: item))
        }
        self.photo = photoArr
        
        // MARK: - Link
        let linkJson = json[FeedKey.link.rawValue].arrayValue
        var linkArr: [Link] = []
        linkJson.forEach { item in
            linkArr.append(Link(json: item))
        }
        self.link = linkArr
    }
}
