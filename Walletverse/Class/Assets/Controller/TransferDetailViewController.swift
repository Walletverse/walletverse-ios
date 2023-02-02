//
//  TransferDetailViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/11.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import BigInt
import walletverse_ios_sdk

class TransferDetailViewController: BaseViewController {
    var identityModel: IdentityModel?
    var walletCoin: WalletCoinModel?
    var transactionRecord: TransactionRecord?
    
    
    lazy var iconIV : UIImageView = {
        return UIImageView()
    }()
    
    lazy var statusL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystemBold(size: 16), color: Color_1C1E27, textAlignment: .center)
    }()
    
    lazy var timeL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_7D7F86,textAlignment: .center)
    }()
    
    lazy var amountV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var amountTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_amount"), font: FontSystemBold(size: 12), color: Color_7D7F86)
    }()
    
    lazy var amountL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystemBold(size: 12), color: Color_7D7F86, textAlignment: .right)
    }()
    
    lazy var bodyV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var gasTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_fee"), font: FontSystem(size: 12), color: Color_7D7F86)
    }()
        
    lazy var gasL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_7D7F86, textAlignment: .right)
    }()
    
    lazy var gasLine : UIView = {
        return CustomView.viewCustom(color: Color_F0F1F5)
    }()
    
    lazy var toTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_to"), font: FontSystem(size: 12), color: Color_7D7F86)
    }()
        
    lazy var toL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_7D7F86, textAlignment: .right)
    }()
    
    lazy var toLine : UIView = {
        return CustomView.viewCustom(color: Color_F0F1F5)
    }()
    
    lazy var fromTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_from"), font: FontSystem(size: 12), color: Color_7D7F86)
    }()
        
    lazy var fromL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_7D7F86, textAlignment: .right)
    }()
    
    lazy var fromLine : UIView = {
        return CustomView.viewCustom(color: Color_F0F1F5)
    }()
    
    lazy var hashTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_hash"), font: FontSystem(size: 12), color: Color_7D7F86)
    }()
        
    lazy var hashL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_7D7F86, textAlignment: .right)
    }()
    
    
    lazy var detailV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()

    lazy var detailL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_view"), font: FontSystem(size: 12), color: Color_5C74FF)
    }()

    lazy var detailIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "MineRightArrow"))
    }()

        
    override func viewDidLoad() {
        super.viewDidLoad()

        initBaseNaviLeft()
    }

    override func configUI() {
        
        iconIV.frame = CGRect(x: (ZSCREENWIDTH - 60)/2, y: 30, width: 60, height: 60)
        baseMainV.addSubview(iconIV)
        
        statusL.frame = CGRect(x: 50, y: iconIV.bottom, width: ZSCREENWIDTH - 100, height: 40)
        baseMainV.addSubview(statusL)
        
        timeL.frame = CGRect(x: 50, y: statusL.bottom, width: ZSCREENWIDTH - 100, height: 30)
        baseMainV.addSubview(timeL)
        
        amountV.frame = CGRect.init(x: 15, y: timeL.bottom + 20, width: ZSCREENWIDTH - 30, height: 60)
        amountV.layer.cornerRadius = 4
        amountV.clipsToBounds = true
        baseMainV.addSubview(amountV)
        
        amountTipL.frame = CGRect(x: 15, y: 0, width: (amountV.width - 30)/3, height: 60)
        amountV.addSubview(amountTipL)
        
        amountL.frame = CGRect(x: amountTipL.right, y: 0, width: (amountV.width - 30)/3*2, height: 60)
        amountV.addSubview(amountL)
        
        
        bodyV.frame = CGRect.init(x: 15, y: amountV.bottom + 20, width: ZSCREENWIDTH - 30, height: 243)
        bodyV.layer.cornerRadius = 4
        bodyV.clipsToBounds = true
        baseMainV.addSubview(bodyV)
        
        gasTipL.frame = CGRect(x: 15, y: 0, width: (bodyV.width - 30)/3, height: 60)
        bodyV.addSubview(gasTipL)
        
        gasL.frame = CGRect(x: gasTipL.right, y: 0, width: (bodyV.width - 30)/3*2, height: 60)
        bodyV.addSubview(gasL)
        
        gasLine.frame = CGRect(x: 0, y: gasTipL.bottom, width: bodyV.width, height: 1)
        bodyV.addSubview(gasLine)
        
        toTipL.frame = CGRect(x: 15, y: gasLine.bottom, width: (bodyV.width - 30)/3, height: 60)
        bodyV.addSubview(toTipL)
        
        toL.frame = CGRect(x: toTipL.right, y: gasLine.bottom, width: (bodyV.width - 30)/3*2, height: 60)
        toL.numberOfLines = 0
        bodyV.addSubview(toL)
        
        toLine.frame = CGRect(x: 0, y: toTipL.bottom, width: bodyV.width, height: 1)
        bodyV.addSubview(toLine)
        
        fromTipL.frame = CGRect(x: 15, y: toLine.bottom, width: (bodyV.width - 30)/3, height: 60)
        bodyV.addSubview(fromTipL)
        
        fromL.frame = CGRect(x: fromTipL.right, y: toLine.bottom, width: (bodyV.width - 30)/3*2, height: 60)
        fromL.numberOfLines = 0
        bodyV.addSubview(fromL)
        
        fromLine.frame = CGRect(x: 0, y: fromTipL.bottom, width: bodyV.width, height: 1)
        bodyV.addSubview(fromLine)
        
        hashTipL.frame = CGRect(x: 15, y: fromLine.bottom, width: (bodyV.width - 30)/3, height: 60)
        bodyV.addSubview(hashTipL)
        
        hashL.frame = CGRect(x: hashTipL.right, y: fromLine.bottom, width: (bodyV.width - 30)/3*2, height: 60)
        hashL.numberOfLines = 0
        bodyV.addSubview(hashL)
        

        detailV.frame = CGRect.init(x: 15, y: bodyV.bottom + 20, width: ZSCREENWIDTH - 30, height: 60)
        detailV.layer.cornerRadius = 4
        detailV.clipsToBounds = true
        let detailGesture = UITapGestureRecognizer.init(target: self, action: #selector(detailGestureClick))
        detailV.addGestureRecognizer(detailGesture)
        baseMainV.addSubview(detailV)
        
        detailL.frame = CGRect(x: 15, y: 0, width: ZSCREENWIDTH - 60 - 6, height: 60)
        detailV.addSubview(detailL)
        
        detailIV.frame = CGRect(x: ZSCREENWIDTH - 30 - 21, y: (60 - 12)/2, width: 6, height: 12)
        detailV.addSubview(detailIV)
    }
    
    override func configData() {
        if transactionRecord?.status == "pending" {
            iconIV.image = UIImage(named: "AssesHostPending")
            statusL.text = LocalString("pending")
        } else if transactionRecord?.status == "success" {
            iconIV.image = UIImage(named: "AssetsHostSuccess")
            statusL.text = LocalString("success")
        } else if transactionRecord?.status == "fail" {
            iconIV.image = UIImage(named: "AssetsHostError")
            statusL.text = LocalString("failed")
        }
        var str = transactionRecord?.timestamp ?? ""
        if str.count > 10 {
            let endIndex = str.index(str.endIndex, offsetBy: -3)
            str = str.substring(to: endIndex)
        }
        let date = Date(timeIntervalSince1970: (TimeInterval(str) ?? 0))
        timeL.text = getDateTimeString(time: date)
        
        amountL.text = "\(transactionRecord?.value ?? "") \(walletCoin?.symbol ?? "")"
        if (transactionRecord?.contract?.uppercased() == "KCC") {
            gasL.text = "\(transactionRecord?.gas ?? "") KCS"
        } else {
            gasL.text = "\(transactionRecord?.gas ?? "") \(transactionRecord?.contract ?? "")"
        }
        toL.text = transactionRecord?.to ?? ""
        fromL.text = transactionRecord?.from ?? ""
        hashL.text = transactionRecord?.hash ?? ""
    }
    
    @objc func detailGestureClick() {
        if transactionRecord != nil {
            let controller = CommonWebviewController()
            controller.urlString = transactionRecord?.scanAddressUrl
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
