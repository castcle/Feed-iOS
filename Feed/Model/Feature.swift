//
//  Feature.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import SwiftyJSON

// MARK: - Feature
public enum FeatureKey: String, Codable {
    case id
    case slug
    case name
    case key
}

public class Feature: NSObject {
    let id: String
    let slug: String
    let name: String
    let key: String
    
    init(json: JSON) {
        self.id = json[FeatureKey.id.rawValue].stringValue
        self.slug = json[FeatureKey.slug.rawValue].stringValue
        self.name = json[FeatureKey.name.rawValue].stringValue
        self.key = json[FeatureKey.key.rawValue].stringValue
    }
}
