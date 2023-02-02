//
//  DappTransferView.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import BigInt
import walletverse_ios_sdk

protocol DappTransferViewDelegate  {
    func vertifyPay()
}

class DappTransferView: BaseView {
    
    var dappModel : DappModel?
    var dappJsonModel : DappJsonModel?
    var fee : [String: String]?
    
    var curPrice: BigUInt?

    var delegate: DappTransferViewDelegate?
        
    var backV : UIView!
        
    lazy var mainV : UIView = {
        let mainV = UIView()
        mainV.backgroundColor = ColorHex(0xffffff)
        return mainV
    }()
        
    lazy var closeBtn : UIButton = {
        return CustomView.buttonCustom(image: UIImage(named: "AssetsCloseGray"))
    }()
        
    lazy var titleL : UILabel = {
        return CustomView.labelCustom(text: LocalString("dialog_confirm_pay"), font: FontSystemBold(size: 15), color: Color_444444, textAlignment:.center)
    }()
    
    lazy var tipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("dialog_confirm_dapp_tip"), font: FontSystem(size: 14), color: Color_444444, textAlignment:.center)
    }()
    
    lazy var gasTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("dialog_confirm_dapp_gas"), font: FontSystem(size: 15), color: Color_333333)
    }()
        
    lazy var gasL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 15), color: Color_333333)
    }()
        
    lazy var slider : UISlider = {
        let slider = UISlider()
        slider.center = self.center
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = slider.maximumValue / 2.0
        
        slider.minimumTrackTintColor = Color_0072DB
        slider.maximumTrackTintColor = Color_F2F2F2
        slider.thumbTintColor = Color_0072DB
        
        slider.addTarget(self, action: #selector(sliderValueChanged(slider:)),for: .valueChanged)
        return slider
    }()
    
    lazy var minL : UILabel = {
        return CustomView.labelCustom(text: LocalString("assets_payment_slow"), font: FontSystem(size: 12), color: Color_666666, textAlignment: .left)
    }()
    
    lazy var maxL : UILabel = {
        return CustomView.labelCustom(text: LocalString("assets_payment_fast"), font: FontSystem(size: 12), color: Color_666666, textAlignment: .right)
    }()
    
    lazy var typeTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("dialog_confirm_dapp_type"), font: FontSystem(size: 15), color: Color_333333)
    }()
    
    lazy var typeL : UILabel = {
        return CustomView.labelCustom(text: "transfer", font: FontSystem(size: 15), color: Color_333333)
    }()
        
    lazy var toAddressTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_to"), font: FontSystem(size: 15), color: Color_333333)
    }()
    
    lazy var toAddressL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 15), color: Color_333333)
    }()
        
    lazy var signTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("dialog_confirm_dapp_sign"), font: FontSystem(size: 15), color: Color_333333)
    }()
    
    lazy var signL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 15), color: Color_333333)
    }()
    
    lazy var nextBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("dialog_confirm_pay"), font: FontSystemBold(size: 15), color: Color_FFFFFF, cornerRadius: 4, backColor: Color_0072DB)
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
        mainV.frame = CGRect.init(x: 0, y: ZSCREENHEIGHT - 445 - ZSCREENBOTTOM, width: ZSCREENWIDTH, height: 445 + ZSCREENBOTTOM)
        addSubview(mainV)
            
        closeBtn.frame = CGRect(x: 15, y: 15, width: 20, height: 20)
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        mainV.addSubview(closeBtn)
            
        titleL.frame = CGRect(x: 50, y: 0, width: ZSCREENWIDTH - 100, height: 50)
        mainV.addSubview(titleL)
        
        tipL.frame = CGRect(x: 16, y: titleL.bottom, width: ZSCREENWIDTH - 32, height: 50)
        tipL.numberOfLines = 2
        mainV.addSubview(tipL)
        
        let labelWidth = gasTipL.text?.getLableWidth(font: gasTipL.font, height: 50)
        gasTipL.frame = CGRect(x: 16, y: tipL.bottom + 12, width: labelWidth ?? 0, height: 50)
        mainV.addSubview(gasTipL)
                   
        gasL.frame = CGRect(x: gasTipL.right + 20, y: gasTipL.y, width: ZSCREENWIDTH - gasTipL.right - 36, height: gasTipL.height)
        mainV.addSubview(gasL)
        
        minL.frame = CGRect(x: 16, y: gasL.bottom + 10, width: 50, height: 30)
        mainV.addSubview(minL)
        
        slider.frame = CGRect(x: minL.right + 10, y: minL.y, width: ZSCREENWIDTH - 52 - 100, height: 30)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 0
        mainV.addSubview(slider)
        
        maxL.frame = CGRect(x: slider.right + 10, y: minL.y, width: 50, height: 30)
        mainV.addSubview(maxL)
            
        let typeTipWidth = typeTipL.text?.getLableWidth(font: typeTipL.font, height: 50)
        typeTipL.frame = CGRect(x: 16, y: minL.bottom + 10, width: typeTipWidth ?? 0, height: 50)
        mainV.addSubview(typeTipL)
            
        typeL.frame = CGRect(x: typeTipL.right + 20, y: typeTipL.y, width: ZSCREENWIDTH - toAddressTipL.right - 36, height: 50)
        mainV.addSubview(typeL)
            
        let toAddressTipWidth = toAddressTipL.text?.getLableWidth(font: toAddressTipL.font, height: 50)
        toAddressTipL.frame = CGRect(x: 16, y: typeTipL.bottom + 10, width: toAddressTipWidth ?? 0, height: 50)
        mainV.addSubview(toAddressTipL)
            
        toAddressL.frame = CGRect(x: toAddressTipL.right + 20, y: toAddressTipL.y, width: ZSCREENWIDTH - toAddressTipL.right - 36, height: toAddressTipL.height)
        toAddressL.numberOfLines = 2
        mainV.addSubview(toAddressL)
            
        let signTipWidth = signTipL.text?.getLableWidth(font: signTipL.font, height: 50)
        signTipL.frame = CGRect(x: 16, y: toAddressTipL.bottom + 12, width: signTipWidth ?? 0, height: 50)
        mainV.addSubview(signTipL)
            
        signL.frame = CGRect(x: signTipL.right + 20, y: signTipL.y, width: ZSCREENWIDTH - signTipL.right - 36, height: signTipL.height)
        signL.numberOfLines = 2
        mainV.addSubview(signL)
            
        nextBtn.frame = CGRect.init(x: 16, y: signTipL.bottom + 30, width: ZSCREENWIDTH - 32, height: 50)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        mainV.addSubview(nextBtn)
        
        mainV.frame = CGRect.init(x: 0, y: ZSCREENHEIGHT - (nextBtn.bottom + 30), width: ZSCREENWIDTH, height: nextBtn.bottom + 30)
    }
    
    func setData(dappModel : DappModel?,dappJsonModel : DappJsonModel?,fee : [String: String]?) {
        self.dappModel = dappModel
        self.dappJsonModel = dappJsonModel
        self.fee = fee
        let gasPrice = BigUInt(fee?["gasPrice"] ?? "0") ?? 0
        curPrice = gasPrice
        let gasLimit = BigUInt(fee?["gasLimit"] ?? "0") ?? 0
        
        let gas = gasPrice * gasLimit
        let curGas = Double(gas)/1e18
        
        if (dappModel?.chain?.uppercased() == "KCC") {
            gasL.text = clearZero(String(format: "%.7F",curGas)) + " KCS"
        } else {
            gasL.text = clearZero(String(format: "%.7F",curGas)) + " " + (dappModel?.chain ?? "")
        }
        
        typeL.text = "transfer"
        toAddressL.text = dappJsonModel?.to
        signL.text = dappJsonModel?.data
    }
    
    @objc func sliderValueChanged(slider : UISlider) {
        let current = (BigUInt(fee?["gasPrice"] ?? "0") ?? 0) * BigUInt(slider.value + 100) / BigUInt(100)
        let curGas = Double(current * (BigUInt(fee?["gasLimit"] ?? "0") ?? 0))/1e18
        gasL.text = clearZero(String(format: "%.7F",curGas)) + " " + (dappModel?.chain ?? "ETH")
        curPrice = current
    }
        
    @objc func closeBtnClick() {
        dismiss()
    }
        
    @objc func nextBtnClick() {
        dismiss()
        delegate?.vertifyPay()
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
