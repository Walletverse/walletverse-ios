//
//  ImportWalletViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/8.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import MBProgressHUD
import walletverse_ios_sdk

class ImportWalletViewController: BaseViewController {
    
    var tokenType : String?
    var content : String?
    var walletPin : String?
    var walletName : String?
    var wid : String?
    
    var keyboardHeight:CGFloat = 0.0
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        return scrollView
    }()
    
    lazy var descripteBackV : BaseView = {
        return BaseView()
    }()

    lazy var textView : UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.font = FontSystem(size: 14)
        textView.textAlignment = .left
        textView.textColor = Color_444444
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.returnKeyType = .done
        textView.keyboardType = .default
        textView.autocapitalizationType = UITextAutocapitalizationType.none
        return textView
    }()
    
    var tipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("assets_wallet_mnemonic_private"), font: FontSystem(size: 14), color: Color_717782)
    }()
    
    lazy var nameV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var nameTF : UITextField = {
        let nameTF = CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_333333, delegate: self, placeholder: LocalString("asserts_wallet_name"))
        return nameTF
    }()
    
    lazy var lineOneV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var pwdOneTF : UITextField = {
        let pwdOneTF = CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_333333, delegate: self, placeholder: "PIN")
        return pwdOneTF
    }()
    
    lazy var tipsL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_pin_tip"), font: FontSystem(size: 12), color: Color_717782)
    }()
    
    lazy var lineTwoV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var pwdTwoTF : UITextField = {
        let pwdTwoTF = CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_333333, delegate: self, placeholder: LocalString("asserts_pin_check"))
        
        return pwdTwoTF
    }()
    
    lazy var nextBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("asserts_import"), font: FontSystemBold(size: 15), color: Color_FFFFFF, cornerRadius: 24, backColor: Color_0072DB_1)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBaseNaviLeft()
        baseNaviTitle.text = LocalString("asserts_host_no_import")
        
        registerNotification()
    }
    
    func registerNotification() {
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification , object: nil)
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillChange(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func configUI() {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: baseMainV.width, height: baseMainV.height - ZSCREENBOTTOM)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        scrollView.addGestureRecognizer(tapGesture)
        baseMainV.addSubview(scrollView)
        
        
        descripteBackV.frame = CGRect(x: 15, y: 0, width: ZSCREENWIDTH - 30, height: 150)
        descripteBackV.backgroundColor = Color_F5F6FA
        descripteBackV.clipsToBounds = true
        descripteBackV.layer.cornerRadius = 4
        scrollView.addSubview(descripteBackV)
        
        textView.frame = CGRect(x: 15, y: 15, width: descripteBackV.width - 30, height: descripteBackV.height - 30)
        textView.backgroundColor = UIColor.clear
        descripteBackV.addSubview(textView)
        
        tipL.frame = CGRect(x: 4, y: 5, width: textView.width - 8, height: 20)
        tipL.backgroundColor = UIColor.clear
        textView.addSubview(tipL)
        
        nameV.frame = CGRect.init(x: 15, y: descripteBackV.bottom + 20, width: ZSCREENWIDTH - 30, height: 60)
        nameV.clipsToBounds = true
        nameV.layer.cornerRadius = 4
        scrollView.addSubview(nameV)
        
        nameTF.frame = CGRect(x: 15, y: 0, width: nameV.width - 30, height: 60)
        nameTF.keyboardType = .default
        nameV.addSubview(nameTF)
        
        
        let pwd = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
        if (pwd ?? "").isEmpty {
            tipsL.frame = CGRect.init(x: 16, y: nameV.bottom + 10, width: ZSCREENWIDTH - 32, height: 30)
            tipsL.clipsToBounds = true
            tipsL.layer.cornerRadius = 4
            scrollView.addSubview(tipsL)
            
            lineOneV.frame = CGRect.init(x: 15, y: tipsL.bottom + 10, width: ZSCREENWIDTH - 30, height: 60)
            lineOneV.clipsToBounds = true
            lineOneV.layer.cornerRadius = 4
            scrollView.addSubview(lineOneV)
            
            pwdOneTF.frame = CGRect(x: 15, y: 0, width: lineOneV.width - 30, height: 60)
            pwdOneTF.keyboardType = .numberPad
            pwdOneTF.isSecureTextEntry = true
            lineOneV.addSubview(pwdOneTF)
            
            lineTwoV.frame = CGRect.init(x: 15, y: lineOneV.bottom + 10, width: ZSCREENWIDTH - 30, height: 60)
            lineTwoV.clipsToBounds = true
            lineTwoV.layer.cornerRadius = 4
            scrollView.addSubview(lineTwoV)
            
            pwdTwoTF.frame = CGRect(x: 15, y: 0, width: lineTwoV.width - 30, height: 60)
            pwdTwoTF.keyboardType = .numberPad
            pwdTwoTF.isSecureTextEntry = true
            lineTwoV.addSubview(pwdTwoTF)
            
            nextBtn.frame = CGRect.init(x: 16, y: lineTwoV.bottom + 40, width: ZSCREENWIDTH - 32, height: 48)
            nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
            scrollView.addSubview(nextBtn)
        } else {
            nextBtn.frame = CGRect.init(x: 16, y: nameV.bottom + 40, width: ZSCREENWIDTH - 32, height: 48)
            nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
            scrollView.addSubview(nextBtn)
        }
        
        if nextBtn.bottom + 20 > baseMainV.height - ZSCREENBOTTOM {
            scrollView.contentSize = CGSize(width: scrollView.width,height: nextBtn.bottom + 200)
        } else {
            scrollView.contentSize = CGSize(width: scrollView.width,height: baseMainV.height - ZSCREENBOTTOM)
        }
    }
    
    @objc func tapClick() {
        view.endEditing(true)
    }
    
    @objc func rightBtnClick(button:UIButton) {
        button.isSelected = !button.isSelected
        if (!button.isSelected) {
            pwdOneTF.isSecureTextEntry = true
            pwdTwoTF.isSecureTextEntry = true
        } else {
            pwdOneTF.isSecureTextEntry = false
            pwdTwoTF.isSecureTextEntry = false
        }
    }
    
    func preCompare() -> Bool {
        var pinTrue = false
        let pwd = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
        if (pwd ?? "").isEmpty {
            if isPinRuler(password: pwdOneTF.text ?? "") && isPinRuler(password: pwdTwoTF.text ?? "") {
                if pwdOneTF.text!.isEqual(pwdTwoTF.text!) {
                    pinTrue = true
                } else {
                    CommonToastView.showToastAction(message: LocalString("asserts_pin_match"))
                    pinTrue = false
                }
            } else {
                CommonToastView.showToastAction(message: LocalString("asserts_pin_tip"))
                pinTrue = false
            }
        } else {
            pinTrue = true
        }
        var textTrue = false
        if textView.text.trimmingCharacters( in : .whitespaces).count > 0 {
            textTrue = true
        } else {
            CommonToastView.showToastAction(message: LocalString("assets_wallet_import_private"))
            textTrue = false
        }
        
        var nameTrue = false
        if textView.text.trimmingCharacters( in : .whitespaces).count > 0 {
            nameTrue = true
        } else {
            CommonToastView.showToastAction(message: LocalString("asserts_wallet_name_tip1"))
            nameTrue = false
        }
        
        return pinTrue && textTrue && nameTrue
    }
    
    @objc func nextBtnClick() {
        tapClick()
        let isEnable = preCompare()
        if isEnable {
            content = textView.text.trimmingCharacters( in : .whitespaces)
            walletName = nameTF.text?.trimmingCharacters( in : .whitespaces) ?? ""
            let pwd = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
            if (pwd ?? "").isEmpty {
                walletPin = pwdOneTF.text?.trimmingCharacters( in : .whitespaces) ?? ""
            } else {
                walletPin = pwd
            }
            var privateKey = ""
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            if content?.split(separator: " ").count ?? 0 > 10 {
                tokenType = "mnemonic"
                let privateParams = JSCoreParams()
                    .put(key: "chainId", value: "0x1")?
                    .put(key: "mnemonic", value: content ?? "") ?? JSCoreParams()
                Walletverse.getPrivateKey(params: privateParams) { (returnData, error) in
                    let privateKey = returnData as? String
                    if !(privateKey?.isEmpty ?? true) {
                        let addressParams = JSCoreParams()
                            .put(key: "chainId", value: "0x1")?
                            .put(key: "mnemonic", value: privateKey ?? "") ?? JSCoreParams()
                        Walletverse.getAddress(params: addressParams) { (returnData, error) in
                            if let address = returnData {
                                let tokenParams = JSCoreParams()
                                    .put(key: "message", value: self.content ?? "")?
                                    .put(key: "password", value: self.walletPin ?? "") ?? JSCoreParams()
                                Walletverse.encodeMessage(params: tokenParams) { (returnData, error) in
                                    if let token = returnData {
                                        MBProgressHUD.hide(for: self.view, animated: false)
                                        
                                        Walletverse.generateWid(appId: Constant_Appid) { (returnData) in
                                            if let wid = returnData {
                                                self.wid = wid
                                                
                                                let identity = Walletverse.getIdentityModel()
                                                identity.wid = self.wid
                                                identity.name = self.walletName
                                                identity.tokenType = self.tokenType
                                                identity.token = token as? String
                                                
                                                let initChain = InitChainParams(wid: wid, address: address as? String, privateKey: privateKey as? String, walletPin: self.walletPin, chainId: "0x1", contract: "ETH", symbol: "ETH")
                                                Walletverse.initChain(params: initChain) { (returnData) in
                                                    if let coin = returnData {
                                                        Walletverse.insertIdentity(identityModel: identity) { (result) in
                                                            let walletCoin = Walletverse.getWalletCoinModel()
                                                            walletCoin.updateFromCoin(coin: coin)
                                                            let saveCoinParams = SaveCoinParams(wid: wid, pin: self.walletPin, walletCoinModel: walletCoin)
                                                            Walletverse.saveWalletCoin(saveCoinParams: saveCoinParams) { (result) in
                                                                UserDefaultUtil.setValue(value: self.walletPin ?? "", key: ZUSERDEFAULT_WALLETPASSWORD)
                                                                UserDefaultUtil.setValue(value: self.wid ?? "", key: ZUSERDEFAULT_CURRENTWALLET)
                                                                
                                                                ZAPPDELEGATE?.applicationSetMainViewController()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        MBProgressHUD.hide(for: self.view, animated: false)
                                        CommonToastView.showToastAction(message: "Please import the correct mnemonic or private key")
                                    }
                                }
                            } else {
                                MBProgressHUD.hide(for: self.view, animated: false)
                                CommonToastView.showToastAction(message: "Please import the correct mnemonic or private key")
                            }
                        }
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: false)
                        CommonToastView.showToastAction(message: "Please import the correct mnemonic or private key")
                        return
                    }
                }
            } else {
                tokenType = "private"
                privateKey = content ?? ""
                
                let addressParams = JSCoreParams()
                    .put(key: "chainId", value: "0x1")?
                    .put(key: "mnemonic", value: privateKey) ?? JSCoreParams()
                Walletverse.getAddress(params: addressParams) { (returnData, error) in
                    let address = returnData as? String
                    if !(address?.isEmpty ?? true) {
                        let tokenParams = JSCoreParams()
                            .put(key: "message", value: self.content ?? "")?
                            .put(key: "password", value: self.walletPin ?? "") ?? JSCoreParams()
                        Walletverse.encodeMessage(params: tokenParams) { (returnData, error) in
                            if let token = returnData {
                                Walletverse.generateWid(appId: Constant_Appid) { (returnData) in
                                    MBProgressHUD.hide(for: self.view, animated: false)
                                    if let wid = returnData {
                                        self.wid = wid
                                        
                                        let identity = Walletverse.getIdentityModel()
                                        identity.wid = self.wid
                                        identity.name = self.walletName
                                        identity.tokenType = self.tokenType
                                        identity.token = token as? String
                                        
                                        let initChain = InitChainParams(wid: wid, address: address as? String, privateKey: privateKey, walletPin: self.walletPin, chainId: "0x1", contract: "ETH", symbol: "ETH")
                                        Walletverse.initChain(params: initChain) { (returnData) in
                                            if let coin = returnData {
                                                Walletverse.insertIdentity(identityModel: identity) { (result) in
                                                    
                                                    
                                                    let walletCoin = Walletverse.getWalletCoinModel()
                                                    walletCoin.updateFromCoin(coin: coin)
                                                    let saveCoinParams = SaveCoinParams(wid: wid, pin: self.walletPin, walletCoinModel: walletCoin)
                                                    Walletverse.saveWalletCoin(saveCoinParams: saveCoinParams) { (result) in
                                                        UserDefaultUtil.setValue(value: self.walletPin ?? "", key: ZUSERDEFAULT_WALLETPASSWORD)
                                                        UserDefaultUtil.setValue(value: self.wid ?? "", key: ZUSERDEFAULT_CURRENTWALLET)
                                                        
                                                        ZAPPDELEGATE?.applicationSetMainViewController()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                MBProgressHUD.hide(for: self.view, animated: false)
                                CommonToastView.showToastAction(message: "Please import the correct mnemonic or private key")
                            }
                        }
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: false)
                        CommonToastView.showToastAction(message: "Please import the correct mnemonic or private key")
                    }
                }
            }
        }
    }
    
    func isPinRuler(password:String) -> Bool {
        return PredicateUtil.vertifyPassword(password)
    }

    @objc func keyBoardWillShow(_ notification : Notification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else{return}
        var duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        if duration == nil { duration = 0.25 }
        let keyboardTopYPosition = keyboardRect.height
        keyboardHeight = keyboardTopYPosition

        scrollView.size = CGSize(width: baseMainV.width, height: self.baseMainV.height - self.keyboardHeight - ZSCREENBOTTOM)
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.size = CGSize(width: self.baseMainV.width, height: self.baseMainV.height - self.keyboardHeight - ZSCREENBOTTOM)
        })
    }
    
    @objc func keyBoardWillHide(_ notification : Notification) {
        self.scrollView.size = CGSize(width: self.baseMainV.width, height: self.baseMainV.height - ZSCREENBOTTOM)
    }
    
    @objc func keyBoardWillChange(_ notification : Notification) {}
    
    deinit {
        ZNOTIFICATION.removeObserver(self)
    }
}

extension ImportWalletViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        tipL.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count > 0 {
            tipL.isHidden = true
        } else {
            tipL.isHidden = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {

    }
    
    func textViewShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}

extension ImportWalletViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == pwdOneTF {
            pwdOneTF.textColor = Color_333333
        } else if textField == pwdTwoTF {
            pwdTwoTF.textColor = Color_333333
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == pwdOneTF {
            if isPinRuler(password: textField.text ?? "") {
                pwdOneTF.textColor = Color_333333
            } else {
                pwdOneTF.textColor = Color_0072DB
            }
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == pwdTwoTF {
            if isPinRuler(password: textField.text ?? "") {
                pwdTwoTF.textColor = Color_333333
            } else {
                pwdTwoTF.textColor = Color_0072DB
            }
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == pwdOneTF {
            if isPinRuler(password: textField.text ?? "") {
                pwdOneTF.textColor = Color_333333
            } else {
                pwdOneTF.textColor = Color_0072DB
            }
            
        } else if textField == pwdTwoTF {
            if isPinRuler(password: textField.text ?? "") {
                pwdTwoTF.textColor = Color_333333
            } else {
                pwdTwoTF.textColor = Color_0072DB
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
