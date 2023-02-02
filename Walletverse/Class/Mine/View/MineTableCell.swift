//
//  MineTableCell.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

class MineTableCell: BaseTableViewCell {
    
    lazy var mainV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    lazy var iconIV : UIImageView = {
        let iconIV = UIImageView()
        return iconIV
    }()
    
    lazy var nameL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystemBold(size: 15), color: Color_333333)
    }()
    
    lazy var arrowIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "MineRightArrow"))
    }()
    
    override func configUI() {
        mainV.frame = CGRect(x: 15, y: 10, width: ZSCREENWIDTH - 30, height: 60)
        mainV.layer.cornerRadius = 4
        mainV.clipsToBounds = true
        mainV.layer.borderWidth = 1
        mainV.layer.borderColor = Color_F0F1F5.cgColor
        contentView.addSubview(mainV)
        
        iconIV.frame = CGRect(x: 15, y: 15, width: 30, height: 30)
        iconIV.contentMode = .center
        mainV.addSubview(iconIV)
        
        arrowIV.frame = CGRect(x: mainV.width - 21, y: (60 - 12)/2, width: 6, height: 12)
        mainV.addSubview(arrowIV)
        
        nameL.frame = CGRect(x: iconIV.right + 15, y: 0, width: (ZSCREENWIDTH - iconIV.right - 30 - 20 - 21), height: 60)
        mainV.addSubview(nameL)
    }

}
