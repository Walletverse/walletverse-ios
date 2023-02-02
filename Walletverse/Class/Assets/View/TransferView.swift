//
//  TransferView.swift
//  Walletverse
//
//  Created by Ky on 2022/10/11.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import BigInt

protocol TransferViewDelegate  {
    func vertifyPay()
}

class TransferView: BaseView {

    var delegate: TransferViewDelegate?
        
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
        return CustomView.labelCustom(text: LocalString("asserts_pay_detail"), font: FontSystemBold(size: 15), color: Color_444444, textAlignment:.center)
    }()
    
    lazy var amountL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystemBold(size: 20), color: Color_444444, textAlignment:.center)
    }()
    
    lazy var toTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_to"), font: FontSystem(size: 15), color: Color_333333)
    }()
    
    lazy var toL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_333333, textAlignment: .right)
    }()
    
    lazy var fromTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_from"), font: FontSystem(size: 15), color: Color_333333)
    }()
    
    lazy var fromL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_333333, textAlignment: .right)
    }()
    
    
    lazy var gasTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_fee"), font: FontSystem(size: 15), color: Color_333333)
    }()
        
    lazy var gasL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_333333, textAlignment: .right)
    }()
    
    lazy var gasDetailL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_333333, textAlignment: .right)
    }()
    
    lazy var nextBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("confirm"), font: FontSystemBold(size: 15), color: Color_FFFFFF, cornerRadius: 4, backColor: Color_0072DB)
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
        
        amountL.frame = CGRect(x: 50, y: titleL.bottom + 20, width: ZSCREENWIDTH - 100, height: 40)
        mainV.addSubview(amountL)
        
        toTipL.frame = CGRect(x: 15, y: amountL.bottom + 20, width: (ZSCREENWIDTH - 30)/3, height: 50)
        mainV.addSubview(toTipL)
        
        toL.frame = CGRect(x: toTipL.right, y: amountL.bottom + 20, width: (ZSCREENWIDTH - 30)/3*2, height: 50)
        toL.numberOfLines = 2
        mainV.addSubview(toL)
        
        fromTipL.frame = CGRect(x: 15, y: toTipL.bottom + 20, width: (ZSCREENWIDTH - 30)/3, height: 50)
        mainV.addSubview(fromTipL)
        
        fromL.frame = CGRect(x: toTipL.right, y: toTipL.bottom + 20, width: (ZSCREENWIDTH - 30)/3*2, height: 50)
        fromL.numberOfLines = 2
        mainV.addSubview(fromL)
        
        gasTipL.frame = CGRect(x: 15, y: fromTipL.bottom + 20, width: (ZSCREENWIDTH - 30)/3, height: 50)
        mainV.addSubview(gasTipL)
        
        gasL.frame = CGRect(x: gasTipL.right, y: gasTipL.centerY - 20, width: (ZSCREENWIDTH - 30)/3*2, height: 20)
        mainV.addSubview(gasL)
        
        gasDetailL.frame = CGRect(x: gasTipL.right, y: gasL.bottom, width: (ZSCREENWIDTH - 30)/3*2, height: 20)
        mainV.addSubview(gasDetailL)
            
        nextBtn.frame = CGRect.init(x: 16, y: gasTipL.bottom + 30, width: ZSCREENWIDTH - 32, height: 50)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        mainV.addSubview(nextBtn)
        
        mainV.frame = CGRect.init(x: 0, y: ZSCREENHEIGHT - (nextBtn.bottom + 30), width: ZSCREENWIDTH, height: nextBtn.bottom + 30)
    }
    
    func setData(amount: String?, to: String?, from: String?, gas: String?, gasDetail: String?) {
        amountL.text = amount
        toL.text = to
        fromL.text = from
        gasL.text = gas
        gasDetailL.text = gasDetail
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
