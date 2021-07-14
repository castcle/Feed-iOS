//
//  Aggregator.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import SwiftyJSON

// MARK: - Aggregator
public enum AggregatorKey: String, Codable {
    case type
    case id
    case action
    case message
}

public enum AggregatorType: String, Codable {
    case friend
    case following
    case topic
    case unknown
}

public enum ActionType: String, Codable {
    case liked
    case commented
    case recasted
    case suggestion
    case unknown
}

public class Aggregator: NSObject {
    let type: AggregatorType
    let id: String
    let action: ActionType
    let message: String
    
    init(json: JSON) {
        self.type = AggregatorType(rawValue: json[AggregatorKey.type.rawValue].stringValue) ?? .unknown
        self.id = json[AggregatorKey.id.rawValue].stringValue
        self.action = ActionType(rawValue: json[AggregatorKey.action.rawValue].stringValue) ?? .unknown
        self.message = json[AggregatorKey.message.rawValue].stringValue
    }
}
