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
//  UserToFollowViewController.swift
//  Feed
//
//  Created by Castcle Co., Ltd. on 21/1/2565 BE.
//

import UIKit
import Core
import Defaults
import Networking
import Component
import Authen
import Profile

class UserToFollowViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var viewModel = UserToFollowViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
        
        self.viewModel.didLoadSuggestionUserFinish = {
            self.tableView.isScrollEnabled = true
            self.viewModel.state = .loaded
            self.tableView.cr.endHeaderRefresh()
            self.tableView.cr.endLoadingMore()
            UIView.transition(with: self.view, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            })
        }
        
        self.tableView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            guard let self = self else { return }
            self.tableView.cr.resetNoMore()
            self.viewModel.reloadData()
        }
        
        self.tableView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            guard let self = self else { return }
            if self.viewModel.meta.resultCount < self.viewModel.feedRequest.maxResults {
                self.tableView.cr.noticeNoMoreData()
            } else {
                self.viewModel.feedRequest.untilId = self.viewModel.meta.oldestId
                self.viewModel.getUserSuggestion()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Who to follow")
    }
    
    func configureTableView() {
        self.tableView.isScrollEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.userToFollow, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.userToFollow)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.skeletonUser, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.skeletonUser)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension UserToFollowViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.state == .loading {
            return 10
        } else {
            return self.viewModel.users.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.state == .loading {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.skeletonUser, for: indexPath as IndexPath) as? SkeletonUserTableViewCell
            cell?.configCell()
            cell?.backgroundColor = UIColor.Asset.darkGray
            return cell ?? SkeletonUserTableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.userToFollow, for: indexPath as IndexPath) as? UserToFollowTableViewCell
            cell?.configCell(user: self.viewModel.users[indexPath.section])
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.delegate = self
            return cell ?? UserToFollowTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 2))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
}

extension UserToFollowViewController: UserToFollowTableViewCellDelegate {
    func didTabProfile(_ userToFollowTableViewCell: UserToFollowTableViewCell, author: Author) {
        ProfileOpener.openProfileDetail(author.castcleId, displayName:author.displayName)
    }
    
    func didAuthen(_ userToFollowTableViewCell: UserToFollowTableViewCell) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
            NotificationCenter.default.post(name: .openSignInDelegate, object: nil, userInfo: nil)
        }
    }
}
