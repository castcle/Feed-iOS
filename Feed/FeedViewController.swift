//
//  FeedViewController.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 6/7/2564 BE.
//

import UIKit
import Core
import Component
import IGListKit

class FeedViewController: UIViewController, CastcleTabbarDeleDelegate {
    
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

        self.customNavigationBar(.primary, title: "For You", leftBarButton: .logo, rightBarButton: [.menu])
        FeedViewController.castcleTabbarDelegate = self
        
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
    
    func castcleTabbar(didSelectButtonBar button: BarButtonActionType) {
        print(button)
    }
}

// MARK: - ListAdapterDataSource
extension FeedViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var items: [ListDiffable] = [FeedType.newPost.rawValue] as [ListDiffable]
        if self.viewModel.hashtagShelf.hashtags.count > 0 {
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
