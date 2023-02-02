//
//  AssetsMenuTableCell.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

protocol AssetsMenuTableCellDelegate  {
    func manageWalletDelegate(identityModel: IdentityModel?)
}

class AssetsMenuTableCell: BaseTableViewCell {
    var delegate: AssetsMenuTableCellDelegate?
    
    lazy var mainV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
        
    var statusIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "AssetWalletNo"))
    }()
    
    var iconIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "AssetThreePoint"))
    }()
        
    var titleL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystemBold(size: 16), color: Color_1C1E27)
    }()
        
    var identity : IdentityModel?
        
    override func configUI() {
        
        mainV.frame = CGRect(x: 15, y: 10, width: ZSCREENWIDTH - 100 - 30, height: 60)
        mainV.layer.cornerRadius = 4
        mainV.clipsToBounds = true
        mainV.layer.borderWidth = 1
        mainV.layer.borderColor = Color_F0F1F5.cgColor
        contentView.addSubview(mainV)
        
        statusIV.frame = CGRect(x: 15, y: 15, width: 30, height: 30)
        statusIV.contentMode = .center
        mainV.addSubview(statusIV)
            
        iconIV.frame = CGRect(x: mainV.width - 44, y: 0, width: 44, height: 60)
        iconIV.contentMode = .center
        iconIV.isUserInteractionEnabled = true
        let manageGesture = UITapGestureRecognizer.init(target: self, action: #selector(manageGestureClick))
        iconIV.addGestureRecognizer(manageGesture)
        mainV.addSubview(iconIV)
            
        titleL.frame = CGRect(x: statusIV.right + 15, y: 0, width: iconIV.x - 30 - 45, height: 60)
        mainV.addSubview(titleL)
    }
        
    func setTokenModel(identity : IdentityModel?,isSelect:Bool) {
        if isSelect {
            statusIV.image = UIImage(named: "AssetWalletYes")
        } else {
            statusIV.image = UIImage(named: "AssetWalletNo")
        }
        if let model = identity {
            self.identity = model
            titleL.text = model.name ?? "Name"
        }
    }
    
    @objc func manageGestureClick() {
        self.delegate?.manageWalletDelegate(identityModel: identity)
    }
        
}
