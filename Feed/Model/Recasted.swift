//
//  Recasted.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import SwiftyJSON

// MARK: - Liked
public enum RecastedKey: String, Codable {
    case count
    case recasted
    case participant
}

public class Recasted: NSObject {
    let count: Int
    var recasted: Bool
    let participant: [Participant]
    
    init(json: JSON) {
        self.count = json[RecastedKey.count.rawValue].intValue
        self.recasted = json[RecastedKey.recasted.rawValue].boolValue
        
        // MARK: - Participant
        let participantJson = json[RecastedKey.participant.rawValue].arrayValue
        var participantArr: [Participant] = []
        participantJson.forEach { item in
            participantArr.append(Participant(json: item))
        }
        self.participant = participantArr
    }
}
