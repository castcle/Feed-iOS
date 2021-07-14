//
//  Commented.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 14/7/2564 BE.
//

import SwiftyJSON

// MARK: - Liked
public enum CommentedKey: String, Codable {
    case count
    case commented
    case participant
}

public class Commented: NSObject {
    let count: Int
    let commented: Bool
    let participant: [Participant]
    
    init(json: JSON) {
        self.count = json[CommentedKey.count.rawValue].intValue
        self.commented = json[CommentedKey.commented.rawValue].boolValue
        
        // MARK: - Participant
        let participantJson = json[CommentedKey.participant.rawValue].arrayValue
        var participantArr: [Participant] = []
        participantJson.forEach { item in
            participantArr.append(Participant(json: item))
        }
        self.participant = participantArr
    }
}
