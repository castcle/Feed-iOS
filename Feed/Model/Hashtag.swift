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
