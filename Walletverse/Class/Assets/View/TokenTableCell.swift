//
//  TokenTableCell.swift
//  Walletverse
//
//  Created by Ky on 2022/10/11.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import BigInt
import walletverse_ios_sdk

class TokenTableCell: BaseTableViewCell {
    var walletCoin: WalletCoinModel?
    var transactionRecord: TransactionRecord?

    lazy var iconIV : UIImageView = {
        let iconIV = UIImageView()
        return iconIV
    }()
    
    lazy var addressL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystemBold(size: 16), color: Color_1C1E27)
    }()
    
    lazy var timeL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_A8ABB2)
    }()
    
    lazy var amountL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 16), color: Color_1C1E27, textAlignment: .right)
    }()
    
    lazy var lineV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
        
    override func configUI() {
        contentView.backgroundColor = UIColor.clear
        
        iconIV.frame = CGRect(x: 15, y: 16, width: 32, height: 32)
        contentView.addSubview(iconIV)
        
        addressL.frame = CGRect(x: iconIV.right + 10, y: iconIV.centerY - 20, width: ZSCREENWIDTH - (iconIV.right + 10 + 120 + 50), height: 20)
        addressL.lineBreakMode = .byTruncatingMiddle
        contentView.addSubview(addressL)
        
        timeL.frame = CGRect(x: iconIV.right + 10, y: addressL.bottom, width: addressL.width, height: 20)
        contentView.addSubview(timeL)
        
        amountL.frame = CGRect(x: addressL.right, y: addressL.bottom - 10, width: 150, height: 20)
        contentView.addSubview(amountL)
        
        lineV.frame = CGRect(x: iconIV.right + 10, y: 63, width: ZSCREENWIDTH - (iconIV.right + 10), height: 1)
        contentView.addSubview(lineV)
    }
        
    func setTransactionRecord(transactionRecord : TransactionRecord?, walletCoin: WalletCoinModel?) {
        self.walletCoin = walletCoin
        if let model = transactionRecord {
            self.transactionRecord = model
            if model.from?.lowercased() == walletCoin?.address?.lowercased() {
                iconIV.image = UIImage(named: "AssetsTokenTransfer")
                addressL.text = model.to
            } else {
                iconIV.image = UIImage(named: "AssetsTokenReceipt")
                addressL.text = model.from
            }
            var str = model.timestamp ?? ""
            if str.count > 10 {
                let endIndex = str.index(str.endIndex, offsetBy: -3)
                str = str.substring(to: endIndex)
            }
            let date = Date(timeIntervalSince1970: (TimeInterval(str) ?? 0))
            timeL.text = getDateTimeString(time: date)
            amountL.text = model.value
        }
    }

}
