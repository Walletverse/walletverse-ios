//
//  CreateWalletViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/8.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

class CreateWalletViewController: BaseViewController {
    var keyboardHeight:CGFloat = 0.0
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
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
        return CustomView.buttonCustom(text: LocalString("asserts_wallet_create"), font: FontSystemBold(size: 15), color: Color_FFFFFF, cornerRadius: 24, backColor: Color_0072DB)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBaseNaviLeft()
        baseNaviTitle.text = LocalString("asserts_host_no_create")
        
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
        
        let pwd = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
        if (pwd ?? "").isEmpty {
            nameV.frame = CGRect.init(x: 15, y: 0, width: ZSCREENWIDTH - 30, height: 60)
            nameV.clipsToBounds = true
            nameV.layer.cornerRadius = 4
            scrollView.addSubview(nameV)
            
            nameTF.frame = CGRect(x: 15, y: 0, width: nameV.width - 30, height: 60)
            nameTF.keyboardType = .default
            nameTF.addTarget(self, action: #selector(nameLimit(textField:)), for: .editingChanged)
            nameV.addSubview(nameTF)
            
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
            pwdOneTF.addTarget(self, action: #selector(oneLongLimit(textField:)), for: .editingChanged)
            lineOneV.addSubview(pwdOneTF)
            
            lineTwoV.frame = CGRect.init(x: 15, y: lineOneV.bottom + 10, width: ZSCREENWIDTH - 30, height: 60)
            lineTwoV.clipsToBounds = true
            lineTwoV.layer.cornerRadius = 4
            scrollView.addSubview(lineTwoV)
            
            pwdTwoTF.frame = CGRect(x: 15, y: 0, width: lineTwoV.width - 30, height: 60)
            pwdTwoTF.keyboardType = .numberPad
            pwdTwoTF.isSecureTextEntry = true
            pwdTwoTF.addTarget(self, action: #selector(twoLongLimit(textField:)), for: .editingChanged)
            lineTwoV.addSubview(pwdTwoTF)
            
            nextBtn.frame = CGRect.init(x: 16, y: lineTwoV.bottom + 40, width: ZSCREENWIDTH - 32, height: 48)
            nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
            scrollView.addSubview(nextBtn)
            
            if nextBtn.bottom + 20 > baseMainV.height - ZSCREENBOTTOM {
                scrollView.contentSize = CGSize(width: scrollView.width,height: nextBtn.bottom + 200)
            } else {
                scrollView.contentSize = CGSize(width: scrollView.width,height: baseMainV.height - ZSCREENBOTTOM)
            }
        } else {
            nameV.frame = CGRect.init(x: 15, y: 0, width: ZSCREENWIDTH - 30, height: 60)
            nameV.clipsToBounds = true
            nameV.layer.cornerRadius = 4
            scrollView.addSubview(nameV)
            
            nameTF.frame = CGRect(x: 15, y: 0, width: nameV.width - 30, height: 60)
            nameTF.addTarget(self, action: #selector(nameLimit(textField:)), for: .editingChanged)
            nameV.addSubview(nameTF)
            
            
            nextBtn.frame = CGRect.init(x: 16, y: nameV.bottom + 40, width: ZSCREENWIDTH - 32, height: 48)
            nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
            nextBtn.backgroundColor = Color_0072DB
            scrollView.addSubview(nextBtn)
            
            if nextBtn.bottom + 20 > baseMainV.height {
                scrollView.contentSize = CGSize(width: scrollView.width,height: nextBtn.bottom + 200)
            } else {
                scrollView.contentSize = CGSize(width: scrollView.width,height: baseMainV.height)
            }
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
    
    @objc func nameLimit(textField:UITextField) {

    }
    
    @objc func oneLongLimit(textField:UITextField) {

    }
    
    @objc func twoLongLimit(textField:UITextField) {

    }
    
    func preCompare() -> Bool {
        var pinTrue = false
        let pwd = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
        if (pwd ?? "").isEmpty {
            if isPasswordRuler(password: pwdOneTF.text ?? "") && isPasswordRuler(password: pwdTwoTF.text ?? "") {
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
        var nameTrue = false
        if nameTF.text?.count ?? 0 > 0 {
            nameTrue = true
        } else {
            nameTrue = false
            CommonToastView.showToastAction(message: LocalString("asserts_wallet_name_tip1"))
        }
        return pinTrue && nameTrue
    }
    
    @objc func nextBtnClick() {
        view.endEditing(true)
        
        let isEnable = preCompare()
        if isEnable {
            let pwd = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
            if (pwd ?? "").isEmpty {
                let controller = CreateMnemonicViewController()
                controller.name = nameTF.text?.trimmingCharacters( in : .whitespaces) ?? ""
                controller.pwdString = pwdOneTF.text?.trimmingCharacters( in : .whitespaces) ?? ""
                navigationController?.pushViewController(controller, animated: true)
            } else {
                let controller = CreateMnemonicViewController()
                controller.name = nameTF.text?.trimmingCharacters( in : .whitespaces) ?? ""
                controller.pwdString = pwd
                navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func isPasswordRuler(password:String) -> Bool {
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

extension CreateWalletViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == pwdOneTF {
            pwdOneTF.textColor = Color_333333
        } else if textField == pwdTwoTF {
            pwdTwoTF.textColor = Color_333333
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == pwdOneTF {
            if isPasswordRuler(password: textField.text ?? "") {
                pwdOneTF.textColor = Color_333333
            } else {
                pwdOneTF.textColor = Color_0072DB
            }
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == pwdTwoTF {
            if isPasswordRuler(password: textField.text ?? "") {
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
            if isPasswordRuler(password: textField.text ?? "") {
                pwdOneTF.textColor = Color_333333
            } else {
                pwdOneTF.textColor = Color_0072DB
            }
            
        } else if textField == pwdTwoTF {
            if isPasswordRuler(password: textField.text ?? "") {
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
