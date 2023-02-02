//
//  UIColor+Utils.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r:UInt32,g:UInt32,b:UInt32,a:CGFloat = 1.0) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
    }
    
    class var random : UIColor {
        return UIColor(r: arc4random_uniform(256), g: arc4random_uniform(256), b: arc4random_uniform(256))
    }
    
    func image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func UIColorHex(_ value:UInt32) -> UIColor {
        return UIColorHex_Alpha(value, alpha : 1.0);
    }
    
    class func UIColorHex_Alpha(_ value:UInt32, alpha:CGFloat) -> UIColor {
        return UIColor(red: ((CGFloat)((value & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((value & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(value & 0xFF)) / 255.0,
                       alpha: alpha)
    }
    
}
