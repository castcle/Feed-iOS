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
//  Created by Castcle Co., Ltd. on 6/7/2564 BE.
//

import UIKit
import Core
import Networking
import Component
import Post
import Authen
import Profile
import Setting
import PanModal
import Defaults

class FeedViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var emptyTitleLabel: UILabel!
    @IBOutlet var retryButton: UIButton!
    
    var viewModel = FeedViewModel()
    var isLoadData: Bool = false
    
    enum FeedCellType {
        case activity
        case header
        case content
        case footer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNevBar()
        self.configureTableView()
        
        self.emptyTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.emptyTitleLabel.textColor = UIColor.Asset.white
        self.retryButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .body)
        self.retryButton.setTitleColor(UIColor.Asset.lightGray, for: .normal)
        self.emptyView.isHidden = true
        
        self.tableView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            guard let self = self else { return }
            self.isLoadData = true
            self.viewModel.getFeeds(isReset: true)
        }
        
        self.tableView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            guard let self = self else { return }
            if self.viewModel.pagination.next != 0 {
                self.isLoadData = true
                self.viewModel.feedRequest.page = self.viewModel.pagination.next
                self.viewModel.getFeeds(isReset: false)
            } else {
                self.tableView.cr.noticeNoMoreData()
            }
        }
        
        self.viewModel.didLoadHashtagsFinish = {
            // Load Hastag Finish
        }
        
        self.viewModel.didLoadFeedsFinish = {
            self.viewModel.state = .loaded
            self.tableView.isScrollEnabled = true
            UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.tableView.cr.endHeaderRefresh()
                self.tableView.cr.endLoadingMore()
                self.tableView.reloadData()
                self.isLoadData = false
            })
        }
    }
    
    private func setupNevBar() {
        self.customNavigationBar(.primary, title: "For You", textColor: UIColor.Asset.lightBlue, leftBarButton: .logo)
        
        let leftIcon = NavBarButtonType.logo.barButton
        leftIcon.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftIcon)
        
        var rightButton: [UIBarButtonItem] = []
        if UserManager.shared.isLogin {
            let rightIcon = NavBarButtonType.menu.barButton
            rightIcon.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
            rightButton.append(UIBarButtonItem(customView: rightIcon))
        } else {
            let rightIcon = NavBarButtonType.righProfile.barButton
            rightIcon.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
            rightButton.append(UIBarButtonItem(customView: rightIcon))
        }
        self.navigationItem.rightBarButtonItems = rightButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNevBar()
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollTableView(notfication:)), name: .feedScrollToTop, object: nil)
        Defaults[.screenId] = ScreenId.feed.rawValue
        if Defaults[.startLoadFeed] {
            Defaults[.startLoadFeed] = false
            self.viewModel.feeds = []
            if self.viewModel.isFirstLaunch {
                self.viewModel.isFirstLaunch = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.viewModel.getFeeds(isReset: true)
                }
            } else {
                self.viewModel.getFeeds(isReset: true)
            }
        } else {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .feedScrollToTop, object: nil)
    }
    
    @objc func scrollTableView(notfication: NSNotification) {
        self.scrollToTop()
    }
    
    @objc private func leftButtonAction() {
        self.scrollToTop()
    }
    
    @objc private func rightButtonAction() {
        if UserManager.shared.isLogin {
            Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.setting), animated: true)
        } else {
            Utility.currentViewController().presentPanModal(AuthenOpener.open(.signUpMethod) as! SignUpMethodViewController)
        }
    }
    
    public func scrollToTop() {
        if !self.isLoadData {
            if self.tableView.contentOffset == .zero {
                self.tableView.cr.beginHeaderRefresh()
            } else {
                self.tableView.setContentOffset(.zero, animated: true)
            }
        }
    }
    
    func configureTableView() {
        self.tableView.isScrollEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: FeedNibVars.TableViewCell.post, bundle: ConfigBundle.feed), forCellReuseIdentifier: FeedNibVars.TableViewCell.post)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.headerFeed, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.headerFeed)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.footerFeed, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.footerFeed)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.postText, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.postText)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.postLink, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.postLink)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.postLinkPreview, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.postLinkPreview)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.imageX1, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.imageX1)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.imageX2, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.imageX2)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.imageX3, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.imageX3)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.imageXMore, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.imageXMore)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.blog, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.blog)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.blogNoImage, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.blogNoImage)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.skeleton, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.skeleton)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.activityHeader, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.activityHeader)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    @IBAction func retryAction(_ sender: Any) {
        self.viewModel.getFeeds(isReset: true)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.state == .loading {
            return 5
        } else {
            return self.viewModel.feeds.count + (UserManager.shared.isLogin ? 1 : 0)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.state == .loading {
            return 1
        } else {
            if UserManager.shared.isLogin {
                if section == 0 {
                    return 1
                } else {
                    let content = self.viewModel.feeds[section - 1].feedPayload
                    if content.isRecast {
                        return 4
                    } else {
                        return 3
                    }
                }
            } else {
                let content = self.viewModel.feeds[section].feedPayload
                if content.isRecast {
                    return 4
                } else {
                    return 3
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.state == .loading {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.skeleton, for: indexPath as IndexPath) as? SkeletonFeedTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.configCell()
            return cell ?? SkeletonFeedTableViewCell()
        } else {
            if UserManager.shared.isLogin {
                if indexPath.section == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FeedNibVars.TableViewCell.post, for: indexPath as IndexPath) as? NewPostTableViewCell
                    cell?.backgroundColor = UIColor.Asset.darkGray
                    cell?.configCell()
                    return cell ?? NewPostTableViewCell()
                } else {
                    let content = self.viewModel.feeds[indexPath.section - 1].feedPayload
                    if content.isRecast {
                        if indexPath.row == 0 {
                            return self.renderFeedCell(content: content, cellType: .activity, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 1 {
                            return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 2 {
                            return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
                        } else {
                            return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
                        }
                    } else {
                        if indexPath.row == 0 {
                            return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 1 {
                            return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
                        } else {
                            return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
                        }
                    }
                }
            } else {
                let content = self.viewModel.feeds[indexPath.section].feedPayload
                if content.isRecast {
                    if indexPath.row == 0 {
                        return self.renderFeedCell(content: content, cellType: .activity, tableView: tableView, indexPath: indexPath)
                    } else if indexPath.row == 1 {
                        return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
                    } else if indexPath.row == 2 {
                        return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
                    } else {
                        return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
                    }
                } else {
                    if indexPath.row == 0 {
                        return self.renderFeedCell(content: content, cellType: .header, tableView: tableView, indexPath: indexPath)
                    } else if indexPath.row == 1 {
                        return self.renderFeedCell(content: content, cellType: .content, tableView: tableView, indexPath: indexPath)
                    } else {
                        return self.renderFeedCell(content: content, cellType: .footer, tableView: tableView, indexPath: indexPath)
                    }
                }
            }
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
    
    func renderFeedCell(content: Content, cellType: FeedCellType, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var contentTemp = Content()
        if content.isRecast {
            contentTemp = ContentHelper().originalPostToContent(originalPost: content.originalPost)
        } else {
            contentTemp = content
        }
        
        switch cellType {
        case .activity:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.activityHeader, for: indexPath as IndexPath) as? ActivityHeaderTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.cellConfig(content: content)
            return cell ?? ActivityHeaderTableViewCell()
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.headerFeed, for: indexPath as IndexPath) as? HeaderTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.delegate = self
            cell?.content = contentTemp
            return cell ?? HeaderTableViewCell()
        case .footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.footerFeed, for: indexPath as IndexPath) as? FooterTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.delegate = self
            cell?.content = contentTemp
            return cell ?? FooterTableViewCell()
        default:
            return FeedCellHelper().renderFeedCell(content: contentTemp, tableView: self.tableView, indexPath: indexPath)
        }
    }
}

extension FeedViewController: HeaderTableViewCellDelegate {
    func didRemoveSuccess(_ headerTableViewCell: HeaderTableViewCell) {
//        if let indexPath = self.tableView.indexPath(for: headerTableViewCell) {
//            self.viewModel.contents.remove(at: indexPath.row)
//            self.tableView.reloadData()
//        }
    }
    
    func didTabProfile(_ headerTableViewCell: HeaderTableViewCell, author: Author) {
        if author.type == .page {
            ProfileOpener.openProfileDetail(author.type, castcleId: nil, displayName: "", page: Page().initCustom(displayName: author.displayName, castcleId: author.castcleId))
        } else {
            ProfileOpener.openProfileDetail(author.type, castcleId: author.castcleId, displayName: author.displayName, page: nil)
        }
    }
    
    func didAuthen(_ headerTableViewCell: HeaderTableViewCell) {
        Utility.currentViewController().presentPanModal(AuthenOpener.open(.signUpMethod) as! SignUpMethodViewController)
    }
}

extension FeedViewController: FooterTableViewCellDelegate {
    func didTabComment(_ footerTableViewCell: FooterTableViewCell, content: Content) {
        let commentNavi: UINavigationController = UINavigationController(rootViewController: ComponentOpener.open(.comment(CommentViewModel(content: content))))
        commentNavi.modalPresentationStyle = .fullScreen
        commentNavi.modalTransitionStyle = .crossDissolve
        Utility.currentViewController().present(commentNavi, animated: true)
    }
    
    func didTabQuoteCast(_ footerTableViewCell: FooterTableViewCell, content: Content, page: Page) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
            let vc = PostOpener.open(.post(PostViewModel(postType: .quoteCast, content: content, page: page)))
            vc.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(vc, animated: true, completion: nil)
        }
    }
    
    func didAuthen(_ footerTableViewCell: FooterTableViewCell) {
        Utility.currentViewController().presentPanModal(AuthenOpener.open(.signUpMethod) as! SignUpMethodViewController)
    }
}
