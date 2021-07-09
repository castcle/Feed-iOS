//
//  FeedViewController.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 6/7/2564 BE.
//

import UIKit
import Component

class FeedViewController: UIViewController, CastcleTabbarDeleDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.customNavigationBar(.primary, title: "For You", leftBarButton: .logo, rightBarButton: [.menu])
        FeedViewController.castcleTabbarDelegate = self
    }
    
    func castcleTabbar(didSelectButtonBar button: BarButtonActionType) {
        print(button)
    }
}
