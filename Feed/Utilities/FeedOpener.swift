//
//  FeedOpener.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 6/7/2564 BE.
//

import UIKit
import Core

public enum FeedScene {
    case feed
}

public struct FeedOpener {
    
    public static func open(_ feedScene: FeedScene) -> UIViewController {
        switch feedScene {
        case .feed:
            let storyboard: UIStoryboard = UIStoryboard(name: FeedNibVars.Storyboard.feed, bundle: ConfigBundle.feed)
            let vc = storyboard.instantiateViewController(withIdentifier: FeedNibVars.ViewController.feed)
            return vc
        }
    }
}
