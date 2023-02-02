//
//  CustomView.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

class CustomView: NSObject {
    static func viewCustom(color:UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
    
    static func viewCustom(text:String,font:UIFont,color:UIColor) -> UIView {
        let view = UIView()
        view.size = CGSize(width: ZSCREENWIDTH - 32, height: 50)
        view.backgroundColor = ColorHex(0xffffff)
        
        let titleL : UILabel = CustomView.labelCustom(text: text, font: font, color: color)
        titleL.frame = CGRect(x: 15, y: 0, width: view.width - 54, height: 50)
        view.addSubview(titleL)
        
        let arrowIV : UIImageView = CustomView.imageViewCustom(image: UIImage(named: "right_arrow"))
        arrowIV.frame = CGRect(x: view.width - 24, y: (view.height - 11)/2, width: 7, height: 11)
        view.addSubview(arrowIV)
        
        return view
    }
    
    static func labelCustom(text:String,font:UIFont,color:UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        return label
    }
    
    static func labelCustom(text:String,font:UIFont,color:UIColor,textAlignment:NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.textAlignment = textAlignment
        return label
    }
    
    static func buttonCustom(image:UIImage?) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        return button
    }
    
    static func buttonCustom(normalImage:UIImage?,selectedImage:UIImage?) -> UIButton {
        let button = UIButton()
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        return button
    }
    
    static func buttonCustom(text:String,font:UIFont,color:UIColor,cornerRadius:CGFloat,backColor:UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = font
        button.backgroundColor = backColor
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        return button
    }
    static func buttonCustom(text:String,font:UIFont,color:UIColor,cornerRadius:CGFloat,backImage:UIImage?,selectImage:UIImage?) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = font
        button.setBackgroundImage(backImage, for: .normal)
        button.setBackgroundImage(selectImage, for: .selected)
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        return button
    }
    
    static func buttonCustom(text:String,font:UIFont,color:UIColor,cornerRadius:CGFloat,normalImage:UIImage?,selectImage:UIImage?) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = font
        button.setImage(normalImage, for: .normal)
        button.setImage(selectImage, for: .selected)
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        return button
    }
    
    static func buttonCustom(text:String,font:UIFont,color:UIColor,image:UIImage?,selectImage:UIImage?,cornerRadius:CGFloat) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = font
        button.setImage(image, for: .normal)
        button.setImage(selectImage, for: .selected)
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        return button
    }
    
    static func imageViewCustom(image:UIImage?) -> UIImageView {
        let imageV = UIImageView()
        imageV.image = image
        return imageV
    }
    
    static func textFieldCustom(text:String,font:UIFont,color:UIColor,delegate:UITextFieldDelegate,placeholder:String) -> UITextField {
        let textField = UITextField()
        textField.delegate = delegate
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        
        textField.text = text
        textField.font = font
        textField.textColor = color
        textField.placeholder = placeholder
        textField.tintColor = Color_717782
        
        return textField
    }
    
    static func textFieldCustom(text:String,font:UIFont,color:UIColor,delegate:UITextFieldDelegate,placeholder:String,tintColor:UIColor) -> UITextField {
        let textField = UITextField()
        textField.delegate = delegate
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        
        textField.text = text
        textField.font = font
        textField.textColor = color
        textField.placeholder = placeholder
        textField.tintColor = tintColor
        
        return textField
    }
}
