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
//  RecastRepository.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 23/7/2564 BE.
//

import Moya
import SwiftyJSON

protocol RecastRepository {
    func recasted(feedUuid: String, _ completion: @escaping (Bool) -> ())
    func unrecasted(feedUuid: String, _ completion: @escaping (Bool) -> ())
}

final class RecastRepositoryImpl: RecastRepository {
    private let recastProvider = MoyaProvider<RecastApi>(stubClosure: MoyaProvider.delayedStub(1.0))
    
    func recasted(feedUuid: String, _ completion: @escaping (Bool) -> ()) {
        self.recastProvider.request(.recasted(feedUuid)) { result in
            switch result {
            case .success:
                print("Success")
            case .failure:
                print("Failure")
            }
        }
    }
    
    func unrecasted(feedUuid: String, _ completion: @escaping (Bool) -> ()) {
        self.recastProvider.request(.unrecasted(feedUuid)) { result in
            switch result {
            case .success:
                print("Success")
            case .failure:
                print("Failure")
            }
        }
    }
}
