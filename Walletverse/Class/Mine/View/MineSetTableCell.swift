//
//  MineSetTableCell.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

class MineSetTableCell: BaseTableViewCell {
    
    var type : Int?
    
    lazy var nameL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_1C1E27)
    }()
    
    lazy var arrowIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "MineRightArrow"))
    }()
    
    lazy var contentL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_1C1E27, textAlignment: .right)
    }()
    
    lazy var lineV : UIView = {
        return CustomView.viewCustom(color: Color_F0F1F5)
    }()
    
    override func configUI() {
        contentView.backgroundColor = Color_F5F6FA
        
        arrowIV.frame = CGRect(x: ZSCREENWIDTH - 30 - 21, y: (60 - 12)/2, width: 6, height: 12)
        contentView.addSubview(arrowIV)
        
        nameL.frame = CGRect(x: 15, y: 0, width: (ZSCREENWIDTH - 30 - 30 - 20 - 21)/2, height: 60)
        contentView.addSubview(nameL)
        
        contentL.frame = CGRect(x: nameL.right + 20, y: 0, width: nameL.width, height: 60)
        contentView.addSubview(contentL)
        
        lineV.frame = CGRect(x: 16, y: 61, width: ZSCREENWIDTH - 30 - 32, height: 1)
        contentView.addSubview(lineV)
    }
}
