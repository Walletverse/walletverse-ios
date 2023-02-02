//
//  ReciptCreateView.swift
//  Walletverse
//
//  Created by Ky on 2022/10/10.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

protocol ReciptCreateViewDelegate {
    func getImage(image:UIImage)
}

class ReciptCreateView: BaseView {

    var delegate : ReciptCreateViewDelegate?
        
    var name : String?
    var codeI : UIImage?
    var addressString : String?
    var amountTipS : String?
        
    var contentV : UIImageView = {
        let contentV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 375, height: 667))
        contentV.backgroundColor = UIColor.blue
        return contentV
    }()
        
    var codeIV : UIImageView = {
        return UIImageView()
    }()
        
    var tipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("assets_receipt_scan"), font: FontSystem(size: 14), color: Color_FFFFFF, textAlignment: .center)
    }()
        
    var amountL : UILabel = {
        return CustomView.labelCustom(text: "0", font: FontSystem(size: 16), color: Color_FFFFFF,textAlignment:.center)
    }()
        
    var addressL : UILabel = {
        return CustomView.labelCustom(text: "0", font: FontSystem(size: 12), color: Color_FFFFFF,textAlignment:.center)
    }()
        
    override func configUI() {
        addSubview(contentV)
            
        tipL.frame = CGRect(x: 16, y: 140, width: contentV.width - 32, height: 30)
        contentV.addSubview(tipL)
            
        let iconBackV = UIView(frame: CGRect(x: (contentV.width - 224)/2, y: tipL.bottom + 24, width: 224, height: 220))
        iconBackV.backgroundColor = ColorHex(0xffffff)
        contentV.addSubview(iconBackV)
            
        codeIV.frame = CGRect(x: 16, y: 14, width: iconBackV.width - 32, height: iconBackV.height - 28)
        codeIV.contentMode = .center
        iconBackV.addSubview(codeIV)
            
        amountL.frame = CGRect.init(x: 16, y: iconBackV.bottom + 34, width: contentV.width - 32, height: 22)
        contentV.addSubview(amountL)
            
        addressL.frame = CGRect.init(x: 16, y: iconBackV.bottom + 70, width: contentV.width - 32, height:18)
        contentV.addSubview(addressL)
    }
        
    func setData(name:String,codeI:UIImage,addressString:String,amountTipS:String) {
        self.name = name
        self.codeI = codeI
        self.addressString = addressString
        self.amountTipS = amountTipS
            
        tipL.text = String(format:LocalString("assets_receipt_scan"), self.name ?? "")
        codeIV.image = self.codeI
        amountL.text = self.amountTipS
        addressL.text = self.addressString
            
        UIGraphicsBeginImageContextWithOptions(contentV.size, false, UIScreen.main.scale)
        contentV.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext();
            return
        }
        UIGraphicsEndImageContext();
        delegate?.getImage(image: newImage)
    }
        
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        delegate?.getImage(image: image)
    }
    
    func show() {
        ZWINDOW?.addSubview(self)
    }
        
    func dismiss() {
        self.removeFromSuperview()
    }

}
