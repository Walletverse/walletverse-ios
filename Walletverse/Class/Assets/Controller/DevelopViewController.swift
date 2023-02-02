//
//  DevelopViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit
import MBProgressHUD
import walletverse_ios_sdk

class DevelopViewController : BaseViewController {
    
    lazy var textView : UITextView = {
        let textView = UITextView()
        textView.font = FontSystem(size: 14)
        textView.textAlignment = .left
        textView.textColor = Color_FFFFFF
        textView.backgroundColor = UIColor.gray
        textView.text = "Result..."
        textView.isEditable = true
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = true
        textView.returnKeyType = .done
        textView.keyboardType = .default
        textView.autocapitalizationType = UITextAutocapitalizationType.none
        return textView
    }()
    
    lazy var mnemonicBtn : UIButton = {
        return CustomView.buttonCustom(text: "Mnemonic", font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 22, backColor: UIColor.blue)
    }()
    
    lazy var balanceBtn : UIButton = {
        return CustomView.buttonCustom(text: "Balance", font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 22, backColor: UIColor.blue)
    }()
    
    lazy var nonceBtn : UIButton = {
        return CustomView.buttonCustom(text: "Nonce", font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 22, backColor: UIColor.blue)
    }()
    
    lazy var decimalsBtn : UIButton = {
        return CustomView.buttonCustom(text: "Decimals", font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 22, backColor: UIColor.blue)
    }()
    
    lazy var encodeAuthBtn : UIButton = {
        return CustomView.buttonCustom(text: "EncodeAuth", font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 22, backColor: UIColor.blue)
    }()
    
    lazy var encodeMessageBtn : UIButton = {
        return CustomView.buttonCustom(text: "EncodeMessage", font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 22, backColor: UIColor.blue)
    }()
    
    lazy var testnetBtn : UIButton = {
        return CustomView.buttonCustom(text: "Testnet", font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 22, backColor: UIColor.blue)
    }()
    
    lazy var errorBtn : UIButton = {
        return CustomView.buttonCustom(text: "Error", font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 22, backColor: UIColor.blue)
    }()
    
    lazy var sdkVersionBtn : UIButton = {
        return CustomView.buttonCustom(text: "SDK Version", font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 22, backColor: UIColor.blue)
    }()
    
    
    override func viewDidLoad() {
        isShowNaviBar = false
        super.viewDidLoad()
    }
    
    override func configUI() {
        textView.frame = CGRect(x: 20, y: 40, width: baseMainV.width - 40, height: 120)
        baseMainV.addSubview(textView)
        
        mnemonicBtn.frame = CGRect(x: 20, y: 200, width: baseMainV.width - 40, height: 44)
        mnemonicBtn.addTarget(self, action: #selector(mnemonicBtnClick), for: .touchUpInside)
        baseMainV.addSubview(mnemonicBtn)
        
        balanceBtn.frame = CGRect(x: 20, y: mnemonicBtn.bottom + 10, width: baseMainV.width - 40, height: 44)
        balanceBtn.addTarget(self, action: #selector(balanceBtnClick), for: .touchUpInside)
        baseMainV.addSubview(balanceBtn)
        
        nonceBtn.frame = CGRect(x: 20, y: balanceBtn.bottom + 10, width: baseMainV.width - 40, height: 44)
        nonceBtn.addTarget(self, action: #selector(nonceBtnClick), for: .touchUpInside)
        baseMainV.addSubview(nonceBtn)
        
        decimalsBtn.frame = CGRect(x: 20, y: nonceBtn.bottom + 10, width: baseMainV.width - 40, height: 44)
        decimalsBtn.addTarget(self, action: #selector(decimalsBtnClick), for: .touchUpInside)
        baseMainV.addSubview(decimalsBtn)
        
        encodeAuthBtn.frame = CGRect(x: 20, y: decimalsBtn.bottom + 10, width: baseMainV.width - 40, height: 44)
        encodeAuthBtn.addTarget(self, action: #selector(encodeAuthBtnClick), for: .touchUpInside)
        baseMainV.addSubview(encodeAuthBtn)
        
        encodeMessageBtn.frame = CGRect(x: 20, y: encodeAuthBtn.bottom + 10, width: baseMainV.width - 40, height: 44)
        encodeMessageBtn.addTarget(self, action: #selector(encodeMessageBtnClick), for: .touchUpInside)
        baseMainV.addSubview(encodeMessageBtn)
        
        testnetBtn.frame = CGRect(x: 20, y: encodeMessageBtn.bottom + 10, width: baseMainV.width - 40, height: 44)
        testnetBtn.addTarget(self, action: #selector(testnetBtnClick), for: .touchUpInside)
        baseMainV.addSubview(testnetBtn)
        
        errorBtn.frame = CGRect(x: 20, y: testnetBtn.bottom + 10, width: baseMainV.width - 40, height: 44)
        errorBtn.addTarget(self, action: #selector(errorBtnClick), for: .touchUpInside)
        baseMainV.addSubview(errorBtn)
        
        sdkVersionBtn.frame = CGRect(x: 20, y: errorBtn.bottom + 10, width: baseMainV.width - 40, height: 44)
        sdkVersionBtn.addTarget(self, action: #selector(sdkVersionBtnClick), for: .touchUpInside)
        baseMainV.addSubview(sdkVersionBtn)
        
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func mnemonicBtnClick() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let jsParams = JSCoreParams()
            .put(key: "chainId", value: "0x38") ?? JSCoreParams()
        Walletverse.generateMnemonic(params: jsParams) { (returnData, error) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if let result = returnData {
                self.textView.text = result as? String
            } else {
                self.textView.text = error?.localizedDescription
            }
        }
    }
    
    @objc func balanceBtnClick() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
//        let jsParams = JSCoreParams()
//            .put(key: "chainId", value: "0x38")?
//            .put(key: "address", value: "0xAeA144E143D90f8B8ebF5153e73813f2FCf3321E")?
//            .put(key: "contractAddress", value: "") ?? JSCoreParams()
        let coinBalance = CoinBalance(chainId: "0x38", address: "0xAeA144E143D90f8B8ebF5153e73813f2FCf3321E", contractAddress: "")
        Walletverse.balance(params: coinBalance) { (returnData) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if let result = returnData {
                self.textView.text = result as? String
            } else {
                self.textView.text = ""
            }
        }
    }
    
    @objc func nonceBtnClick() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
//        let jsParams = JSCoreParams()
//            .put(key: "chainId", value: "0x38")?
//            .put(key: "address", value: "0xAeA144E143D90f8B8ebF5153e73813f2FCf3321E")?
//            .put(key: "contractAddress", value: "0x55d398326f99059ff775485246999027b3197955") ?? JSCoreParams()
        
        let chainNonce = ChainNonce(chainId: "0x38", address: "0xAeA144E143D90f8B8ebF5153e73813f2FCf3321E")
        Walletverse.nonce(params: chainNonce) { (returnData) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if let result = returnData {
                self.textView.text = "\(result)"
            } else {
                self.textView.text = ""
            }
        }
    }
    
    @objc func decimalsBtnClick() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
//        let jsParams = JSCoreParams()
//            .put(key: "chainId", value: "0x38")?
//            .put(key: "address", value: "0xAeA144E143D90f8B8ebF5153e73813f2FCf3321E")?
//            .put(key: "contractAddress", value: "0x55d398326f99059ff775485246999027b3197955") ?? JSCoreParams()
        
        let coinDecimals = CoinDecimals(chainId: "0x38",contractAddress: "0x55d398326f99059ff775485246999027b3197955")
        Walletverse.decimals(params: coinDecimals) { (returnData) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if let result = returnData {
                self.textView.text = "\(result)"
            } else {
                self.textView.text = ""
            }
        }
    }
    
    @objc func encodeAuthBtnClick() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let jsParams = JSCoreParams().put(key: "message", value: "testpassword")?.put(key: "uuid", value: Constant_UUID) ?? JSCoreParams()
        Walletverse.encodeAuth(params: jsParams) { (returnData, error) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if let result = returnData {
                self.textView.text = result as? String
            } else {
                self.textView.text = error?.localizedDescription
            }
        }
    }
    
    @objc func encodeMessageBtnClick() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let jsParams = JSCoreParams().put(key: "message", value: "testpassword")?.put(key: "password", value: "testauth") ?? JSCoreParams()
        Walletverse.encodeMessage(params: jsParams) { (returnData, error) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if let result = returnData {
                self.textView.text = result as? String
            } else {
                self.textView.text = error?.localizedDescription
            }
        }
    }
    
    @objc func testnetBtnClick() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let getChainsParams = GetChainsParams(vm: "EVM")
        Walletverse.getSupportChains(params: getChainsParams) { (returnData) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if let result = returnData {
                self.textView.text = "\(result)"
            } else {
            }
        }
    }
    
    @objc func errorBtnClick() {
        
    }
    
    @objc func sdkVersionBtnClick() {
        
        let version = Walletverse.getSDKVersionCode()
        let name = Walletverse.getSDKVersionName()
        textView.text = String(version) + "--" + String(name)
    }
}
