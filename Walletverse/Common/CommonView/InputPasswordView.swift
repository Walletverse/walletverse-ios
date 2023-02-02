//
//  InputPasswordView.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

protocol InputPasswordViewDelegate  {
    func inputPasswordDelegate(pwd: String)
}

class InputPasswordView: BaseView {

    var delegate: InputPasswordViewDelegate?
    var pwdString : String?
    
    var backV : UIView!
    
    lazy var mainV : UIView = {
        let mainV = UIView()
        mainV.backgroundColor = Color_F3F4F6
        return mainV
    }()
    
    lazy var closeBtn : UIButton = {
        return CustomView.buttonCustom(image: UIImage(named: "AssetsCloseGray"))
    }()
    
    lazy var titleL : UILabel = {
        return CustomView.labelCustom(text: LocalString("dialog_input_password"), font: FontSystemBold(size: 16), color: Color_091C40, textAlignment:.center)
    }()
    
    lazy var lineOneV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    lazy var pwdOneTF : UITextField = {
        let pwdOneTF = CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_091C40, delegate: self, placeholder: LocalString("dialog_pay_password"),tintColor: Color_717782)
        return pwdOneTF
    }()
    
    lazy var nextBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("confirm"), font: FontSystemBold(size: 15), color: Color_FFFFFF, cornerRadius: 4, backColor: Color_0072DB_0)
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENHEIGHT)
        backV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENHEIGHT))
        backV.backgroundColor = ColorHex(0x000000, alpha: 0.6)
        self.addSubview(backV)
        backV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapRecognizerAction(tapGesture:))))
        
        registerNotification()
        configSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerNotification() {
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification , object: nil)
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillChange(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    func configSubviews() {
        mainV.frame = CGRect.init(x: 0, y: ZSCREENHEIGHT - 236, width: ZSCREENWIDTH, height: 236)
        addSubview(mainV)
        
        closeBtn.frame = CGRect(x: 15, y: 15, width: 20, height: 20)
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        mainV.addSubview(closeBtn)
        
        titleL.frame = CGRect.init(x: 50, y: 0, width: ZSCREENWIDTH - 100, height: 50)
        mainV.addSubview(titleL)
        
        lineOneV.frame = CGRect.init(x: 16, y: titleL.bottom + 14, width: ZSCREENWIDTH - 32, height: 42)
        lineOneV.layer.cornerRadius = 4
        lineOneV.clipsToBounds = true
        mainV.addSubview(lineOneV)
        
        pwdOneTF.frame = CGRect(x: 15, y: 0, width: lineOneV.width - 15 - 42, height: 42)
        let rightBtn = UIButton.init(frame: CGRect.init(x: pwdOneTF.right, y: pwdOneTF.centerY - 21, width: 42, height: 42))
        rightBtn.setImage(UIImage(named: "pwd_hidden"), for: .normal)
        rightBtn.setImage(UIImage(named: "pwd_show"), for: .selected)
        rightBtn.addTarget(self, action: #selector(rightBtnClick(button:)), for: .touchUpInside)
        lineOneV.addSubview(rightBtn)
        pwdOneTF.isSecureTextEntry = true
        pwdOneTF.keyboardType = .numberPad
        pwdOneTF.addTarget(self, action: #selector(oneLongLimit(textField:)), for: .editingChanged)
        lineOneV.addSubview(pwdOneTF)
        
        nextBtn.frame = CGRect.init(x: 16, y: lineOneV.bottom + 25, width: ZSCREENWIDTH - 32, height: 48)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        nextBtn.isEnabled = false
        mainV.addSubview(nextBtn)
    }
    
    @objc func tapRecognizerAction(tapGesture : UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc func closeBtnClick() {
        dismiss()
    }
    
    @objc func rightBtnClick(button:UIButton) {
        button.isSelected = !button.isSelected;
        if (!button.isSelected) {
            pwdOneTF.isSecureTextEntry = true;
        } else {
            pwdOneTF.isSecureTextEntry = false;
        }
    }
    
    @objc func oneLongLimit(textField:UITextField) {
        pwdCompare()
    }
    
    func pwdCompare() {
        if pwdOneTF.text?.trimmingCharacters( in : .whitespaces).count ?? 0 > 0 {
            nextBtn.backgroundColor = Color_0072DB_1
            nextBtn.isEnabled = true
        } else {
            nextBtn.backgroundColor = Color_0072DB_0
            nextBtn.isEnabled = false
        }
        pwdString = pwdOneTF.text?.trimmingCharacters( in : .whitespaces)
    }
    
    @objc func nextBtnClick() {
        nextBtn.isEnabled = false
        dismiss()
        delegate?.inputPasswordDelegate(pwd: pwdString ?? "")
    }
    
    func show() {
        ZWINDOW?.addSubview(self)
        pwdOneTF.becomeFirstResponder()
        //        InputPasswordView.animationAlert(view: mainV)
    }
    
    func dismiss() {
        self.removeFromSuperview()
        pwdOneTF.resignFirstResponder()
    }
    
    static func animationAlert(view : UIView) {
        let popAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        popAnimation.duration = 0.6
        popAnimation.values = [NSValue.init(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1.0)),NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),NSValue.init(caTransform3D: CATransform3DIdentity)];
        popAnimation.keyTimes = [0.0, 0.5, 0.75, 1.0];
        popAnimation.timingFunctions = [CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),CAMediaTimingFunction.init(name:CAMediaTimingFunctionName.easeInEaseOut)]
        view.layer.add(popAnimation, forKey: nil)
    }
    
    @objc func keyBoardWillShow(_ notification : Notification) {
        DispatchQueue.main.async {
            self.mainV.frame = CGRect.init(x: 0, y: ZSCREENHEIGHT - 236, width: ZSCREENWIDTH, height: 236)
            let user_info = notification.userInfo
            let keyboardRect = (user_info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let y = keyboardRect.origin.y
            UIView.animate(withDuration: 0.5, animations: {
                self.mainV.frame = CGRect.init(x: 0, y: y - 236, width: ZSCREENWIDTH, height: 236)
            })
        }
    }
    
    @objc func keyBoardWillHide(_ notification : Notification) {
        DispatchQueue.main.async {
            self.mainV.frame = CGRect.init(x: 0, y: ZSCREENHEIGHT, width: ZSCREENWIDTH, height: 236)
        }
    }
    
    @objc func keyBoardWillChange(_ notification : Notification) {}
    
    deinit {
        ZNOTIFICATION.removeObserver(self)
    }
}

extension InputPasswordView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
