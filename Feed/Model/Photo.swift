//
//  Photo.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import SwiftyJSON

// MARK: - Photo
public enum PhotoKey: String, Codable {
    case url
}

public class Photo: NSObject {
    let url: String
    
    init(json: JSON) {
        self.url = json[PhotoKey.url.rawValue].stringValue
    }
}
