//
//  Web2CreateViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/10.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import MBProgressHUD
import walletverse_ios_sdk

class Web2CreateViewController: BaseViewController {
    
    var userType: String?
    var mnemonic: String?
    var federatedParams: FederatedParams?
    var federated: UserprofileModel?
    
    var keyboardHeight:CGFloat = 0.0
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        return scrollView
    }()
    
    
    lazy var nameV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var nameTF : UITextField = {
        let nameTF = CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_333333, delegate: self, placeholder: LocalString("asserts_wallet_name"))
        return nameTF
    }()
    
    lazy var tipPasswordL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_wallet_password"), font: FontSystem(size: 12), color: Color_717782)
    }()
    
    lazy var tipPwdOneL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_wallet_password_tip1"), font: FontSystem(size: 12), color: Color_717782)
    }()
    
    lazy var tipPwdTwoL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_wallet_password_tip2"), font: FontSystem(size: 12), color: Color_717782)
    }()
    
    lazy var pwdOneV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var pwdOneTF : UITextField = {
        let pwdOneTF = CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_333333, delegate: self, placeholder: LocalString("asserts_wallet_password"))
        return pwdOneTF
    }()
    
    lazy var pwdTwoV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var pwdTwoTF : UITextField = {
        let pwdTwoTF = CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_333333, delegate: self, placeholder: LocalString("asserts_wallet_check"))
        return pwdTwoTF
    }()
    
    lazy var tipPinL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_pin_tip"), font: FontSystem(size: 12), color: Color_717782)
    }()
    
    lazy var pinOneV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var pinOneTF : UITextField = {
        let pinOneTF = CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_333333, delegate: self, placeholder: "PIN")
        return pinOneTF
    }()
    
    lazy var pinTwoV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var pinTwoTF : UITextField = {
        let pinTwoTF = CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_333333, delegate: self, placeholder: LocalString("asserts_pin_check"))
        return pinTwoTF
    }()
    
    lazy var createBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("asserts_wallet_create"), font: FontSystemBold(size: 15), color: Color_FFFFFF, cornerRadius: 4, backColor: Color_0072DB_1)
    }()
    
    var commonLoadView : CommonLoadView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBaseNaviLeft()
        if userType == "new" {
            baseNaviTitle.text = LocalString("asserts_host_no_create")
        } else {
            baseNaviTitle.text = LocalString("asserts_host_restore")
        }
        
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
        
        
        nameV.frame = CGRect.init(x: 15, y: 0, width: ZSCREENWIDTH - 30, height: 60)
        nameV.clipsToBounds = true
        nameV.layer.cornerRadius = 4
        scrollView.addSubview(nameV)
        
        nameTF.frame = CGRect(x: 15, y: 0, width: nameV.width - 30, height: 60)
        nameV.addSubview(nameTF)
        
        tipPasswordL.frame = CGRect.init(x: 16, y: nameTF.bottom + 20, width: ZSCREENWIDTH - 32, height: 30)
        scrollView.addSubview(tipPasswordL)
        
        tipPwdOneL.frame = CGRect.init(x: 16, y: tipPasswordL.bottom + 5, width: ZSCREENWIDTH - 32, height: 20)
        scrollView.addSubview(tipPwdOneL)
        
        tipPwdTwoL.frame = CGRect.init(x: 16, y: tipPwdOneL.bottom + 5, width: ZSCREENWIDTH - 32, height: 20)
        scrollView.addSubview(tipPwdTwoL)
        
        pwdOneV.frame = CGRect.init(x: 15, y: tipPwdTwoL.bottom + 10, width: ZSCREENWIDTH - 30, height: 60)
        pwdOneV.clipsToBounds = true
        pwdOneV.layer.cornerRadius = 4
        scrollView.addSubview(pwdOneV)
        
        pwdOneTF.frame = CGRect(x: 15, y: 0, width: pwdOneV.width - 30, height: 60)
        pwdOneTF.isSecureTextEntry = true
        pwdOneV.addSubview(pwdOneTF)
        
        if userType == "new" {
            pwdTwoV.frame = CGRect.init(x: 15, y: pwdOneV.bottom + 10, width: ZSCREENWIDTH - 30, height: 60)
            pwdTwoV.clipsToBounds = true
            pwdTwoV.layer.cornerRadius = 4
            scrollView.addSubview(pwdTwoV)
            
            pwdTwoTF.frame = CGRect(x: 15, y: 0, width: pwdTwoV.width - 30, height: 60)
            pwdTwoTF.isSecureTextEntry = true
            pwdTwoV.addSubview(pwdTwoTF)
            
            let pwd = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
            if (pwd ?? "").isEmpty {
                tipPinL.frame = CGRect.init(x: 16, y: pwdTwoV.bottom + 20, width: ZSCREENWIDTH - 32, height: 30)
                scrollView.addSubview(tipPinL)
                
                pinOneV.frame = CGRect.init(x: 15, y: tipPinL.bottom + 10, width: ZSCREENWIDTH - 30, height: 60)
                pinOneV.clipsToBounds = true
                pinOneV.layer.cornerRadius = 4
                scrollView.addSubview(pinOneV)
                
                pinOneTF.frame = CGRect(x: 15, y: 0, width: pinOneV.width - 30, height: 60)
                pinOneTF.keyboardType = .numberPad
                pinOneTF.isSecureTextEntry = true
                pinOneV.addSubview(pinOneTF)
                
                pinTwoV.frame = CGRect.init(x: 15, y: pinOneV.bottom + 10, width: ZSCREENWIDTH - 30, height: 60)
                pinTwoV.clipsToBounds = true
                pinTwoV.layer.cornerRadius = 4
                scrollView.addSubview(pinTwoV)
                
                pinTwoTF.frame = CGRect(x: 15, y: 0, width: pinTwoV.width - 30, height: 60)
                pinTwoTF.keyboardType = .numberPad
                pinTwoTF.isSecureTextEntry = true
                pinTwoV.addSubview(pinTwoTF)
                
                createBtn.frame = CGRect.init(x: 16, y: pinTwoV.bottom + 40, width: ZSCREENWIDTH - 32, height: 48)
                createBtn.addTarget(self, action: #selector(createBtnClick), for: .touchUpInside)
                scrollView.addSubview(createBtn)
            } else {
                createBtn.frame = CGRect.init(x: 16, y: pwdTwoV.bottom + 40, width: ZSCREENWIDTH - 32, height: 48)
                createBtn.addTarget(self, action: #selector(createBtnClick), for: .touchUpInside)
                scrollView.addSubview(createBtn)
            }
        } else {
            let pwd = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
            if (pwd ?? "").isEmpty {
                tipPinL.frame = CGRect.init(x: 16, y: pwdOneV.bottom + 20, width: ZSCREENWIDTH - 32, height: 30)
                scrollView.addSubview(tipPinL)
                
                pinOneV.frame = CGRect.init(x: 15, y: tipPinL.bottom + 10, width: ZSCREENWIDTH - 30, height: 60)
                pinOneV.clipsToBounds = true
                pinOneV.layer.cornerRadius = 4
                scrollView.addSubview(pinOneV)
                
                pinOneTF.frame = CGRect(x: 15, y: 0, width: pinOneV.width - 30, height: 60)
                pinOneTF.keyboardType = .numberPad
                pinOneTF.isSecureTextEntry = true
                pinOneV.addSubview(pinOneTF)
                
                pinTwoV.frame = CGRect.init(x: 15, y: pinOneV.bottom + 10, width: ZSCREENWIDTH - 30, height: 60)
                pinTwoV.clipsToBounds = true
                pinTwoV.layer.cornerRadius = 4
                scrollView.addSubview(pinTwoV)
                
                pinTwoTF.frame = CGRect(x: 15, y: 0, width: pinTwoV.width - 30, height: 60)
                pinTwoTF.keyboardType = .numberPad
                pinTwoTF.isSecureTextEntry = true
                pinTwoV.addSubview(pinTwoTF)
                
                createBtn.frame = CGRect.init(x: 16, y: pinTwoV.bottom + 40, width: ZSCREENWIDTH - 32, height: 48)
                createBtn.addTarget(self, action: #selector(createBtnClick), for: .touchUpInside)
                scrollView.addSubview(createBtn)
            } else {
                createBtn.frame = CGRect.init(x: 16, y: pwdOneV.bottom + 40, width: ZSCREENWIDTH - 32, height: 48)
                createBtn.addTarget(self, action: #selector(createBtnClick), for: .touchUpInside)
                scrollView.addSubview(createBtn)
            }
        }
        
        if createBtn.bottom + 20 > baseMainV.height - ZSCREENBOTTOM {
            scrollView.contentSize = CGSize(width: scrollView.width,height: createBtn.bottom + 200)
        } else {
            scrollView.contentSize = CGSize(width: scrollView.width,height: baseMainV.height - ZSCREENBOTTOM)
        }
        
    }
    
    @objc func tapClick() {
        view.endEditing(true)
    }
    
    func preCompare() -> Bool {
        if (nameTF.text?.trimmingCharacters( in : .whitespaces) ?? "").isEmpty {
            CommonToastView.showToastAction(message: LocalString("asserts_wallet_name_tip1"))
            return false
        }
        
        var pwdTrue = false
        if userType == "new" {
            if pwdOneTF.text?.count ?? 0 >= 8 &&  Walletverse.validatePassword(password: pwdOneTF.text ?? "") && Walletverse.validatePassword(password: pwdTwoTF.text ?? "") {
                if pwdOneTF.text!.isEqual(pwdTwoTF.text!) {
                    pwdTrue = true
                } else {
                    CommonToastView.showToastAction(message: LocalString("asserts_wallet_name_match"))
                    pwdTrue = false
                }
            } else {
                CommonToastView.showToastAction(message: LocalString("asserts_wallet_name_tip2"))
                pwdTrue = false
            }
        } else {
            if pwdOneTF.text?.count ?? 0 >= 8 &&  Walletverse.validatePassword(password: pwdOneTF.text ?? "") {
                pwdTrue = true
            } else {
                CommonToastView.showToastAction(message: LocalString("asserts_wallet_name_tip2"))
                pwdTrue = false
            }
        }
        
        var pinTrue = false
        let pwd = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
        if (pwd ?? "").isEmpty {
            if isPinRuler(password: pinOneTF.text ?? "") && isPinRuler(password: pinTwoTF.text ?? "") {
                if pinOneTF.text!.isEqual(pinTwoTF.text!) {
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

        if pwdTrue && pinTrue {
            return true
        } else {
            return false
        }
    }
    
    @objc func createBtnClick() {
        tapClick()
        let isEnable = preCompare()
        if isEnable {
            print("isEnable true")
            let pwd = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
            var pinS = ""
            if (pwd ?? "").isEmpty {
                pinS = pinOneTF.text?.trimmingCharacters( in : .whitespaces) ?? ""
            } else {
                pinS = pwd!
            }
            commonLoadView = CommonLoadView()
            commonLoadView?.show()
            if userType == "new" {
                
                let createWeb2Params = CreateWeb2Params(mnemonic: self.mnemonic, wallets: self.federated?.wallets, walletName: nameTF.text?.trimmingCharacters( in : .whitespaces) ?? "", walletPin: pinS, password: pwdOneTF.text?.trimmingCharacters( in : .whitespaces) ?? "", federatedParams: federatedParams)
                Walletverse.createWeb2Wallet(params: createWeb2Params) { (result) in
                    self.commonLoadView?.dismiss()
                    
                    if result {
                        UserDefaultUtil.setValue(value: pinS, key: ZUSERDEFAULT_WALLETPASSWORD)
                        UserDefaultUtil.setValue(value: Walletverse.generateWidWithWeb2(params: self.federatedParams ?? FederatedParams()), key: ZUSERDEFAULT_CURRENTWALLET)
                        
                        ZAPPDELEGATE?.applicationSetMainViewController()
                    } else {
                        CommonToastView.showToastAction(message: LocalString("asserts_wallet_create_failed"))
                    }
                }
            } else {
                
                let restoreWeb2Params = RestoreWeb2Params(shards: self.federated?.shards, wallets: self.federated?.wallets, walletName: nameTF.text?.trimmingCharacters( in : .whitespaces) ?? "", walletPin: pinS, password: pwdOneTF.text?.trimmingCharacters( in : .whitespaces) ?? "", federatedParams: federatedParams)
                Walletverse.restoreWeb2Wallet(params: restoreWeb2Params) { (result) in
                    self.commonLoadView?.dismiss()
                    
                    if result {
                        UserDefaultUtil.setValue(value: pinS, key: ZUSERDEFAULT_WALLETPASSWORD)
                        UserDefaultUtil.setValue(value: Walletverse.generateWidWithWeb2(params: self.federatedParams ?? FederatedParams()), key: ZUSERDEFAULT_CURRENTWALLET)
                        
                        ZAPPDELEGATE?.applicationSetMainViewController()
                    } else {
                        CommonToastView.showToastAction(message: LocalString("asserts_wallet_import_failed"))
                    }
                }
            }
        } else {
            print("isEnable false")
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

extension Web2CreateViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == pwdOneTF {
            pwdOneTF.textColor = Color_333333
        } else if textField == pwdTwoTF {
            pwdTwoTF.textColor = Color_333333
        } else if textField == pinOneTF {
            pinOneTF.textColor = Color_333333
        } else if textField == pinTwoTF {
            pinTwoTF.textColor = Color_333333
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == pwdOneTF {
            if string.isEmpty {
                if Walletverse.validatePassword(password: textField.text ?? "") {
                    pwdOneTF.textColor = Color_333333
                } else {
                    pwdOneTF.textColor = Color_0072DB
                }
            } else {
                if Constant_Chars.contains(find: string) {
                    if Walletverse.validatePassword(password: textField.text ?? "") {
                        pwdOneTF.textColor = Color_333333
                    } else {
                        pwdOneTF.textColor = Color_0072DB
                    }
                } else {
                    return false
                }
            }
        } else if textField == pwdTwoTF {
            if string.isEmpty {
                if Walletverse.validatePassword(password: textField.text ?? "") {
                    pwdTwoTF.textColor = Color_333333
                } else {
                    pwdTwoTF.textColor = Color_0072DB
                }
            } else {
                if Constant_Chars.contains(find: string) {
                    if Walletverse.validatePassword(password: textField.text ?? "") {
                        pwdTwoTF.textColor = Color_333333
                    } else {
                        pwdTwoTF.textColor = Color_0072DB
                    }
                } else {
                    return false
                }
            }
        } else if textField == pinOneTF {
            if isPinRuler(password: textField.text ?? "") {
                pinOneTF.textColor = Color_333333
            } else {
                pinOneTF.textColor = Color_0072DB
            }
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == pinTwoTF {
            if isPinRuler(password: textField.text ?? "") {
                pinTwoTF.textColor = Color_333333
            } else {
                pinTwoTF.textColor = Color_0072DB
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
            if Walletverse.validatePassword(password: textField.text ?? "") {
                pwdOneTF.textColor = Color_333333
            } else {
                pwdOneTF.textColor = Color_0072DB
            }

        } else if textField == pwdTwoTF {
            if Walletverse.validatePassword(password: textField.text ?? "") {
                pwdTwoTF.textColor = Color_333333
            } else {
                pwdTwoTF.textColor = Color_0072DB
            }
        } else if textField == pinOneTF {
            if isPinRuler(password: textField.text ?? "") {
                pinOneTF.textColor = Color_333333
            } else {
                pinOneTF.textColor = Color_0072DB
            }

        } else if textField == pwdTwoTF {
            if isPinRuler(password: textField.text ?? "") {
                pinTwoTF.textColor = Color_333333
            } else {
                pinTwoTF.textColor = Color_0072DB
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
