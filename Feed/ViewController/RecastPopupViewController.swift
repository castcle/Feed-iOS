//
//  RecastPopupViewController.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 22/7/2564 BE.
//

import UIKit
import Core
import PanModal
import Kingfisher

protocol RecastPopupViewControllerDelegate {
    func recastPopupViewController(_ view: RecastPopupViewController, didSelectRecastAction recastAction: RecastAction)
}

public enum RecastAction {
    case recast
    case quoteCast
}

class RecastPopupViewController: UIViewController {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var recastImage: UIImageView!
    @IBOutlet var quoteCastImage: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var recastLabel: UILabel!
    @IBOutlet var quoteCastLabel: UILabel!
    
    var delegate: RecastPopupViewControllerDelegate?
    var maxHeight = (UIScreen.main.bounds.height - 320)
    var viewModel = RecastPopupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        
        let url = URL(string: "https://images.mubicdn.net/images/cast_member/2184/cache-2992-1547409411/image-w856.jpg")
        self.avatarImage.kf.setImage(with: url)
        self.recastImage.image = UIImage.init(icon: .castcle(.recast), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.quoteCastImage.image = UIImage.init(icon: .castcle(.pencil), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white)
        
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.displayNameLabel.font = UIFont.asset(.medium, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.medium, fontSize: .overline)
        self.subTitleLabel.textColor = UIColor.Asset.lightGray
        self.recastLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.recastLabel.textColor = UIColor.Asset.white
        self.quoteCastLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.quoteCastLabel.textColor = UIColor.Asset.white
        
        if self.viewModel.isRecasted {
            self.recastLabel.text = "Unrecasted"
        } else {
            self.recastLabel.text = "Recasted"
        }
    }
    
    @IBAction func recastAction(_ sender: Any) {
        self.dismiss(animated: true)
        self.delegate?.recastPopupViewController(self, didSelectRecastAction: .recast)
    }
    
    @IBAction func quoteCastAction(_ sender: Any) {
        self.dismiss(animated: true)
        self.delegate?.recastPopupViewController(self, didSelectRecastAction: .quoteCast)
    }
}

extension RecastPopupViewController: PanModalPresentable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(self.maxHeight)
    }

    var anchorModalToLongForm: Bool {
        return false
    }
}
