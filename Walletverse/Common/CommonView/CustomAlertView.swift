//
//  CustomAlertView.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

class CustomAlertView: UIAlertController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleFont = FontSystemBold(size: 15)
        let titleAttribute = NSMutableAttributedString.init(string: self.title!)
        titleAttribute.addAttributes([NSAttributedString.Key.font:titleFont,
                                      NSAttributedString.Key.foregroundColor:ColorHex(0x444444)],
                                     range:NSMakeRange(0, (self.title?.count)!))
        self.setValue(titleAttribute, forKey: "attributedTitle")
        
        let messageFontDescriptor = UIFontDescriptor.init(fontAttributes: [
            UIFontDescriptor.AttributeName.family:"Arial",
            UIFontDescriptor.AttributeName.name:"Arial-ItalicMT",
            ])
        
        let messageFont = UIFont.init(descriptor: messageFontDescriptor, size: 15)
        let messageAttribute = NSMutableAttributedString.init(string: self.message!)
        messageAttribute.addAttributes([NSAttributedString.Key.font:messageFont,NSAttributedString.Key.foregroundColor:ColorHex(0x444444)],
                                       range:NSMakeRange(0, (self.message?.count)!))
        self.setValue(messageAttribute, forKey: "attributedMessage")
    }
    
    override func addAction(_ action: UIAlertAction) {
        super.addAction(action)
        if action.style == .cancel {
            action.setValue(ColorHex(0xAFB0B9), forKey:"titleTextColor")
        } else {
            action.setValue(Color_0072DB, forKey:"titleTextColor")
        }
    }

}
