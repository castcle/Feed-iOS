//
//  FeedViewModel.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 13/7/2564 BE.
//

import Foundation

final class FeedViewModel  {
   
    //MARK: Private
    private var feedRepository: FeedRepository
    var hashtagShelf: HashtagShelf = HashtagShelf()
    var feedShelf: FeedShelf = FeedShelf()

    //MARK: Input
    public func getHashtags() {
        self.feedRepository.getHashtags() { (success, hashtagShelf) in
            if success {
                self.hashtagShelf = hashtagShelf
                self.getFeeds()
            }
            self.didLoadHashtagsFinish?()
        }
    }
    
    public func getFeeds() {
        self.feedRepository.getFeeds(featureSlug: "Test", circleSlug: "Test") { (success, feedShelf) in
            if success {
                self.feedShelf = feedShelf
            }
            self.didLoadFeedgsFinish?()
        }
    }
    
    //MARK: Output
    var didLoadHashtagsFinish: (() -> ())?
    var didLoadFeedgsFinish: (() -> ())?
    
    public init(feedRepository: FeedRepository = FeedRepositoryImpl()) {
        self.feedRepository = feedRepository
        self.getHashtags()
    }
}
