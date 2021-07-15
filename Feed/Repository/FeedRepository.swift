//
//  FeedRepository.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 13/7/2564 BE.
//

import Moya
import SwiftyJSON

protocol FeedRepository {
    func getHashtags(_ completion: @escaping (Bool, HashtagShelf) -> ())
    func getFeeds(featureSlug: String, circleSlug: String, _ completion: @escaping (Bool, FeedShelf) -> ())
}

final class FeedRepositoryImpl: FeedRepository {
    private let feedProvider = MoyaProvider<FeedApi>(stubClosure: MoyaProvider.delayedStub(1.0))
    
    func getHashtags(_ completion: @escaping (Bool, HashtagShelf) -> ()) {
        self.feedProvider.request(.getHashtags) { result in
            switch result {
            case .success(let response):
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    completion(true, HashtagShelf(json: json))
                } catch {
                    completion(false, HashtagShelf())
                }
            case .failure:
                completion(false, HashtagShelf())
            }
        }
    }
    
    func getFeeds(featureSlug: String, circleSlug: String, _ completion: @escaping (Bool, FeedShelf) -> ()) {
        self.feedProvider.request(.getFeeds(featureSlug, circleSlug)) { result in
            switch result {
            case .success(let response):
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    completion(true, FeedShelf(json: json))
                } catch {
                    completion(false, FeedShelf())
                }
            case .failure:
                completion(false, FeedShelf())
            }
        }
    }
}
