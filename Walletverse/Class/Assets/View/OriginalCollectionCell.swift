//
//  OriginalCollectionCell.swift
//  Walletverse
//
//  Created by Ky on 2022/10/8.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

class OriginalCollectionCell: BaseCollectionViewCell {
    lazy open var mnemonicL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 15), color: Color_444444, textAlignment: .center)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func configUI() {
        addSubview(mnemonicL)
    }
}
