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
