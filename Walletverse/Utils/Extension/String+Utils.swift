//
//  String+Utils.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit
import CommonCrypto

extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    func getLableHeigh(font:UIFont,width:CGFloat) -> CGFloat {
        let font:UIFont! = font
        let attributes = [NSAttributedString.Key.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let strSize = self.boundingRect(with: CGSize.init(width: width, height:  CGFloat(MAXFLOAT)), options: option, attributes: attributes as [NSAttributedString.Key : Any], context: nil).size
        return ceil(strSize.height) + 1
    }
    
    func getLableWidth(font:UIFont,height:CGFloat) -> CGFloat {
        let size = CGSize.init(width: CGFloat(MAXFLOAT), height: height)
        let dic = [NSAttributedString.Key.font:font]
        let cString = self.cString(using: String.Encoding.utf8)
        let str = String.init(cString: cString!, encoding: String.Encoding.utf8)
        let strSize = str?.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
        return strSize?.width ?? 0
    }
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
