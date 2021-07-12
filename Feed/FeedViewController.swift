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
        view.backgroundColor = UIColor.Asset.black
      return view
    }()
    
    lazy var adapter: ListAdapter = {
      return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    enum FeedType: Int {
        case newPost = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.customNavigationBar(.primary, title: "For You", leftBarButton: .logo, rightBarButton: [.menu])
        FeedViewController.castcleTabbarDelegate = self
        
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func castcleTabbar(didSelectButtonBar button: BarButtonActionType) {
        print(button)
    }
}

// MARK: - ListAdapterDataSource
extension FeedViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let items = [FeedType.newPost.rawValue] as [ListDiffable]
//        items += loader.entries as [ListDiffable]
//        items += pathfinder.messages as [ListDiffable]
        
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
//        if object is Int {
          return NewPostSectionController()
//        } else {
//          return ListSectionController()
//        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
