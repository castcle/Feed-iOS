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

public enum FeedDisplayType {
    case postText
    case postLink
    case postYoutube
    case postImageX1
    case postImageX2
    case postImageX3
    case postImageXMore
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
    
    var feedDisplayType: FeedDisplayType {
        if self.type == .post {
            if !self.photo.isEmpty {
                if self.photo.count == 1 {
                    return .postImageX1
                } else if self.photo.count == 2 {
                    return .postImageX2
                } else if self.photo.count == 3 {
                    return .postImageX3
                } else {
                    return .postImageXMore
                }
            } else if !self.link.isEmpty {
                if let link = link.first {
                    if link.type == .youtube {
                        return .postYoutube
                    } else {
                        return .postLink
                    }
                } else {
                    return .postText
                }
            } else {
                return .postText
            }
        } else {
            return .postText
        }
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
