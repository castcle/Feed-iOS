//
//  HashtagCell.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 13/7/2564 BE.
//

import UIKit
import Core

class HashtagCell: UICollectionViewCell {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private var selectIndex: Int?
    var hashtagShelf: HashtagShelf? {
        didSet {
            if let hashtagShelf = self.hashtagShelf {
                if hashtagShelf.hashtags.count > 0 {
                    self.selectIndex = 0
                }
            } else {
                return
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.collectionView.register(UINib(nibName: FeedNibVars.CollectionViewCell.hashtagCapsule, bundle: ConfigBundle.feed), forCellWithReuseIdentifier: FeedNibVars.CollectionViewCell.hashtagCapsule)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
    }
    
    static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 60)
    }
}

extension HashtagCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hashtagShelf?.hashtags.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let hashtag = self.hashtagShelf?.hashtags[indexPath.row], let index = self.selectIndex {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedNibVars.CollectionViewCell.hashtagCapsule, for: indexPath as IndexPath) as? HashtagCapsuleCell
            cell?.titleLabel.text = hashtag.name
            
            if index == indexPath.row {
                cell?.configCell(isSelect: true)
            } else {
                cell?.configCell(isSelect: false)
            }
            
            return cell ?? UICollectionViewCell()
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectIndex = indexPath.row
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if let hashtag = self.hashtagShelf?.hashtags[indexPath.row] {
            return HashtagCapsuleCell.cellSize(height: 40, text: hashtag.name)
        } else {
            return CGSize.zero
        }
    }
}
