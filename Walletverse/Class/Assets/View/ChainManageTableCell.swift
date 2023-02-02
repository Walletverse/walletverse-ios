//
//  ChainManageTableCell.swift
//  Walletverse
//
//  Created by Ky on 2022/10/10.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

protocol ChainManageTableCellDelegate  {
    func hideWalletDelegate(walletCoin: WalletCoinModel?)
}

class ChainManageTableCell: BaseTableViewCell {
    
    var delegate: ChainManageTableCellDelegate?

    lazy var mainV : UIView = {
        let mainV = UIView()
        mainV.backgroundColor = Color_FFFFFF
        return mainV
    }()
    
    lazy var iconIV : UIImageView = {
        let iconIV = UIImageView()
        return iconIV
    }()
    
    lazy var nameL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystemBold(size: 14), color: Color_1C1E27)
    }()
    
    lazy var addressL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_A8ABB2)
    }()
    
    var hideIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "AssetThreePoint"))
    }()
    
    lazy var lineV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    var walletCoin : WalletCoinModel?
    
    override func configUI() {
        contentView.backgroundColor = UIColor.clear
        
        mainV.frame = CGRect(x: 15, y: 5, width: ZSCREENWIDTH - 30, height: 64)
        mainV.layer.cornerRadius = 4
        mainV.clipsToBounds = true
        contentView.addSubview(mainV)
        
        iconIV.frame = CGRect(x: 15, y: (mainV.height - 30)/2, width: 30, height: 30)
        iconIV.layer.cornerRadius = 15
        iconIV.clipsToBounds = true
        mainV.addSubview(iconIV)
        
        nameL.frame = CGRect(x: iconIV.right + 15, y: 10, width: mainV.width - 60 - 64, height: 20)
        mainV.addSubview(nameL)
        
        addressL.frame = CGRect(x: iconIV.right + 15, y: nameL.bottom + 4, width: mainV.width - 60 - 64, height: 20)
        mainV.addSubview(addressL)
        
        hideIV.frame = CGRect(x: mainV.width - 45, y: (mainV.height - 30)/2, width: 30, height: 30)
        hideIV.contentMode = .center
        hideIV.isUserInteractionEnabled = true
        let hideGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideGestureClick))
        hideIV.addGestureRecognizer(hideGesture)
        mainV.addSubview(hideIV)
        
        lineV.frame = CGRect(x: iconIV.right + 15, y: mainV.height - 1, width: mainV.width - (iconIV.right + 10), height: 1)
        mainV.addSubview(lineV)
        
    }
    
    func setWalletCoin(walletCoin : WalletCoinModel?) {
        if let model = walletCoin {
            self.walletCoin = model
            iconIV.kf.setImage(urlString: model.iconUrl, placeholder: UIImage(named: "IconPlaceholder"))
            nameL.text = model.symbol
            addressL.text = model.address
            if model.contract == "ETH" {
                hideIV.isHidden = true
            } else {
                hideIV.isHidden = false
            }
        }
    }
    
    @objc func hideGestureClick() {
        self.delegate?.hideWalletDelegate(walletCoin: walletCoin)
    }
    
}
