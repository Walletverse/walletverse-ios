//
//  CommonLoadView.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

func AngleWithDegrees(deg : CGFloat) -> CGFloat {
    return (CGFloat(Double.pi) * (deg) / 180.0)
}

class CommonLoadView: BaseView {
    
    var backV : UIView!
    
    lazy var mainV : UIView = {
        let mainV = UIView()
        mainV.backgroundColor = ColorHex(0xffffff)
        return mainV
    }()
    
    lazy var containerLayer : CAReplicatorLayer = {
        let containerLayer = CAReplicatorLayer()
        containerLayer.masksToBounds = true
        containerLayer.instanceCount = 12
        containerLayer.instanceDelay = 0.9 / 12
        containerLayer.instanceTransform = CATransform3DMakeRotation(AngleWithDegrees(deg: 360 / 12), 0, 0, 1)
        return containerLayer
    }()
    
    lazy var titleL : UILabel = {
        return CustomView.labelCustom(text: "Loading...", font: FontSystem(size: 18), color: Color_333333, textAlignment: .center)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENHEIGHT)
        backV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENHEIGHT))
        backV.backgroundColor = ColorHex(0x000000, alpha: 0.6)
        self.addSubview(backV)
        
        configSubviews()
    }
    
    func configSubviews() {
        mainV.frame = CGRect.init(x: (ZSCREENWIDTH - 220)/2, y: (ZSCREENHEIGHT - 146)/2, width: 220, height: 146)
        addSubview(mainV)
        mainV.layer.cornerRadius = 8
        mainV.clipsToBounds = true
        
        containerLayer.frame = CGRect(x: (mainV.width - 60)/2, y: 25, width: 60, height: 60)
        mainV.layer.addSublayer(containerLayer)
        beginAnimation()
        
        titleL.frame = CGRect(x: 15, y: 100, width: mainV.width - 30, height: 46)
        mainV.addSubview(titleL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapRecognizerAction(tapGesture : UITapGestureRecognizer) {
        dismiss()
    }
    
    
    func show() {
        ZWINDOW?.addSubview(self)
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    static func animationAlert(view : UIView) {
        let popAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        popAnimation.duration = 0.6
        popAnimation.values = [NSValue.init(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1.0)),NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),NSValue.init(caTransform3D: CATransform3DIdentity)];
        popAnimation.keyTimes = [0.0, 0.5, 0.75, 1.0];
        popAnimation.timingFunctions = [CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),CAMediaTimingFunction.init(name:CAMediaTimingFunctionName.easeInEaseOut)]
        view.layer.add(popAnimation, forKey: nil)
    }
    
    func beginAnimation() {
        let subLayer2 = CALayer()
        subLayer2.backgroundColor = Color_0072DB.cgColor;
        subLayer2.frame = CGRect(x: (60 - 12) / 2, y: 0, width: 12, height: 12)
        subLayer2.cornerRadius = 12 / 2;
        subLayer2.transform = CATransform3DMakeScale(0, 0, 0);
        containerLayer.addSublayer(subLayer2)
        
        let animation2 = CABasicAnimation.init(keyPath: "transform.scale")
        animation2.fromValue = (1)
        animation2.toValue = (0.1)
        animation2.repeatCount = HUGE
        animation2.duration = 0.9
        subLayer2.add(animation2, forKey: nil)
    }
}
