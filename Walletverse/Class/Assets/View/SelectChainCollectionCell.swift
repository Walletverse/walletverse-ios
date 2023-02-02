//
//  SelectChainCollectionCell.swift
//  Walletverse
//
//  Created by Ky on 2022/10/11.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

class SelectChainCollectionCell: BaseCollectionViewCell {
    lazy var iconIV : UIImageView = {
        let iconIV = UIImageView()
        return iconIV
    }()
    
    lazy var nameL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_1C1E27, textAlignment: .center)
    }()
    
    override func configUI() {
        backgroundColor = UIColor.white
        iconIV.frame = CGRect(x: (ZSCREENWIDTH/4 - (ZSCREENWIDTH/4 - 20 - 30))/2, y: 10, width: ZSCREENWIDTH/4 - 20 - 30, height: ZSCREENWIDTH/4 - 20 - 30)
        iconIV.layer.cornerRadius = (ZSCREENWIDTH/4 - 20 - 30)/2
        iconIV.clipsToBounds = true
        addSubview(iconIV)
        nameL.frame = CGRect(x: 10, y: iconIV.bottom, width: ZSCREENWIDTH/4 - 20, height: 30)
        addSubview(nameL)
    }
}
