//
//  Link.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import SwiftyJSON

// MARK: - Link
public enum LinkKey: String, Codable {
    case type
    case url
}

public enum LinkType: String, Codable {
    case youtube
    case other
}

public class Link: NSObject {
    let type: LinkType
    let url: String
    
    init(json: JSON) {
        self.type = LinkType(rawValue: json[LinkKey.type.rawValue].stringValue) ?? .other
        self.url = json[LinkKey.url.rawValue].stringValue
    }
}
