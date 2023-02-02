//
//  CGSize+Utils.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

extension CGSize {
    static func sizeWithText(text:NSString,font:UIFont,size:CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font : font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect : CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size
    }
}
