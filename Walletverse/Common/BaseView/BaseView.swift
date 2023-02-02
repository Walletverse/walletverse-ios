//
//  BaseView.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configUI() {}
    open func configUI(frame : CGRect) {}
    
    func setShadow(sColor:UIColor,offset:CGSize,opacity:Float,sRadius:CGFloat) {
        let bgLayer1 = CALayer()
        bgLayer1.frame = bounds
        bgLayer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        bgLayer1.cornerRadius = 10
        bgLayer1.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        bgLayer1.borderWidth = 0.5
        layer.addSublayer(bgLayer1)
        
        layer.shadowColor = sColor.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = sRadius
        layer.shadowOffset = offset
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
