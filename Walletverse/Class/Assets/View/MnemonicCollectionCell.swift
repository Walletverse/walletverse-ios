//
//  MnemonicCollectionCell.swift
//  Walletverse
//
//  Created by Ky on 2022/10/8.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

class MnemonicCollectionCell: BaseCollectionViewCell {
    lazy open var mnemonicL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 15), color: Color_444444, textAlignment: .center)
    }()
    
    override func configUI() {
        backgroundColor = UIColor.white
        addSubview(mnemonicL)
    }
}
