//
//  AssetsWalletTableCell.swift
//  Walletverse
//
//  Created by Ky on 2022/10/10.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class AssetsWalletTableCell: BaseTableViewCell {

    lazy var mainV : UIView = {
        let mainV = UIView()
        mainV.backgroundColor = Color_FFFFFF
        return mainV
    }()
    
    lazy var iconIV : UIImageView = {
        let iconIV = UIImageView()
        return iconIV
    }()
    
    lazy var chainIV : UIImageView = {
        let iconIV = UIImageView()
        return iconIV
    }()
    
    lazy var nameL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystemBold(size: 16), color: Color_1C1E27)
    }()
    
    lazy var contentL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 16), color: Color_1C1E27, textAlignment: .right)
    }()
    
    lazy var rmbCountL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_7D7F86, textAlignment: .right)
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
        
        iconIV.frame = CGRect(x: 15, y: (mainV.height - 40)/2, width: 40, height: 40)
        iconIV.layer.cornerRadius = 20
        iconIV.clipsToBounds = true
        mainV.addSubview(iconIV)
        
        chainIV.frame = CGRect(x: iconIV.right - 12, y: iconIV.bottom - 12, width: 12, height: 12)
        mainV.addSubview(chainIV)
        
        nameL.frame = CGRect(x: iconIV.right + 15, y: iconIV.centerY - 10, width: 120, height: 20)
        mainV.addSubview(nameL)
        
        contentL.frame = CGRect(x: nameL.right + 20, y: iconIV.centerY - 20, width: mainV.width - nameL.right - 36, height: 20)
        mainV.addSubview(contentL)
        
        rmbCountL.frame = CGRect(x: nameL.right + 20, y: iconIV.centerY, width: mainV.width - nameL.right - 36, height: 20)
        mainV.addSubview(rmbCountL)
        
        lineV.frame = CGRect(x: iconIV.right + 10, y: mainV.height - 1, width: ZSCREENWIDTH - (iconIV.right + 10), height: 1)
        mainV.addSubview(lineV)
        
    }
    
    // icon_local_abey_unchecked_light
    func getChainImage(chain: String) -> String {
        switch chain {
        case "ABEY":
            return "icon_local_abey_unchecked_light"
        case "AVAX":
            return "icon_local_avax_unchecked_light"
        case "BNB":
            return "icon_local_bnb_unchecked_light"
        case "CUBE":
            return "icon_local_cube_unchecked_light"
        case "ETH":
            return "icon_local_eth_unchecked_light"
        case "FTM":
            return "icon_local_ftm_unchecked_light"
        case "KCS":
            return "icon_local_kcs_unchecked_light"
        case "KCC":
            return "icon_local_kcs_unchecked_light"
        case "KLAY":
            return "icon_local_klay_unchecked_light"
        case "MAP":
            return "icon_local_map_unchecked_light"
        case "MEV":
            return "icon_local_mev_unchecked_light"
        case "OKT":
            return "icon_local_okt_unchecked_light"
        case "POLYGON":
            return "icon_local_polygon_unchecked_light"
        case "TRUE":
            return "icon_local_true_unchecked_light"
        default:
            return ""
        }
    }
    
    func setWalletCoin(walletCoin : WalletCoinModel?,isShow : Bool?) {
        if let model = walletCoin {
            self.walletCoin = model
            iconIV.kf.setImage(urlString: model.iconUrl, placeholder: UIImage(named: "IconPlaceholder"))
            nameL.text = model.symbol
            
            if model.type == "COIN" {
                chainIV.isHidden = false
                chainIV.image = UIImage(named: getChainImage(chain: model.contract ?? ""))
            } else {
                chainIV.isHidden = true
            }

            if walletCoin?.balance?.count ?? 0 > 0 {
                contentL.text = walletCoin?.balance
            } else {
                contentL.text = "0"
            }
            if walletCoin?.totalPrice?.count ?? 0 > 0 {
                rmbCountL.text = "≈\(CurrencyUtil.getHostAmountMoney())\(walletCoin?.totalPrice ?? "0")"
            } else {
                rmbCountL.text = "--"
            }
        }
    }
    
}
