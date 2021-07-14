//
//  Author.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import SwiftyJSON

// MARK: - Liked
public enum AuthorKey: String, Codable {
    case type
    case id
    case name
    case firstName
    case lastName
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
    let name: String
    let firstName: String
    let lastName: String
    let avatar: String
    let verified: Bool
    let followed: Bool
    
    init(json: JSON) {
        self.type = AuthorType(rawValue: json[AuthorKey.type.rawValue].stringValue) ?? .people
        self.id = json[AuthorKey.id.rawValue].stringValue
        self.name = json[AuthorKey.name.rawValue].stringValue
        self.firstName = json[AuthorKey.firstName.rawValue].stringValue
        self.lastName = json[AuthorKey.lastName.rawValue].stringValue
        self.avatar = json[AuthorKey.avatar.rawValue].stringValue
        self.verified = json[AuthorKey.verified.rawValue].boolValue
        self.followed = json[AuthorKey.followed.rawValue].boolValue
    }
}
