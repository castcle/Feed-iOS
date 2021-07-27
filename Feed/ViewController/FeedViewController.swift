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
//  FeedViewController.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 6/7/2564 BE.
//

import UIKit
import Core
import Component
import Authen
import IGListKit

class FeedViewController: UIViewController {
    
    let collectionView: UICollectionView = {
      let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.Asset.darkGraphiteBlue
      return view
    }()
    
    lazy var adapter: ListAdapter = {
      return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var viewModel = FeedViewModel()
    
    enum FeedType: Int {
        case newPost = 0
        case hashtag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNevBar()

        self.collectionView.alwaysBounceVertical = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self
        
        self.collectionView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.collectionView.cr.endHeaderRefresh()
            })
        }
        
        self.viewModel.didLoadHashtagsFinish = {
            self.adapter.performUpdates(animated: true)
        }
        
        self.viewModel.didLoadFeedgsFinish = {
            self.adapter.performUpdates(animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = view.bounds
    }
    
    private func setupNevBar() {
        self.customNavigationBar(.primary, title: "For You", rightBarButton: [(Authen.shared.isLogin ? .menu : .profile)])
        
        let icon = NavBarButtonType.logo.barButton
        icon.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: icon)
    }
    
    @objc private func leftButtonAction() {
        self.navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: "http://www.google.co.th")!)), animated: true)
    }
    
    func castcleTabbar(didSelectButtonBar button: BarButtonActionType) {
        if button == .firstRightButton {
            if Authen.shared.isLogin {
                Authen.shared.logout()
            } else {
                Authen.shared.login()
            }
            
            self.setupNevBar()
            self.adapter.performUpdates(animated: true)
        }
    }
}

// MARK: - ListAdapterDataSource
extension FeedViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var items: [ListDiffable] = [] as [ListDiffable]
        
        if Authen.shared.isLogin {
            items.append(FeedType.newPost.rawValue as ListDiffable)
        }
        
        if !self.viewModel.hashtagShelf.hashtags.isEmpty {
            items.append(self.viewModel.hashtagShelf as ListDiffable)
        }
        
        self.viewModel.feedShelf.feeds.forEach { feed in
            items.append(feed as ListDiffable)
        }
        
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is HashtagShelf {
            return HashtagSectionController()
        } else if object is Feed {
            return FeedSectionController()
        } else {
            return NewPostSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
