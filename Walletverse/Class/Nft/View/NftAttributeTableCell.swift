//
//  NftAttributeTableCell.swift
//  Walletverse
//
//  Created by Kylin on 2023/3/26.
//  Copyright © 2023 marcopolo. All rights reserved.
//

import Foundation
import UIKit
import walletverse_ios_sdk

class NftAttributeTableCell: BaseTableViewCell {

    var nftAttribute : NftAttribute?
    
    lazy var mainV : BaseView = {
        let mainV = BaseView()
        mainV.backgroundColor = Color_FFFFFF
        mainV.clipsToBounds = true
        mainV.layer.cornerRadius = 6
        mainV.layer.borderWidth = 1
        mainV.layer.borderColor = Color_F0F1F5.cgColor
        return mainV
    }()
    
    lazy var nameL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystemBold(size: 15), color: Color_091C40)
    }()
    
    lazy var contentL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystemItalic(size: 12), color: Color_737983)
    }()
    
    override func configUI() {
        mainV.frame = CGRect(x: 16, y: 5, width: ZSCREENWIDTH - 32, height: 72)
        contentView.addSubview(mainV)
        
        nameL.frame = CGRect(x: 15, y: (mainV.height - 44)/2, width: mainV.width - 30, height: 20)
        mainV.addSubview(nameL)
        
        contentL.frame = CGRect(x: 15, y: nameL.bottom + 4, width: mainV.width - 30, height: 18)
        mainV.addSubview(contentL)
    }
    
    func configData(nftAttribute:NftAttribute?) {
        if let model = nftAttribute {
            self.nftAttribute = model
            nameL.text = self.nftAttribute?.trait_type
            contentL.text = self.nftAttribute?.value
        }
    }

}
