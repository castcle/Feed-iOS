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
//  QuoteCastListViewController.swift
//  Feed
//
//  Created by Castcle Co., Ltd. on 13/5/2565 BE.
//

import UIKit
import Core
import Component
import Profile
import Farming
import Networking
import Defaults

class QuoteCastListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var viewModel = QuoteCastListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()

        self.tableView.coreRefresh.addHeadRefresh(animator: FastAnimator()) {
            self.tableView.coreRefresh.resetNoMore()
            self.tableView.isScrollEnabled = false
            self.viewModel.loadState = .loading
            self.viewModel.contents = []
            self.viewModel.meta = Meta()
            self.tableView.reloadData()
            self.viewModel.getQuoteCast()
        }

        self.tableView.coreRefresh.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            guard let self = self else { return }
            if self.viewModel.meta.resultCount < self.viewModel.contentRequest.maxResults {
                self.tableView.coreRefresh.noticeNoMoreData()
            } else {
                self.viewModel.contentRequest.untilId = self.viewModel.meta.oldestId
                self.viewModel.getQuoteCast()
            }
        }

        self.viewModel.didLoadQuoteCastFinish = {
            self.tableView.isScrollEnabled = true
            self.tableView.coreRefresh.endHeaderRefresh()
            self.tableView.coreRefresh.endLoadingMore()
            if self.viewModel.meta.resultCount < self.viewModel.contentRequest.maxResults {
                self.tableView.coreRefresh.noticeNoMoreData()
            }
            UIView.transition(with: self.view, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Quote Casts", animated: true)
    }

    func configureTableView() {
        self.tableView.isScrollEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerFeedCell()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension QuoteCastListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.loadState == .loaded {
            return self.viewModel.contents.count
        } else {
            return 5
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.loadState == .loaded {
            return 4
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.loadState == .loaded {
            let content = self.viewModel.contents[indexPath.section]
            if indexPath.row == 0 {
                return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
            } else if indexPath.row == 1 {
                return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
            } else if indexPath.row == 2 {
                return self.renderFeedCell(content: content, cellType: .quote, tableView: tableView, indexPath: indexPath)
            } else {
                return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
            }
        } else {
            return FeedCellHelper().renderSkeletonCell(tableView: self.tableView, indexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 5))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.loadState == .loaded {
            let content = self.viewModel.contents[indexPath.section]
            if content.type == .long && indexPath.row == 1 {
                self.viewModel.contents[indexPath.section].isExpand.toggle()
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

    func renderFeedCell(content: Content, cellType: FeedCellType, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var originalContent = Content()
        if content.referencedCasts.type == .recasted || content.referencedCasts.type == .quoted {
            if let tempContent = ContentHelper.shared.getContentRef(id: content.referencedCasts.id) {
                originalContent = tempContent
            }
        }
        switch cellType {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.headerFeed, for: indexPath as IndexPath) as? HeaderTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.delegate = self
            cell?.configCell(feedType: .content, content: content, isDefaultContent: false)
            return cell ?? HeaderTableViewCell()
        case .footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.footerFeed, for: indexPath as IndexPath) as? FooterTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.delegate = self
            cell?.content = content
            return cell ?? FooterTableViewCell()
        case .quote:
            return FeedCellHelper().renderQuoteCastCell(content: originalContent, tableView: self.tableView, indexPath: indexPath, isRenderForFeed: true)
        default:
            if content.type == .long && !content.isExpand {
                return FeedCellHelper().renderLongCastCell(content: content, tableView: self.tableView, indexPath: indexPath)
            } else {
                return FeedCellHelper().renderFeedCell(content: content, tableView: self.tableView, indexPath: indexPath)
            }
        }
    }
}

extension QuoteCastListViewController: HeaderTableViewCellDelegate {
    func didRemoveSuccess(_ headerTableViewCell: HeaderTableViewCell) {
        // Remove success
    }

    func didReportSuccess(_ headerTableViewCell: HeaderTableViewCell) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.reportSuccess(true, "")), animated: true)
        }

        if let indexPath = self.tableView.indexPath(for: headerTableViewCell) {
            UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.viewModel.contents.remove(at: indexPath.section)
                self.tableView.reloadData()
            })
        }
    }
}

extension QuoteCastListViewController: FooterTableViewCellDelegate {
    func didTabComment(_ footerTableViewCell: FooterTableViewCell, content: Content) {
        Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.comment(CommentViewModel(contentId: content.id))), animated: true)
    }

    func didTabQuoteCast(_ footerTableViewCell: FooterTableViewCell, content: Content, page: Page) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let viewController = PostOpener.open(.post(PostViewModel(postType: .quoteCast, content: content, page: page)))
            viewController.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(viewController, animated: true, completion: nil)
        }
    }

    func didAuthen(_ footerTableViewCell: FooterTableViewCell) {
        NotificationCenter.default.post(name: .openSignInDelegate, object: nil, userInfo: nil)
    }

    func didViewFarmmingHistory(_ footerTableViewCell: FooterTableViewCell) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Utility.currentViewController().navigationController?.pushViewController(FarmingOpener.open(.contentFarming), animated: true)
        }
    }
}
