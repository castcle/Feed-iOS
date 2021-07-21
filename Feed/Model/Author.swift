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
//  Author.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import SwiftyJSON

// MARK: - Liked
public enum AuthorKey: String, Codable {
    case id
    case type
    case displayName
    case avatar
    case verified
    case followed
}

public enum AuthorType: String, Codable {
    case people
    case page
}

public class Author: NSObject {
    let type: AuthorType
    let id: String
    let displayName: String
    let avatar: String
    let verified: Bool
    let followed: Bool
    
    init(json: JSON) {
        
        self.id = json[AuthorKey.id.rawValue].stringValue
        self.type = AuthorType(rawValue: json[AuthorKey.type.rawValue].stringValue) ?? .people
        self.displayName = json[AuthorKey.displayName.rawValue].stringValue
        self.avatar = json[AuthorKey.avatar.rawValue].stringValue
        self.verified = json[AuthorKey.verified.rawValue].boolValue
        self.followed = json[AuthorKey.followed.rawValue].boolValue
    }
}
