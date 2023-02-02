//
//  ReceiveViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/10.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class ReceiveViewController: BaseViewController {
    
    var identityModel: IdentityModel?
    var walletCoin: WalletCoinModel?
    
    var tipIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "icon_exclamation_mark"))
    }()
    
    lazy var tipL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_1C1E27)
    }()
    
    var backV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var titleL : UILabel = {
        return CustomView.labelCustom(text: String(format:LocalString("assets_receipt_scan"), walletCoin?.symbol ?? ""), font: FontSystemBold(size: 18), color: Color_1C1E27, textAlignment: .center)
    }()
    
    lazy var codeIV : UIImageView = {
        return UIImageView()
    }()
    
    lazy var addressL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_7D7F86, textAlignment: .center)
    }()
    
    var lineOneV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    var lineTwoV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    var copyBtn : UIButton = {
        return CustomView.buttonCustom(text: " " + LocalString("copy"), font: FontSystemBold(size: 14), color: Color_1C1E27, image: UIImage(named: "AssetCopy"), selectImage: UIImage(named: "AssetCopy"), cornerRadius: 0)
    }()
    
    var shareBtn : UIButton = {
        return CustomView.buttonCustom(text: " " + LocalString("share"), font: FontSystemBold(size: 14), color: Color_1C1E27, image: UIImage(named: "AssetShare"), selectImage: UIImage(named: "AssetShare"), cornerRadius: 0)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBaseNaviLeft()
        baseNaviTitle.text = LocalString("asserts_receive")
        
        tipIV.frame = CGRect(x: 15, y: 30, width: 30, height: 30)
        tipIV.contentMode = .center
        baseMainV.addSubview(tipIV)
        
        tipL.frame = CGRect(x: tipIV.right + 5, y: tipIV.centerY - 20, width: ZSCREENWIDTH - tipIV.right - 20, height: 40)
        tipL.numberOfLines = 0
        tipL.text = String(format:LocalString("asserts_receive_tip"), (walletCoin?.symbol ?? ""))
            
            
        baseMainV.addSubview(tipL)
        
        backV.frame = CGRect(x: 20, y: tipIV.bottom + 40, width: ZSCREENWIDTH - 40, height: 450)
        backV.layer.cornerRadius = 4
        backV.clipsToBounds = true
        baseMainV.addSubview(backV)
        
        titleL.frame = CGRect(x: 16, y: 30, width: backV.width - 32, height: 20)
        backV.addSubview(titleL)
        
        codeIV.frame = CGRect(x: (backV.width - 202)/2, y: titleL.bottom + 30, width: 202, height: 202)
        codeIV.backgroundColor = UIColor.random
        backV.addSubview(codeIV)
        
        addressL.frame = CGRect(x: 10, y: codeIV.bottom + 30, width: backV.width - 20, height: 30)
        addressL.textAlignment = .center
        backV.addSubview(addressL)
        
        lineOneV.frame = CGRect(x: 0, y: addressL.bottom + 30, width: backV.width, height: 1)
        backV.addSubview(lineOneV)
        
        lineTwoV.frame = CGRect(x: (backV.width - 1)/2, y: lineOneV.bottom, width: 1, height:44)
        backV.addSubview(lineTwoV)
        
        copyBtn.frame = CGRect(x: 0, y: lineOneV.bottom, width: (backV.width - 1)/2, height:44)
        copyBtn.addTarget(self, action: #selector(copyBtnClick), for: .touchUpInside)
        backV.addSubview(copyBtn)
        
        shareBtn.frame = CGRect(x: lineTwoV.right, y: lineOneV.bottom, width: (backV.width - 1)/2, height:44)
        shareBtn.addTarget(self, action: #selector(shareBtnClick), for: .touchUpInside)
        backV.addSubview(shareBtn)
        
        backV.frame = CGRect(x: 20, y: tipIV.bottom + 40, width: ZSCREENWIDTH - 40, height: 373 + 44)
        
        updateData()
    }
    
    func updateData() {
        addressL.text = walletCoin?.address ?? ""
        guard let qrImg = ZGScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString: walletCoin?.address ?? "", size: codeIV.size, qrColor: UIColor.black, bkColor: UIColor.white) else {
            return
        }
        guard let logoImg = UIImage(named: "IconPlaceholder") else {
            return
        }
        codeIV.image = ZGScanWrapper.addImageLogo(srcImg: qrImg, logoImg: logoImg, logoSize: CGSize(width: 0, height: 0))
    }
    
    @objc func copyBtnClick() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = walletCoin?.address ?? ""
        CommonToastView.showToastAction(message: LocalString("common_already_copy"))
    }
    
    @objc func shareBtnClick() {
        let reciptCreateView = ReciptCreateView()
        reciptCreateView.delegate = self
        reciptCreateView.setData(name: walletCoin?.symbol ?? "", codeI: codeIV.image ?? UIImage(), addressString: walletCoin?.address ?? "", amountTipS: "")
    }
}

extension ReceiveViewController : ReciptCreateViewDelegate {
    func getImage(image: UIImage) {
        let title = "Walletverse"
        guard let img: UIImage = UIImage(named: "IconPlaceholder") else {
            return
        }
        let shareItems:Array = [title,image.pngData() ?? img.pngData] as [Any]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
}
