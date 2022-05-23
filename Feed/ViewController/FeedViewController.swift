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
import Authen
import Profile
import Setting
import Farming
import Wallet
import PanModal
import Defaults
import PopupDialog
import SwiftyJSON
import FirebaseRemoteConfig

class FeedViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var emptyTitleLabel: UILabel!
    @IBOutlet var retryButton: UIButton!

    var viewModel = FeedViewModel()
    var isLoadData: Bool = false

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

        self.tableView.coreRefresh.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            guard let self = self else { return }
            self.isLoadData = true
            self.viewModel.feedRequest.untilId = ""
            self.viewModel.feedRequest.maxResults = 6
            if UserManager.shared.isLogin {
                self.viewModel.getFeedsMembers(isReset: true)
            } else {
                self.viewModel.getFeedsGuests(isReset: true)
            }
        }

        self.tableView.coreRefresh.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            guard let self = self else { return }
            if !self.viewModel.meta.oldestId.isEmpty {
                self.isLoadData = true
                self.viewModel.feedRequest.untilId = self.viewModel.meta.oldestId
                self.viewModel.feedRequest.maxResults = 25
                if UserManager.shared.isLogin {
                    self.viewModel.getFeedsMembers(isReset: false)
                } else {
                    self.viewModel.getFeedsGuests(isReset: false)
                }
            } else {
                self.tableView.coreRefresh.noticeNoMoreData()
            }
        }

        self.viewModel.didLoadHashtagsFinish = {
            // Load Hastag Finish
        }

        self.viewModel.didLoadFeedsFinish = {
            self.viewModel.state = .loaded
            self.tableView.isScrollEnabled = true
            UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.tableView.coreRefresh.endHeaderRefresh()
                self.tableView.coreRefresh.endLoadingMore()
                self.tableView.reloadData()
                self.isLoadData = false
            })
        }
    }

    private func setupNevBar() {
        self.customNavigationBar(.primary, title: Localization.Feed.title.text, textColor: UIColor.Asset.lightBlue, leftBarButton: .logo)

        let leftIcon = NavBarButtonType.logo.barButton
        leftIcon.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftIcon)

        var rightButton: [UIBarButtonItem] = []
        if UserManager.shared.isLogin {
            let menuIcon = NavBarButtonType.menu.barButton
            menuIcon.addTarget(self, action: #selector(self.settingAction), for: .touchUpInside)
            rightButton.append(UIBarButtonItem(customView: menuIcon))

            let airdropIcon = NavBarButtonType.wallet.barButton
            airdropIcon.addTarget(self, action: #selector(self.airdropAction), for: .touchUpInside)
            airdropIcon.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 5)
            rightButton.append(UIBarButtonItem(customView: airdropIcon))
        } else {
            let rightIcon = NavBarButtonType.righProfile.barButton
            rightIcon.addTarget(self, action: #selector(self.authAction), for: .touchUpInside)
            rightButton.append(UIBarButtonItem(customView: rightIcon))
        }
        self.navigationItem.rightBarButtonItems = rightButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNevBar()
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollTableView(notification:)), name: .feedScrollToTop, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadFeedDisplay(notification:)), name: .feedReloadContent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetFeedContent(notification:)), name: .resetFeedContent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.syncTwittwerAutoPost(notification:)), name: .syncTwittwerAutoPost, object: nil)
        Defaults[.screenId] = ScreenId.feed.rawValue
        if Defaults[.startLoadFeed] {
            Defaults[.startLoadFeed] = false
            self.viewModel.feeds = []
            if self.viewModel.isFirstLaunch {
                self.viewModel.isFirstLaunch = false
            }
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .top, animated: true)
            }
            self.viewModel.feedRequest.untilId = ""
            self.viewModel.feedRequest.maxResults = 6
            self.viewModel.state = .loading
            self.tableView.isScrollEnabled = false
            self.tableView.reloadData()
            if UserManager.shared.isLogin {
                self.viewModel.getFeedsMembers(isReset: true)
            } else {
                self.viewModel.getFeedsGuests(isReset: true)
            }
        } else {
            self.tableView.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .feedScrollToTop, object: nil)
        NotificationCenter.default.removeObserver(self, name: .feedReloadContent, object: nil)
        NotificationCenter.default.removeObserver(self, name: .resetFeedContent, object: nil)
        NotificationCenter.default.removeObserver(self, name: .syncTwittwerAutoPost, object: nil)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        EngagementHelper().sendCastcleAnalytic(event: .onScreenView, screen: .feed)
        if Defaults[.isForceUpdate] {
            self.showAppUpdateAlert(force: true)
        } else if Defaults[.isSoftUpdate] {
            self.showAppUpdateAlert(force: false)
        }
    }

    private func showAppUpdateAlert(force: Bool) {
        var buttonList: [PopupDialogButton] = []
        let updatePopup = PopupDialog(title: Defaults[.updateTitle],
                                      message: Defaults[.updateMessage],
                                      buttonAlignment: .horizontal,
                                      transitionStyle: .zoomIn,
                                      tapGestureDismissal: false,
                                      panGestureDismissal: false,
                                      hideStatusBar: true)
        if !force {
            let cancelButton = CancelButton(title: "Cancel") {
                print("Cancel")
            }
            buttonList.append(cancelButton)
        }
        let updateButton = DefaultButton(title: Defaults[.updateButton], dismissOnTap: (force ? false : true)) {
            Defaults[.isSoftUpdate] = false
            guard let url = URL(string: Defaults[.updateUrl]) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        buttonList.append(updateButton)
        updatePopup.addButtons(buttonList)
        Utility.currentViewController().present(updatePopup, animated: true, completion: nil)
    }

    @objc func scrollTableView(notification: NSNotification) {
        self.scrollToTop()
    }

    @objc func reloadFeedDisplay(notification: NSNotification) {
        self.tableView.reloadData()
    }

    @objc func resetFeedContent(notification: NSNotification) {
        if Defaults[.startLoadFeed] {
            Defaults[.startLoadFeed] = false
            self.setupNevBar()
            self.viewModel.feeds = []
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .top, animated: true)
            }
            self.viewModel.feedRequest.untilId = ""
            self.viewModel.feedRequest.maxResults = 6
            self.viewModel.state = .loading
            self.tableView.isScrollEnabled = false
            self.tableView.reloadData()
            if UserManager.shared.isLogin {
                self.viewModel.getFeedsMembers(isReset: true)
            } else {
                self.viewModel.getFeedsGuests(isReset: true)
            }
        }
    }

    @objc func syncTwittwerAutoPost(notification: NSNotification) {
        if !Defaults[.startLoadFeed] {
            Defaults[.startLoadFeed] = true
            if let dict = notification.userInfo as NSDictionary? {
                let jsonData = JSON(dict)
                let pageSocial: PageSocial = PageSocial(json: jsonData)
                Utility.currentViewController().present(ComponentOpener.open(.syncAutoPostTwitter(SyncTwitterAutoPostViewModel(pageSocial: pageSocial))), animated: true)
            }
        }
    }

    @objc private func leftButtonAction() {
        self.scrollToTop()
    }

    @objc private func authAction() {
        NotificationCenter.default.post(name: .openSignInDelegate, object: nil, userInfo: nil)
    }

    @objc private func settingAction() {
        Utility.currentViewController().navigationController?.pushViewController(SettingOpener.open(.setting), animated: true)
    }

    @objc private func airdropAction() {
        let menuWallet = RemoteConfig.remoteConfig().configValue(forKey: "menu_wallet").numberValue
        if menuWallet == 2 {
            Utility.currentViewController().navigationController?.pushViewController(WalletOpener.open(.wallet), animated: true)
        } else {
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: "\(Environment.airdropUrl)?token=\(UserManager.shared.accessToken)&src=mobile")!)), animated: true)
        }
    }

    public func scrollToTop() {
        if !self.isLoadData {
            if self.tableView.contentOffset == .zero {
                self.tableView.coreRefresh.beginHeaderRefresh()
            } else {
                self.tableView.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .top, animated: true)
            }
        }
    }

    @IBAction func retryAction(_ sender: Any) {
        self.viewModel.feedRequest.untilId = ""
        self.viewModel.feedRequest.maxResults = 6
        if UserManager.shared.isLogin {
            self.viewModel.getFeedsMembers(isReset: true)
        } else {
            self.viewModel.getFeedsGuests(isReset: true)
        }
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
                    let feed = self.viewModel.feeds[section - 1]
                    if feed.type == .suggestionFollow {
                        return 1
                    } else {
                        if feed.content.referencedCasts.type == .recasted || feed.content.referencedCasts.type == .quoted {
                            return 4
                        } else {
                            return 3
                        }
                    }
                }
            } else {
                let feed = self.viewModel.feeds[section]
                if feed.type == .suggestionFollow {
                    return 1
                } else {
                    if feed.content.referencedCasts.type == .recasted || feed.content.referencedCasts.type == .quoted {
                        return 4
                    } else {
                        return 3
                    }
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
                    let feed = self.viewModel.feeds[indexPath.section - 1]
                    let isDefaultContent: Bool = feed.id == "default"
                    if feed.type == .suggestionFollow {
                        return self.renderFeedCell(feedType: .suggestionFollow, content: Content(), user: feed.userToFollow, cellType: .none, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                    } else {
                        if feed.content.referencedCasts.type == .recasted {
                            if indexPath.row == 0 {
                                return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .activity, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                            } else if indexPath.row == 1 {
                                return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .header, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                            } else if indexPath.row == 2 {
                                self.viewModel.seenContent(feedId: feed.id)
                                return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .content, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                            } else {
                                return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .footer, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                            }
                        } else if feed.content.referencedCasts.type == .quoted {
                            if indexPath.row == 0 {
                                return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .header, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                            } else if indexPath.row == 1 {
                                self.viewModel.seenContent(feedId: feed.id)
                                return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .content, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                            } else if indexPath.row == 2 {
                                return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .quote, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                            } else {
                                return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .footer, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                            }
                        } else {
                            if indexPath.row == 0 {
                                return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .header, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                            } else if indexPath.row == 1 {
                                self.viewModel.seenContent(feedId: feed.id)
                                return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .content, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                            } else {
                                return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .footer, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                            }
                        }
                    }
                }
            } else {
                let feed = self.viewModel.feeds[indexPath.section]
                let isDefaultContent: Bool = feed.id == "default"
                if feed.type == .suggestionFollow {
                    return self.renderFeedCell(feedType: .suggestionFollow, content: Content(), user: feed.userToFollow, cellType: .none, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                } else {
                    if feed.content.referencedCasts.type == .recasted {
                        if indexPath.row == 0 {
                            return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .activity, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 1 {
                            return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .header, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 2 {
                            self.viewModel.seenContent(feedId: feed.id)
                            return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .content, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                        } else {
                            return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .footer, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                        }
                    } else if feed.content.referencedCasts.type == .quoted {
                        if indexPath.row == 0 {
                            return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .header, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 1 {
                            self.viewModel.seenContent(feedId: feed.id)
                            return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .content, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 2 {
                            return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .quote, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                        } else {
                            return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .footer, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                        }
                    } else {
                        if indexPath.row == 0 {
                            return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .header, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                        } else if indexPath.row == 1 {
                            self.viewModel.seenContent(feedId: feed.id)
                            return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .content, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                        } else {
                            return self.renderFeedCell(feedType: feed.type, content: feed.content, user: [], cellType: .footer, isDefaultContent: isDefaultContent, tableView: tableView, indexPath: indexPath)
                        }
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.state == .loading {
            return
        }
        if UserManager.shared.isLogin {
            if indexPath.section < 1 {
                return
            }
            var originalContent = Content()
            let feed = self.viewModel.feeds[indexPath.section - 1]
            if feed.content.referencedCasts.type == .recasted || feed.content.referencedCasts.type == .quoted {
                if let tempContent = ContentHelper.shared.getContentRef(id: feed.content.referencedCasts.id) {
                    originalContent = tempContent
                }
            }

            if feed.type != .content {
                return
            }
            if feed.content.referencedCasts.type == .recasted {
                if originalContent.type == .long && indexPath.row == 2 {
                    self.viewModel.feeds[indexPath.section - 1].content.isOriginalExpand.toggle()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            } else {
                if feed.content.type == .long && indexPath.row == 1 {
                    self.viewModel.feeds[indexPath.section - 1].content.isExpand.toggle()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        } else {
            var originalContent = Content()
            let feed = self.viewModel.feeds[indexPath.section]
            if feed.content.referencedCasts.type == .recasted || feed.content.referencedCasts.type == .quoted {
                if let tempContent = ContentHelper.shared.getContentRef(id: feed.content.referencedCasts.id) {
                    originalContent = tempContent
                }
            }

            if feed.type != .content {
                return
            }

            if feed.content.referencedCasts.type == .recasted {
                if originalContent.type == .long && indexPath.row == 2 {
                    self.viewModel.feeds[indexPath.section].content.isOriginalExpand.toggle()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            } else {
                if feed.content.type == .long && indexPath.row == 1 {
                    self.viewModel.feeds[indexPath.section].content.isExpand.toggle()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.viewModel.state == .loaded {
            var index: Int = 0
            if UserManager.shared.isLogin {
                if indexPath.section > 0 {
                    index = indexPath.section - 1
                } else {
                    return
                }
            } else {
                index = indexPath.section
            }
            if index >= self.viewModel.feeds.count {
                return
            }

            let feed = self.viewModel.feeds[index]
            if feed.type == .content {
                if feed.content.referencedCasts.type == .recasted {
                    if indexPath.row == 2 {
                        self.viewModel.castOffView(feedId: feed.id)
                    }
                } else {
                    if indexPath.row == 1 {
                        self.viewModel.castOffView(feedId: feed.id)
                    }
                }
            }
        }
    }

    func renderFeedCell(feedType: FeedType, content: Content, user: [Author], cellType: FeedCellType, isDefaultContent: Bool, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if feedType == .suggestionFollow {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.suggestionUser, for: indexPath as IndexPath) as? SuggestionUserTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.delegate = self
            cell?.configCell(user: user)
            return cell ?? SuggestionUserTableViewCell()
        } else if feedType == .content || feedType == .ads {
            var originalContent = Content()
            if content.referencedCasts.type == .recasted || content.referencedCasts.type == .quoted {
                if let tempContent = ContentHelper.shared.getContentRef(id: content.referencedCasts.id) {
                    originalContent = tempContent
                }
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
                if content.referencedCasts.type == .recasted {
                    cell?.configCell(feedType: feedType, content: originalContent, isDefaultContent: isDefaultContent)
                } else {
                    cell?.configCell(feedType: feedType, content: content, isDefaultContent: isDefaultContent)
                }
                return cell ?? HeaderTableViewCell()
            case .footer:
                let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.footerFeed, for: indexPath as IndexPath) as? FooterTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGray
                cell?.delegate = self
                if content.referencedCasts.type == .recasted {
                    cell?.content = originalContent
                } else {
                    cell?.content = content
                }
                return cell ?? FooterTableViewCell()
            case .quote:
                return FeedCellHelper().renderQuoteCastCell(content: originalContent, tableView: self.tableView, indexPath: indexPath, isRenderForFeed: true)
            case .pageAds:
                let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.adsPage, for: indexPath as IndexPath) as? AdsPageTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGray
                cell?.delegate = self
                return cell ?? AdsPageTableViewCell()
            case .reach:
                let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.reached, for: indexPath as IndexPath) as? ReachedTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGray
                return cell ?? ReachedTableViewCell()
            default:
                if content.referencedCasts.type == .recasted {
                    if originalContent.type == .long && !content.isOriginalExpand {
                        return FeedCellHelper().renderLongCastCell(content: originalContent, tableView: self.tableView, indexPath: indexPath)
                    } else {
                        return FeedCellHelper().renderFeedCell(content: originalContent, tableView: self.tableView, indexPath: indexPath)
                    }
                } else {
                    if content.type == .long && !content.isExpand {
                        return FeedCellHelper().renderLongCastCell(content: content, tableView: self.tableView, indexPath: indexPath)
                    } else {
                        return FeedCellHelper().renderFeedCell(content: content, tableView: self.tableView, indexPath: indexPath)
                    }
                }
            }
        } else {
            return UITableViewCell()
        }
    }
}

extension FeedViewController: HeaderTableViewCellDelegate {
    func didRemoveSuccess(_ headerTableViewCell: HeaderTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: headerTableViewCell) {
            self.viewModel.feeds.remove(at: indexPath.section)
            self.tableView.reloadData()
        }
    }

    func didTabProfile(_ headerTableViewCell: HeaderTableViewCell, author: Author) {
        ProfileOpener.openProfileDetail(author.castcleId, displayName: author.displayName)
    }

    func didAuthen(_ headerTableViewCell: HeaderTableViewCell) {
        NotificationCenter.default.post(name: .openSignInDelegate, object: nil, userInfo: nil)
    }

    func didReportSuccess(_ headerTableViewCell: HeaderTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: headerTableViewCell) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.reportSuccess(true, "")), animated: true)
            }

            UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.viewModel.feeds.remove(at: indexPath.section)
                self.tableView.reloadData()
            })
        }
    }
}

extension FeedViewController: FooterTableViewCellDelegate {
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

extension FeedViewController: SuggestionUserTableViewCellDelegate {
    func didSeeMore(_ suggestionUserTableViewCell: SuggestionUserTableViewCell, user: [Author]) {
        let viewController = FeedOpener.open(.userToFollow(UserToFollowViewModel()))
        Utility.currentViewController().navigationController?.pushViewController(viewController, animated: true)
    }

    func didTabProfile(_ suggestionUserTableViewCell: SuggestionUserTableViewCell, user: Author) {
        ProfileOpener.openProfileDetail(user.castcleId, displayName: user.displayName)
    }

    func didAuthen(_ suggestionUserTableViewCell: SuggestionUserTableViewCell) {
        NotificationCenter.default.post(name: .openSignInDelegate, object: nil, userInfo: nil)
    }
}

extension FeedViewController: AdsPageTableViewCellDelegate {
    func didAuthen(_ adsPageTableViewCell: AdsPageTableViewCell) {
        NotificationCenter.default.post(name: .openSignInDelegate, object: nil, userInfo: nil)
    }
}

extension FeedViewController {
    func configureTableView() {
        self.tableView.isScrollEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: FeedNibVars.TableViewCell.post, bundle: ConfigBundle.feed), forCellReuseIdentifier: FeedNibVars.TableViewCell.post)
        self.tableView.registerFeedCell()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}
