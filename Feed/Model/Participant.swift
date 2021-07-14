//
//  Participant.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import SwiftyJSON

// MARK: - Participant
public enum ParticipantKey: String, Codable {
    case type
    case id
    case name
}

public enum ParticipantType: String, Codable {
    case people
    case page
    case unknown
}

public class Participant: NSObject {
    let type: ParticipantType
    let id: String
    let name: String
    
    init(json: JSON) {
        self.type = ParticipantType(rawValue: json[ParticipantKey.type.rawValue].stringValue) ?? .unknown
        self.id = json[ParticipantKey.id.rawValue].stringValue
        self.name = json[ParticipantKey.name.rawValue].stringValue
    }
}
