//
//  DappTableCell.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class DappTableCell: BaseTableViewCell {

    var dappModel : DappModel?
    
    lazy var mainV : BaseView = {
        let mainV = BaseView()
        mainV.backgroundColor = Color_FFFFFF
        mainV.clipsToBounds = true
        mainV.layer.cornerRadius = 6
        mainV.layer.borderWidth = 1
        mainV.layer.borderColor = Color_F0F1F5.cgColor
        return mainV
    }()
    
    lazy var iconIV : UIImageView = {
        let iconIV = UIImageView()
        iconIV.layer.cornerRadius = 10
        iconIV.clipsToBounds = true
        return iconIV
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
        
        iconIV.frame = CGRect(x: 16, y: (mainV.height - 44)/2, width: 44, height: 44)
        iconIV.layer.cornerRadius = 22
        iconIV.clipsToBounds = true
        mainV.addSubview(iconIV)
        
        nameL.frame = CGRect(x: iconIV.right + 15, y: iconIV.y, width: mainV.width - iconIV.right - 30, height: 20)
        mainV.addSubview(nameL)
        
        contentL.frame = CGRect(x: iconIV.right + 15, y: nameL.bottom + 4, width: mainV.width - iconIV.right - 30, height: 18)
        mainV.addSubview(contentL)
    }
    
    func configData(dappModel:DappModel?) {
        if let model = dappModel {
            self.dappModel = model
            iconIV.kf.setImage(with: URL(string: self.dappModel?.url ?? ""), placeholder: UIImage(named: "IconPlaceholder"), options: nil, progressBlock: nil, completionHandler: nil)
            nameL.text = self.dappModel?.name
            contentL.text = self.dappModel?.name
        }
    }

}
