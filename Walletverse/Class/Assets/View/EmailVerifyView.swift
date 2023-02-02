//
//  EmailVerifyView.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import WebKit
import SwiftSVG
import walletverse_ios_sdk

protocol EmailVerifyViewDelegate {
    func confirmAction(auth: String)
}

class EmailVerifyView: BaseView {

    var delegate : EmailVerifyViewDelegate?
    var emailCodeModel : EmailCodeModel?
    var email : String?
    
    var backV : UIView!
    
    lazy var mainV : UIView = {
        let mainV = UIView()
        return mainV
    }()
    
    var titleL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_email_verify"), font: FontSystemBold(size: 18), color: Color_828282, textAlignment: .left)
    }()
    
    lazy var codeV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var codeTF : UITextField = {
        let codeTF = CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_333333, delegate: self, placeholder: LocalString("asserts_email_verify"))
        return codeTF
    }()
    
    var codeSGV : UIView = {
        return UIView()
    }()
    
    var hammock : UIView?
    
    lazy var cancelBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("cancel"), font: FontSystemBold(size: 15), color: Color_FFFFFF, cornerRadius: 4, backColor: Color_000000)
    }()
    
    lazy var confirmBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("confirm"), font: FontSystemBold(size: 15), color: Color_FFFFFF, cornerRadius: 4, backColor: Color_0072DB_1)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENHEIGHT)
        backV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENHEIGHT))
        backV.backgroundColor = ColorHex(0x000000, alpha: 0.6)
        self.addSubview(backV)
            
        configSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubviews() {
        mainV.frame = CGRect.init(x: 20, y: (ZSCREENHEIGHT - 200)/2 - 150, width: ZSCREENWIDTH - 40, height: 200)
        mainV.backgroundColor = Color_FFFFFF
        mainV.layer.cornerRadius = 8
        mainV.clipsToBounds = true
        addSubview(mainV)
        
        titleL.frame = CGRect(x: 15, y: 20, width: mainV.width - 30, height: 40)
        mainV.addSubview(titleL)
        
        codeV.frame = CGRect.init(x: 15, y: titleL.bottom + 20, width: (mainV.width - 50)/2, height: 40)
        codeV.clipsToBounds = true
        codeV.layer.cornerRadius = 4
        mainV.addSubview(codeV)
        
        codeTF.frame = CGRect(x: 15, y: 0, width: codeV.width - 30, height: 40)
        codeTF.keyboardType = .numbersAndPunctuation
        codeV.addSubview(codeTF)
        
        codeSGV = UIView(frame: CGRect(x: codeV.right + 20, y: codeV.y - 10, width: codeV.width, height: 60))
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(codeSGVClick))
        codeSGV.addGestureRecognizer(tapGesture)
        mainV.addSubview(codeSGV)
        
        cancelBtn.frame = CGRect.init(x: 15, y: codeV.bottom + 20, width: (mainV.width - 50)/2, height: 40)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        mainV.addSubview(cancelBtn)
        
        confirmBtn.frame = CGRect.init(x: cancelBtn.right + 20, y: cancelBtn.y, width: cancelBtn.width, height: 40)
        confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        mainV.addSubview(confirmBtn)
    }
    
    @objc func codeSGVClick() {
        Walletverse.getGraphicsCode { (result) in
            if let emailCodeModel = result {
                self.emailCodeModel = emailCodeModel
                self.hammock?.removeFromSuperview()
                
                self.hammock = UIView(SVGData: Data((emailCodeModel.data ?? "").utf8), parser: nil) { (svgLayer) in
                    svgLayer.fillColor = UIColor(red:0.52, green:0.16, blue:0.32, alpha:1.00).cgColor
                }
                self.codeSGV.addSubview(self.hammock!)
            }
        }
    }
    
    @objc func cancelBtnClick() {
        dismiss()
    }
    
    @objc func confirmBtnClick() {
        mainV.endEditing(true)
        if codeTF.text?.count ?? 0 > 0 {
            let emailCodeParams = EmailCodeParams(vcode: codeTF.text?.trimmingCharacters( in : .whitespaces), text: emailCodeModel?.text, type: "email", account: self.email)
            Walletverse.getEmailCode(params: emailCodeParams) { (result) in
                if result {
                    self.dismiss()
                    let emailCodeView = EmailCodeView()
                    emailCodeView.setData(email: self.email)
                    emailCodeView.delegate = self
                    emailCodeView.show()
                } else {
                    CommonToastView.showToastAction(message: LocalString("asserts_graph_verify_error"))
                }
            }
        }
    }
    
    func setData(emailCodeModel: EmailCodeModel?, email: String?) {
        self.email = email ?? ""
        self.emailCodeModel = emailCodeModel

        self.hammock = UIView(SVGData: Data((emailCodeModel?.data ?? "").utf8), parser: nil) { (svgLayer) in
            svgLayer.fillColor = UIColor(red:0.52, green:0.16, blue:0.32, alpha:1.00).cgColor
        }
        self.codeSGV.addSubview(self.hammock!)
    }

    func show() {
        ZWINDOW?.addSubview(self)
    }
        
    func dismiss() {
        self.removeFromSuperview()
        mainV.endEditing(true)
    }
        
    static func animationAlert(view : UIView) {
        let popAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        popAnimation.duration = 0.6
        popAnimation.values = [NSValue.init(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1.0)),NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),NSValue.init(caTransform3D: CATransform3DIdentity)];
        popAnimation.keyTimes = [0.0, 0.5, 0.75, 1.0];
        popAnimation.timingFunctions = [CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),CAMediaTimingFunction.init(name:CAMediaTimingFunctionName.easeInEaseOut)]
        view.layer.add(popAnimation, forKey: nil)
    }
}

extension EmailVerifyView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension EmailVerifyView : EmailCodeViewDelegate {
    func confirmAction(auth: String) {
        self.delegate?.confirmAction(auth: auth)
    }
}

