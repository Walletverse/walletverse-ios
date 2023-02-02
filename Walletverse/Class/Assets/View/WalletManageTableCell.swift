//
//  WalletManageTableCell.swift
//  Walletverse
//
//  Created by Ky on 2022/10/10.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

class WalletManageTableCell: BaseTableViewCell {
    lazy var nameL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_1C1E27)
    }()
    
    lazy var arrowIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "MineRightArrow"))
    }()
    
    lazy var lineV : UIView = {
        return CustomView.viewCustom(color: Color_F0F1F5)
    }()
    
    override func configUI() {
        contentView.backgroundColor = Color_F5F6FA
        
        nameL.frame = CGRect(x: 15, y: 0, width: ZSCREENWIDTH - 60 - 6, height: 60)
        contentView.addSubview(nameL)
        
        arrowIV.frame = CGRect(x: ZSCREENWIDTH - 30 - 21, y: (60 - 12)/2, width: 6, height: 12)
        contentView.addSubview(arrowIV)
        
        lineV.frame = CGRect(x: 15, y: 59, width: ZSCREENWIDTH - 30, height: 1)
        contentView.addSubview(lineV)
    }
}
