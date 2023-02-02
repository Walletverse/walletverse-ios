//
//  WalletManageViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/10.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class WalletManageViewController: BaseViewController {
    var identityModel: IdentityModel?
    var actionType = 1
    
    var commonLoadView : CommonLoadView?
    
    lazy var backV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    private lazy var mainTableV : UITableView = {
        let tableV = UITableView()
        tableV.backgroundColor = UIColor.clear
        tableV.layer.cornerRadius = 4
        tableV.clipsToBounds = true
        tableV.dataSource = self
        tableV.delegate = self
        tableV.alwaysBounceVertical = true
        tableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableV.scrollIndicatorInsets = tableV.contentInset
        tableV.separatorStyle = .none
        tableV.register(cellType: WalletManageTableCell.self)
        return tableV
    }()
    
    lazy var deleteV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var deleteL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_wallet_delete"), font: FontSystem(size: 14), color: Color_FF0000)
    }()
    
    lazy var deleteIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "MineRightArrow"))
    }()
    
    lazy var widL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_7D7F86)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBaseNaviLeft()
        baseNaviTitle.text = LocalString("asserts_wallet_manage")
    }
    
    override func configUI() {
        if identityModel?.tokenType == "mnemonic" {
            backV.frame = CGRect.init(x: 15, y: 15, width: ZSCREENWIDTH - 30, height: 180)
            backV.layer.cornerRadius = 4
            backV.clipsToBounds = true
            baseMainV.addSubview(backV)
            
            mainTableV.frame = CGRect.init(x: 0, y: 0, width: backV.width, height: backV.height)
            backV.addSubview(mainTableV)
        } else {
            backV.frame = CGRect.init(x: 15, y: 15, width: ZSCREENWIDTH - 30, height: 120)
            backV.layer.cornerRadius = 4
            backV.clipsToBounds = true
            baseMainV.addSubview(backV)
            
            mainTableV.frame = CGRect.init(x: 0, y: 0, width: backV.width, height: backV.height)
            backV.addSubview(mainTableV)
        }
        deleteV.frame = CGRect.init(x: 15, y: backV.bottom + 20, width: ZSCREENWIDTH - 30, height: 60)
        deleteV.layer.cornerRadius = 4
        deleteV.clipsToBounds = true
        let deleteGesture = UITapGestureRecognizer.init(target: self, action: #selector(deleteGestureClick))
        deleteV.addGestureRecognizer(deleteGesture)
        baseMainV.addSubview(deleteV)
        
        deleteL.frame = CGRect(x: 15, y: 0, width: ZSCREENWIDTH - 60 - 6, height: 60)
        deleteV.addSubview(deleteL)
        
        deleteIV.frame = CGRect(x: ZSCREENWIDTH - 30 - 21, y: (60 - 12)/2, width: 6, height: 12)
        deleteV.addSubview(deleteIV)
        
        widL.frame = CGRect(x: 20, y: deleteV.bottom + 30, width: ZSCREENWIDTH - 40, height: 70)
        widL.numberOfLines = 0
        widL.textAlignment = .center
        baseMainV.addSubview(widL)
        widL.text = "wid:\(identityModel?.wid ?? "")"
    }

    @objc func deleteGestureClick() {
        actionType = 4
        vertifyAction()
    }
    
    func deleteGestureAction() {
        commonLoadView = CommonLoadView()
        commonLoadView?.show()
        
        let walletCoinModel = Walletverse.getWalletCoinModel()
        walletCoinModel.wid = self.identityModel?.wid ?? ""
        Walletverse.queryWalletCoins(walletCoinModel: walletCoinModel) { (result) in
            if let walletArray = result {
                var count = walletArray.count
                for wallet in walletArray {
                    Walletverse.deleteWalletCoin(walletCoinModel: wallet) { (result) in
                        count = count - 1
                        if count == 0 {
                            Walletverse.deleteIdentity(identityModel: self.identityModel ?? Walletverse.getIdentityModel()) { (result) in
                                Walletverse.queryIdentities { (result) in
                                    
                                    self.commonLoadView?.dismiss()
                                    
                                    if let identityArray = result {
                                        if identityArray.count > 0 {
                                            let curIdentity = identityArray[0]
                                            UserDefaultUtil.setValue(value: curIdentity.wid ?? "", key: ZUSERDEFAULT_CURRENTWALLET)
                                            ZAPPDELEGATE?.applicationSetRootViewController()
                                        } else {
                                            UserDefaultUtil.setValue(value: "", key: ZUSERDEFAULT_CURRENTWALLET)
                                            UserDefaultUtil.setValue(value: "", key: ZUSERDEFAULT_WALLETPASSWORD)
                                            ZAPPDELEGATE?.applicationSetRootViewController()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                self.commonLoadView?.dismiss()
            }
        }
    }
    
    func vertifyAction() {
        let view = InputPasswordView()
        view.delegate = self
        view.show()
    }
    
    func verifyPassword(pwdString : String?) {
        let password = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
        if stringCompare(password, (pwdString ?? "")) {
            if actionType == 1 {
                let walletCoinModel = Walletverse.getWalletCoinModel()
                walletCoinModel.wid = identityModel?.wid
                walletCoinModel.contract = "ETH"
                walletCoinModel.symbol = "ETH"
                walletCoinModel.address = ""
                Walletverse.queryWalletCoin(walletCoinModel: walletCoinModel) { (result) in
                    if let walletCoin = result {
                        let decodeParams = JSCoreParams().put(key: "message", value: walletCoin.privateKey ?? "")?.put(key: "password", value: password ?? "") ?? JSCoreParams()
                        Walletverse.decodeMessage(params: decodeParams) { (returnData, error) in
                            if let privateKey = returnData {
                                let alertV = CustomAlertView.init(title: "Walletverse", message: privateKey as? String ?? "", preferredStyle: UIAlertController.Style.alert)
                                alertV.addAction(UIAlertAction.init(title: "Copy", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                                    let pasteboard = UIPasteboard.general
                                    pasteboard.string =  privateKey as? String ?? ""
                                    CommonToastView.showToastAction(message: LocalString("common_already_copy"))
                                }))
                                self.present(alertV, animated: true, completion: nil)
                            }
                        }
                    }
                }
            } else if actionType == 2 {
                let decodeParams = JSCoreParams().put(key: "message", value: identityModel?.token ?? "")?.put(key: "password", value: password ?? "") ?? JSCoreParams()
                Walletverse.decodeMessage(params: decodeParams) { (returnData, error) in
                    if let mnemonic = returnData {
                        let alertV = CustomAlertView.init(title: "Walletverse", message: mnemonic as? String ?? "", preferredStyle: UIAlertController.Style.alert)
                        alertV.addAction(UIAlertAction.init(title: "Copy", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                            let pasteboard = UIPasteboard.general
                            pasteboard.string =  mnemonic as? String ?? ""
                            CommonToastView.showToastAction(message: LocalString("common_already_copy"))
                        }))
                        self.present(alertV, animated: true, completion: nil)
                    }
                }
            } else if actionType == 3 {
                let walletCoinModel = Walletverse.getWalletCoinModel()
                walletCoinModel.wid = identityModel?.wid
                walletCoinModel.contract = "ETH"
                walletCoinModel.symbol = "ETH"
                walletCoinModel.address = ""
                Walletverse.queryWalletCoin(walletCoinModel: walletCoinModel) { (result) in
                    if let walletCoin = result {
                        let decodeParams = JSCoreParams().put(key: "message", value: walletCoin.privateKey ?? "")?.put(key: "password", value: password ?? "") ?? JSCoreParams()
                        Walletverse.decodeMessage(params: decodeParams) { (returnData, error) in
                            if let privateKey = returnData {
                                let alertV = CustomAlertView.init(title: "Walletverse", message: privateKey as? String ?? "", preferredStyle: UIAlertController.Style.alert)
                                alertV.addAction(UIAlertAction.init(title: "Copy", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                                    let pasteboard = UIPasteboard.general
                                    pasteboard.string =  privateKey as? String ?? ""
                                    CommonToastView.showToastAction(message: LocalString("common_already_copy"))
                                }))
                                self.present(alertV, animated: true, completion: nil)
                            }
                        }
                    }
                }
            } else if actionType == 4 {
                deleteGestureAction()
            }
        } else {
            let alertV = CustomAlertView.init(title: "", message: LocalString("assets_host_password_error"), preferredStyle: UIAlertController.Style.alert)
            alertV.addAction(UIAlertAction.init(title: LocalString("assets_inpput_again"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                self.vertifyAction()
            }))
            self.present(alertV, animated: true, completion: nil)
        }
    }
}

extension WalletManageViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if identityModel?.tokenType == "mnemonic" {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: WalletManageTableCell.self)
        if identityModel?.tokenType == "mnemonic" {
            switch indexPath.row {
            case 0:
                cell.nameL.text = LocalString("asserts_wallet_modify")
                break
            case 1:
                cell.nameL.text = LocalString("asserts_wallet_privatekey")
                break
            case 2:
                cell.nameL.text = LocalString("asserts_wallet_mnemonic")
                break
            
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                cell.nameL.text = LocalString("asserts_wallet_modify")
                break
            case 1:
                cell.nameL.text = LocalString("asserts_wallet_privatekey")
                break
            
            default:
                break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if identityModel?.tokenType == "mnemonic" {
            switch indexPath.row {
            case 0:
                let view = InputNameView()
                view.delegate = self
                view.show()
                break
            case 1:
                actionType = 1
                vertifyAction()
                break
            case 2:
                actionType = 2
                vertifyAction()
                break
            
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                let view = InputNameView()
                view.delegate = self
                view.show()
                break
            case 1:
                actionType = 3
                vertifyAction()
                break
            
            default:
                break
            }
        }
    }
    
}

extension WalletManageViewController : InputPasswordViewDelegate {
    func inputPasswordDelegate(pwd: String) {
        self.verifyPassword(pwdString : pwd)
    }
}

extension WalletManageViewController : InputNameViewDelegate {
    func inputNameDelegate(name: String) {
        if identityModel != nil {
            identityModel?.name = name
            Walletverse.updateIdentity(identityModel: identityModel ?? Walletverse.getIdentityModel()) { (result) in
                
            }
        }
    }
}
