//
//  CCMain+Menu.swift
//  Nextcloud
//
//  Created by Philippe Weidmann on 24.01.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//  Copyright © 2020 Marino Faggiana All rights reserved.
//
//  Author Philippe Weidmann <philippe.weidmann@infomaniak.com>
//  Author Marino Faggiana <marino.faggiana@nextcloud.com>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import FloatingPanel

extension CCMain {

    private func initSortMenu() -> [NCMenuAction] {
        var actions = [NCMenuAction]()

        actions.append(
            NCMenuAction(
                title: NSLocalizedString("_order_by_name_a_z_", comment: ""),
                icon: CCGraphics.changeThemingColorImage(UIImage(named: "sortFileNameAZ"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                onTitle: NSLocalizedString("_order_by_name_z_a_", comment: ""),
                onIcon: CCGraphics.changeThemingColorImage(UIImage(named: "sortFileNameZA"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                selected: CCUtility.getOrderSettings() == "fileName",
                on: CCUtility.getAscendingSettings(),
                action: { menuAction in
                    if(CCUtility.getOrderSettings() == "fileName") {
                        CCUtility.setAscendingSettings(!CCUtility.getAscendingSettings())
                    } else {
                        CCUtility.setOrderSettings("fileName")
                    }

                    NotificationCenter.default.post(name: Notification.Name.init(rawValue: "clearDateReadDataSource"), object: nil)
                }
            )
        )

        actions.append(
            NCMenuAction(
                title: NSLocalizedString("_order_by_date_more_recent_", comment: ""),
                icon: CCGraphics.changeThemingColorImage(UIImage(named: "sortDateMoreRecent"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                onTitle: NSLocalizedString("_order_by_date_less_recent_", comment: ""),
                onIcon: CCGraphics.changeThemingColorImage(UIImage(named: "sortDateLessRecent"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                selected: CCUtility.getOrderSettings() == "date",
                on: CCUtility.getAscendingSettings(),
                action: { menuAction in
                    if(CCUtility.getOrderSettings() == "date") {
                        CCUtility.setAscendingSettings(!CCUtility.getAscendingSettings())
                    } else {
                        CCUtility.setOrderSettings("date")
                    }

                    NotificationCenter.default.post(name: Notification.Name.init(rawValue: "clearDateReadDataSource"), object: nil)
                }
            )
        )

        actions.append(
            NCMenuAction(
                title: NSLocalizedString("_order_by_size_smallest_", comment: ""),
                icon: CCGraphics.changeThemingColorImage(UIImage(named: "sortSmallest"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                onTitle: NSLocalizedString("_order_by_size_largest_", comment: ""),
                onIcon: CCGraphics.changeThemingColorImage(UIImage(named: "sortLargest"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                selected: CCUtility.getOrderSettings() == "size",
                on: CCUtility.getAscendingSettings(),
                action: { menuAction in
                    if(CCUtility.getOrderSettings() == "size") {
                        CCUtility.setAscendingSettings(!CCUtility.getAscendingSettings())
                    } else {
                        CCUtility.setOrderSettings("size")
                    }

                    NotificationCenter.default.post(name: Notification.Name.init(rawValue: "clearDateReadDataSource"), object: nil)
                }
            )
        )

        actions.append(
            NCMenuAction(
                title: NSLocalizedString("_directory_on_top_no_", comment: ""),
                icon: CCGraphics.changeThemingColorImage(UIImage(named: "foldersOnTop"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                selected: CCUtility.getDirectoryOnTop(),
                on: CCUtility.getDirectoryOnTop(),
                action: { menuAction in
                    CCUtility.setDirectoryOnTop(!CCUtility.getDirectoryOnTop())
                    NotificationCenter.default.post(name: Notification.Name.init(rawValue: "clearDateReadDataSource"), object: nil)
                }
            )
        )

        return actions
    }

    @objc func toggleMenu(viewController: UIViewController) {
        let mainMenuViewController = UIStoryboard.init(name: "NCMenu", bundle: nil).instantiateViewController(withIdentifier: "NCMainMenuTableViewController") as! NCMainMenuTableViewController
        mainMenuViewController.actions = self.initSortMenu()

        let menuPanelController = NCMenuPanelController()
        menuPanelController.parentPresenter = viewController
        menuPanelController.delegate = mainMenuViewController
        menuPanelController.set(contentViewController: mainMenuViewController)
        menuPanelController.track(scrollView: mainMenuViewController.tableView)

        viewController.present(menuPanelController, animated: true, completion: nil)
    }

    @objc func toggleSelectMenu(viewController: UIViewController) {
        let mainMenuViewController = UIStoryboard.init(name: "NCMenu", bundle: nil).instantiateViewController(withIdentifier: "NCMainMenuTableViewController") as! NCMainMenuTableViewController
        mainMenuViewController.actions = self.initSelectMenu()

        let menuPanelController = NCMenuPanelController()
        menuPanelController.parentPresenter = viewController
        menuPanelController.delegate = mainMenuViewController
        menuPanelController.set(contentViewController: mainMenuViewController)
        menuPanelController.track(scrollView: mainMenuViewController.tableView)

        viewController.present(menuPanelController, animated: true, completion: nil)
    }


    private func initSelectMenu() -> [NCMenuAction] {
        var actions = [NCMenuAction]()

        actions.append(
            NCMenuAction(
                title: NSLocalizedString("_select_all_", comment: ""),
                icon: CCGraphics.changeThemingColorImage(UIImage(named: "selectFull"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                action: { menuAction in
                    self.didSelectAll()
                }
            )
        )

        actions.append(
            NCMenuAction(
                title: NSLocalizedString("_move_selected_files_", comment: ""),
                icon: CCGraphics.changeThemingColorImage(UIImage(named: "move"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                action: { menuAction in
                    self.moveOpenWindow(self.tableView.indexPathsForSelectedRows)
                }
            )
        )

        actions.append(
            NCMenuAction(
                title: NSLocalizedString("_download_selected_files_folders_", comment: ""),
                icon: CCGraphics.changeThemingColorImage(UIImage(named: "downloadSelectedFiles"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                action: { menuAction in
                    self.downloadSelectedFilesFolders()
                }
            )
        )

        actions.append(
            NCMenuAction(
                title: NSLocalizedString("_save_selected_files_", comment: ""),
                icon: CCGraphics.changeThemingColorImage(UIImage(named: "saveSelectedFiles"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                action: { menuAction in
                    self.saveSelectedFiles()
                }
            )
        )

        actions.append(
            NCMenuAction(
                title: NSLocalizedString("_delete_selected_files_", comment: ""),
                icon: CCGraphics.changeThemingColorImage(UIImage(named: "trash"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                action: { menuAction in
                    self.deleteFile()
                }
            )
        )

        return actions
    }

    private func initMoreMenu(indexPath: IndexPath, metadata: tableMetadata, metadataFolder: tableMetadata) -> [NCMenuAction] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let autoUploadFileName = NCManageDatabase.sharedInstance.getAccountAutoUploadFileName()
        let autoUploadDirectory = NCManageDatabase.sharedInstance.getAccountAutoUploadDirectory(appDelegate.activeUrl)

        var actions = [NCMenuAction]()

        if (metadata.directory) {
            var lockDirectory = false
            var isOffline = false
            let isFolderEncrypted = CCUtility.isFolderEncrypted("\(self.serverUrl ?? "")/\(metadata.fileName)", account: appDelegate.activeAccount)
            var passcodeTitle = NSLocalizedString("_protect_passcode_", comment: "")


            let dirServerUrl = CCUtility.stringAppendServerUrl(self.metadata.serverUrl, addFileName: metadata.fileName)!

            if let directory = NCManageDatabase.sharedInstance.getTableDirectory(predicate: NSPredicate(format: "account == %@ AND serverUrl == %@", appDelegate.activeAccount, dirServerUrl)) {
                if (CCUtility.getBlockCode() != nil && appDelegate.sessionePasscodeLock == nil) {
                    lockDirectory = true
                }
                if (directory.lock) {
                    passcodeTitle = NSLocalizedString("_protect_passcode_", comment: "")
                }

                isOffline = directory.offline
            }

            actions.append(
                NCMenuAction(
                    title: metadata.fileNameView,
                    icon: CCGraphics.changeThemingColorImage(UIImage(named: "folder"), width: 50, height: 50, color: NCBrandColor.sharedInstance.brandElement),
                    action: nil
                )
            )

            actions.append(
                NCMenuAction(
                    title: metadata.favorite ? NSLocalizedString("_remove_favorites_", comment: "") : NSLocalizedString("_add_favorites_", comment: ""),
                    icon: CCGraphics.changeThemingColorImage(UIImage(named: "favorite"), width: 50, height: 50, color: NCBrandColor.sharedInstance.yellowFavorite),
                    action: { menuAction in
                        self.settingFavorite(metadata, favorite: !metadata.favorite)
                    }
                )
            )

            if (!lockDirectory && !isFolderEncrypted) {
                actions.append(
                    NCMenuAction(
                        title: NSLocalizedString("_details_", comment: ""),
                        icon: CCGraphics.changeThemingColorImage(UIImage(named: "details"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                        action: { menuAction in
                            NCMainCommon.sharedInstance.openShare(ViewController: self, metadata: metadata, indexPage: 0)
                        }
                    )
                )
            }

            if(!(metadata.fileName == autoUploadFileName && metadata.serverUrl == autoUploadDirectory) && !lockDirectory && !metadata.e2eEncrypted) {
                actions.append(
                    NCMenuAction(
                        title: NSLocalizedString("_rename_", comment: ""),
                        icon: CCGraphics.changeThemingColorImage(UIImage(named: "rename"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                        action: { menuAction in
                            let alertController = UIAlertController(title: NSLocalizedString("_rename_", comment: ""), message: nil, preferredStyle: .alert)

                            alertController.addTextField { (textField) in
                                textField.text = metadata.fileNameView
                                textField.delegate = self as? UITextFieldDelegate
                                textField.addTarget(self, action: #selector(self.minCharTextFieldDidChange(_:)
                                    ), for: UIControl.Event.editingChanged)
                            }

                            let cancelAction = UIAlertAction(title: NSLocalizedString("_cancel_", comment: ""), style: .cancel, handler: nil)

                            let okAction = UIAlertAction(title: NSLocalizedString("_ok_", comment: ""), style: .default, handler: { action in
                                    let fileName = alertController.textFields![0].text
                                    self.perform(#selector(self.renameFile(_:)), on: .main, with: [metadata, fileName!], waitUntilDone: false)

                                })
                            okAction.isEnabled = false
                            alertController.addAction(cancelAction)
                            alertController.addAction(okAction)

                            self.present(alertController, animated: true, completion: nil)
                        }
                    )
                )
            }

            if (!(metadata.fileName == autoUploadFileName && metadata.serverUrl == autoUploadDirectory) && !lockDirectory && !isFolderEncrypted) {
                actions.append(
                    NCMenuAction(
                        title: NSLocalizedString("_move_", comment: ""),
                        icon: CCGraphics.changeThemingColorImage(UIImage(named: "move"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                        action: { menuAction in
                            self.moveOpenWindow([indexPath])
                        }
                    )
                )
            }

            if (!isFolderEncrypted) {
                actions.append(
                    NCMenuAction(
                        title: isOffline ? NSLocalizedString("_remove_available_offline_", comment: "") : NSLocalizedString("_set_available_offline_", comment: ""),
                        icon: CCGraphics.changeThemingColorImage(UIImage(named: "offline"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                        action: { menuAction in
                            NCManageDatabase.sharedInstance.setDirectory(serverUrl: dirServerUrl, offline: !isOffline, account: appDelegate.activeAccount)
                            if(isOffline) {
                                CCSynchronize.shared()?.readFolder(dirServerUrl, selector: selectorReadFolderWithDownload, account: appDelegate.activeAccount)
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    )
                )
            }

            actions.append(
                NCMenuAction(
                    title: passcodeTitle,
                    icon: CCGraphics.changeThemingColorImage(UIImage(named: "settingsPasscodeYES"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                    action: { menuAction in
                        self.perform(#selector(self.comandoLockPassword))
                    }
                )
            )

            if (!metadata.e2eEncrypted && CCUtility.isEnd(toEndEnabled: appDelegate.activeAccount)) {
                actions.append(
                    NCMenuAction(
                        title: NSLocalizedString("_e2e_set_folder_encrypted_", comment: ""),
                        icon: CCGraphics.changeThemingColorImage(UIImage(named: "lock"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                        action: { menuAction in
                            DispatchQueue.global(qos: .userInitiated).async {
                                let error = NCNetworkingEndToEnd.sharedManager()?.markFolderEncrypted(onServerUrl: "\(self.serverUrl ?? "")/\(metadata.fileName)", ocId: metadata.ocId, user: appDelegate.activeUser, userID: appDelegate.activeUserID, password: appDelegate.activePassword, url: appDelegate.activeUrl)
                                DispatchQueue.main.async {
                                    if(error != nil) {
                                        NCContentPresenter.shared.messageNotification(NSLocalizedString("_e2e_error_mark_folder_", comment: ""), description: error?.localizedDescription, delay: TimeInterval(k_dismissAfterSecond), type: .error, errorCode: (error! as NSError).code)
                                    } else {
                                        NCManageDatabase.sharedInstance.deleteE2eEncryption(predicate: NSPredicate(format: "account == %@ AND serverUrl == %@", appDelegate.activeAccount, "\(self.serverUrl ?? "")/\(metadata.fileName)"))
                                        self.readFolder(self.serverUrl)
                                    }
                                }
                            }
                        }
                    )
                )
            }

            if (metadata.e2eEncrypted && !metadataFolder.e2eEncrypted && CCUtility.isEnd(toEndEnabled: appDelegate.activeAccount)) {
                actions.append(
                    NCMenuAction(
                        title: NSLocalizedString("_e2e_remove_folder_encrypted_", comment: ""),
                        icon: CCGraphics.changeThemingColorImage(UIImage(named: "lock"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                        action: { menuAction in
                            DispatchQueue.global(qos: .userInitiated).async {
                                let error = NCNetworkingEndToEnd.sharedManager()?.deletemarkEndToEndFolderEncrypted(onServerUrl: "\(self.serverUrl ?? "")/\(metadata.fileName)", ocId: metadata.ocId, user: appDelegate.activeUser, userID: appDelegate.activeUserID, password: appDelegate.activePassword, url: appDelegate.activeUrl)
                                DispatchQueue.main.async {
                                    if(error != nil) {
                                        NCContentPresenter.shared.messageNotification(NSLocalizedString("_e2e_error_delete_mark_folder_", comment: ""), description: error?.localizedDescription, delay: TimeInterval(k_dismissAfterSecond), type: .error, errorCode: (error! as NSError).code)
                                    } else {
                                        NCManageDatabase.sharedInstance.deleteE2eEncryption(predicate: NSPredicate(format: "account == %@ AND serverUrl == %@", appDelegate.activeAccount, "\(self.serverUrl ?? "")/\(metadata.fileName)"))
                                        self.readFolder(self.serverUrl)
                                    }
                                }
                            }
                        }
                    )
                )
            }
        } else {
            var iconHeader: UIImage!
            if let icon = UIImage(contentsOfFile: CCUtility.getDirectoryProviderStorageIconOcId(metadata.ocId, fileNameView: metadata.fileNameView)) {
                iconHeader = icon
            } else {
                iconHeader = UIImage(named: metadata.iconName)
            }

            actions.append(
                NCMenuAction(
                    title: metadata.fileNameView,
                    icon: iconHeader,
                    action: nil
                )
            )

            actions.append(
                NCMenuAction(
                    title: metadata.favorite ? NSLocalizedString("_remove_favorites_", comment: "") : NSLocalizedString("_add_favorites_", comment: ""),
                    icon: CCGraphics.changeThemingColorImage(UIImage(named: "favorite"), width: 50, height: 50, color: NCBrandColor.sharedInstance.yellowFavorite),
                    action: { menuAction in
                        self.settingFavorite(metadata, favorite: !metadata.favorite)
                    }
                )
            )

            if (!metadataFolder.e2eEncrypted) {
                actions.append(
                    NCMenuAction(
                        title: NSLocalizedString("_details_", comment: ""),
                        icon: CCGraphics.changeThemingColorImage(UIImage(named: "details"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                        action: { menuAction in
                            NCMainCommon.sharedInstance.openShare(ViewController: self, metadata: metadata, indexPage: 0)
                        }
                    )
                )
            }

            if(!NCBrandOptions.sharedInstance.disable_openin_file) {
                actions.append(
                    NCMenuAction(title: NSLocalizedString("_open_in_", comment: ""),
                        icon: CCGraphics.changeThemingColorImage(UIImage(named: "openFile"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                        action: { menuAction in
                            self.tableView.setEditing(false, animated: true)
                            NCMainCommon.sharedInstance.downloadOpen(metadata: metadata, selector: selectorOpenIn)
                        }
                    )
                )
            }

            if(metadata.typeFile != k_metadataTypeFile_imagemeter) {
                actions.append(
                    NCMenuAction(
                        title: NSLocalizedString("_rename_", comment: ""),
                        icon: CCGraphics.changeThemingColorImage(UIImage(named: "rename"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                        action: { menuAction in
                            let alertController = UIAlertController(title: NSLocalizedString("_rename_", comment: ""), message: nil, preferredStyle: .alert)

                            alertController.addTextField { (textField) in
                                textField.text = metadata.fileNameView
                                textField.delegate = self as? UITextFieldDelegate
                                textField.addTarget(self, action: #selector(self.minCharTextFieldDidChange(_:)
                                    ), for: UIControl.Event.editingChanged)
                            }

                            let cancelAction = UIAlertAction(title: NSLocalizedString("_cancel_", comment: ""), style: .cancel, handler: nil)

                            let okAction = UIAlertAction(title: NSLocalizedString("_ok_", comment: ""), style: .default, handler: { action in
                                    let fileName = alertController.textFields![0].text
                                    self.perform(#selector(self.renameFile(_:)), on: .main, with: [metadata, fileName!], waitUntilDone: false)

                                })
                            okAction.isEnabled = false
                            alertController.addAction(cancelAction)
                            alertController.addAction(okAction)

                            self.present(alertController, animated: true, completion: nil)
                        }
                    )
                )
            }
            
            if (!metadataFolder.e2eEncrypted) {
                actions.append(
                    NCMenuAction(
                        title: NSLocalizedString("_move_", comment: ""),
                        icon: CCGraphics.changeThemingColorImage(UIImage(named: "move"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                        action: { menuAction in
                            self.moveOpenWindow([indexPath])
                        }
                    )
                )
            }

            if(NCUtility.sharedInstance.isEditImage(metadata.fileNameView as NSString) != nil && !metadataFolder.e2eEncrypted && metadata.status == k_metadataStatusNormal) {
                actions.append(
                    NCMenuAction(title: NSLocalizedString("_modify_photo_", comment: ""),
                        icon: CCGraphics.changeThemingColorImage(UIImage(named: "modifyPhoto"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                        action: { menuAction in
                            metadata.session = k_download_session
                            metadata.sessionError = ""
                            metadata.sessionSelector = selectorDownloadEditPhoto
                            metadata.status = Int(k_metadataStatusWaitDownload)

                            _ = NCManageDatabase.sharedInstance.addMetadata(metadata)
                            appDelegate.startLoadAutoDownloadUpload()
                        }
                    )
                )
            }

            if (!metadataFolder.e2eEncrypted) {
                let localFile = NCManageDatabase.sharedInstance.getTableLocalFile(predicate: NSPredicate(format: "ocId == %@", metadata.ocId))
                var title: String!
                if (localFile == nil || localFile!.offline == false) {
                    title = NSLocalizedString("_set_available_offline_", comment: "")
                } else {
                    title = NSLocalizedString("_remove_available_offline_", comment: "")
                }

                actions.append(
                    NCMenuAction(
                        title: title,
                        icon: CCGraphics.changeThemingColorImage(UIImage(named: "offline"), width: 50, height: 50, color: NCBrandColor.sharedInstance.icon),
                        action: { menuAction in
                            if (localFile == nil || !CCUtility.fileProviderStorageExists(metadata.ocId, fileNameView: metadata.fileNameView)) {
                                metadata.session = k_download_session
                                metadata.sessionError = ""
                                metadata.sessionSelector = selectorLoadOffline
                                metadata.status = Int(k_metadataStatusWaitDownload)

                                _ = NCManageDatabase.sharedInstance.addMetadata(metadata)
                                NCMainCommon.sharedInstance.reloadDatasource(ServerUrl: self.serverUrl, ocId: metadata.ocId, action: k_action_MOD)
                                appDelegate.startLoadAutoDownloadUpload()
                            } else {
                                NCManageDatabase.sharedInstance.setLocalFile(ocId: metadata.ocId, offline: !localFile!.offline)
                                DispatchQueue.main.async {
                                    self.tableView.reloadRows(at: [indexPath], with: .none)
                                }
                            }
                        }
                    )
                )
            }
        }

        actions.append(
            NCMenuAction(
                title: NSLocalizedString("_delete_", comment: ""),
                icon: CCGraphics.changeThemingColorImage(UIImage(named: "trash"), width: 50, height: 50, color: .red),
                action: { menuAction in
                    self.actionDelete(indexPath)
                }
            )
        )

        return actions
    }

    @objc func toggleMoreMenu(viewController: UIViewController, indexPath: IndexPath, metadata: tableMetadata, metadataFolder: tableMetadata) {
        let mainMenuViewController = UIStoryboard.init(name: "NCMenu", bundle: nil).instantiateViewController(withIdentifier: "NCMainMenuTableViewController") as! NCMainMenuTableViewController
        mainMenuViewController.actions = self.initMoreMenu(indexPath: indexPath, metadata: metadata, metadataFolder: metadataFolder)

        let menuPanelController = NCMenuPanelController()
        menuPanelController.parentPresenter = viewController
        menuPanelController.delegate = mainMenuViewController
        menuPanelController.set(contentViewController: mainMenuViewController)
        menuPanelController.track(scrollView: mainMenuViewController.tableView)

        viewController.present(menuPanelController, animated: true, completion: nil)
    }

}
