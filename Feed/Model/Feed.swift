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
    case id
    case feature
    case circle
    case aggregator
    case type
    case payload
    case created
    case updated
}

public enum FeedType: String, Codable {
    case content
    case suggestion
    case reminder
    case ads
}

public class Feed: NSObject {
    let id: String
    let feature: Feature
    let circle: Circle
    let aggregator: Aggregator
    let type: FeedType
    let feedPayload: Content
    let created: String
    let updated: String
    
    init(json: JSON) {
        self.id = json[FeedKey.id.rawValue].stringValue
        self.type = FeedType(rawValue: json[FeedKey.type.rawValue].stringValue) ?? .content
        self.created = json[FeedKey.created.rawValue].stringValue
        self.updated = json[FeedKey.updated.rawValue].stringValue
        
        // MARK: - Object
        self.feature = Feature(json: JSON(json[FeedKey.feature.rawValue].dictionaryObject ?? [:]))
        self.circle = Circle(json: JSON(json[FeedKey.aggregator.rawValue].dictionaryObject ?? [:]))
        self.aggregator = Aggregator(json: JSON(json[FeedKey.aggregator.rawValue].dictionaryObject ?? [:]))
        self.feedPayload = Content(json: JSON(json[FeedKey.payload.rawValue].dictionaryObject ?? [:]))
    }
}
