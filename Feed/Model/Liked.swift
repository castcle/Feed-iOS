//
//  Liked.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import SwiftyJSON

// MARK: - Liked
public enum LikedKey: String, Codable {
    case count
    case liked
    case participant
}

public class Liked: NSObject {
    let count: Int
    let liked: Bool
    let participant: [Participant]
    
    init(json: JSON) {
        self.count = json[LikedKey.count.rawValue].intValue
        self.liked = json[LikedKey.liked.rawValue].boolValue
        
        // MARK: - Participant
        let participantJson = json[LikedKey.participant.rawValue].arrayValue
        var participantArr: [Participant] = []
        participantJson.forEach { item in
            participantArr.append(Participant(json: item))
        }
        self.participant = participantArr
    }
}
