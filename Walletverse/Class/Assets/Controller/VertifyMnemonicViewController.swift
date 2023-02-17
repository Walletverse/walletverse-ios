//
//  VertifyMnemonicViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/8.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import MBProgressHUD
import walletverse_ios_sdk

class VertifyMnemonicViewController: BaseViewController {
    var name: String?
    var pwdString: String?
    var mnemonicString : String?
    var mnemonicArray : NSArray?
    
    var token: String?
    var wid: String?
    
    lazy var tipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("assets_vertify_mnemonic_tip"), font: FontSystem(size: 14), color: Color_999999)
    }()
    
    lazy var errorL : UILabel = {
        return CustomView.labelCustom(text: LocalString("assets_vertify_mnemonic_error"), font: FontSystem(size: 12), color: ColorHex(0xEC374D),textAlignment:.center)
    }()
    
    lazy var vertifyMnemonicView : VertifyMnemonicView = {
        let vertifyMnemonicView = VertifyMnemonicView.init(frame: CGRect(x: 16, y: tipL.bottom + 10, width: ZSCREENWIDTH - 32, height: 200))
        vertifyMnemonicView.clipsToBounds = true
        vertifyMnemonicView.layer.cornerRadius = 4
        vertifyMnemonicView.configSubviewUI()
        return vertifyMnemonicView
    }()
    
    lazy var orginalMnemonicView : OrginalMnemonicView = {
        let orginalMnemonicView = OrginalMnemonicView.init(frame: CGRect(x: 16, y: vertifyMnemonicView.bottom + 25, width: ZSCREENWIDTH - 32, height: 200))
        orginalMnemonicView.clipsToBounds = true
        orginalMnemonicView.layer.cornerRadius = 4
        orginalMnemonicView.configSubviewUI()
        orginalMnemonicView.delegate = self
        return orginalMnemonicView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initBaseNaviLeft()
        baseNaviTitle.text = LocalString("assets_vertify_mnemonic")
        
        let tokenParams = JSCoreParams()
            .put(key: "message", value: mnemonicString ?? "")?
            .put(key: "password", value: pwdString ?? "") ?? JSCoreParams()
        Walletverse.encodeMessage(params: tokenParams) { (returnData, error) in
            if let token = returnData {
                self.token = token as? String
            }
        }
        
        Walletverse.generateWid(appId: Constant_Appid) { (returnData) in
            if let wid = returnData {
                self.wid = wid
            }
        }
    }
    
    override func configUI() {
        tipL.numberOfLines = 0
        let tipLHeight = tipL.text?.getLableHeigh(font: tipL.font, width: ZSCREENWIDTH - 32)
        tipL.frame = CGRect(x: 16, y: 12, width: ZSCREENWIDTH - 32, height: tipLHeight ?? 0)
        baseMainV.addSubview(tipL)
    
        baseMainV.addSubview(vertifyMnemonicView)
        errorL.frame = CGRect(x: 16, y: vertifyMnemonicView.bottom + 15, width: vertifyMnemonicView.width, height: 18)
        errorL.isHidden = true
        baseMainV.addSubview(errorL)
        baseMainV.addSubview(orginalMnemonicView)
    
        vertifyMnemonicView.setMnemonicArray(mnemonicArray: mnemonicArray)
        orginalMnemonicView.setMnemonicArray(mnemonicArray: mnemonicArray)
    }
    
    func showVertifyFinish() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let privateParams = JSCoreParams()
            .put(key: "chainId", value: "0x1")?
            .put(key: "mnemonic", value: mnemonicString ?? "") ?? JSCoreParams()
        Walletverse.getPrivateKey(params: privateParams) { (returnData, error) in
            if let privateKey = returnData {
                let addressParams = JSCoreParams()
                    .put(key: "chainId", value: "0x1")?
                    .put(key: "privateKey", value: privateKey) ?? JSCoreParams()
                Walletverse.getAddress(params: addressParams) { (returnData, error) in
                    
                    if let address = returnData {
                        let identity = Walletverse.getIdentityModel()
                        identity.wid = self.wid
                        identity.name = self.name
                        identity.tokenType = "mnemonic"
                        identity.token = self.token
                        
                        let initChain = InitChainParams(wid: self.wid, address: address as? String, privateKey: privateKey as? String, walletPin: self.pwdString, chainId: "0x1", contract: "ETH", symbol: "ETH")
                        Walletverse.initChain(params: initChain) { (returnData) in
                            if let coin = returnData {
                                Walletverse.insertIdentity(identityModel: identity) { (result) in
                                    let walletCoin = Walletverse.getWalletCoinModel()
                                    walletCoin.updateFromCoin(coin: coin)
                                    let saveCoinParams = SaveCoinParams(wid: self.wid, pin: self.pwdString, walletCoinModel: walletCoin)
                                    Walletverse.saveWalletCoin(saveCoinParams: saveCoinParams) { (result) in
                                        MBProgressHUD.hide(for: self.view, animated: false)
                                        
                                        UserDefaultUtil.setValue(value: self.pwdString ?? "", key: ZUSERDEFAULT_WALLETPASSWORD)
                                        UserDefaultUtil.setValue(value: self.wid ?? "", key: ZUSERDEFAULT_CURRENTWALLET)
                                        
                                        ZAPPDELEGATE?.applicationSetMainViewController()
                                    }
                                }
                            } else {
                                MBProgressHUD.hide(for: self.view, animated: false)
                            }
                        }
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: false)
                    }
                    
                }
            } else {
                MBProgressHUD.hide(for: self.view, animated: false)
            }
        }
    }

}

extension VertifyMnemonicViewController : OrginalMnemonicViewDelegate {
    func didDeselectItemError(indexPath: IndexPath) {
        errorL.isHidden = false
        orginalMnemonicView.frame = CGRect(x: 16, y: vertifyMnemonicView.bottom + 57, width: ZSCREENWIDTH - 32, height: 200)
    }
    func didDeselectItemFinish(indexPath: IndexPath,currentIndex: Int) {
        errorL.isHidden = true
        orginalMnemonicView.frame = CGRect(x: 16, y: vertifyMnemonicView.bottom + 25, width: ZSCREENWIDTH - 32, height: 200)
        vertifyMnemonicView.setItemCount(count: currentIndex)
        if currentIndex == mnemonicArray?.count {
            showVertifyFinish()
        }
    }
}
