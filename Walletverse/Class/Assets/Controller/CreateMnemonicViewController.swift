//
//  CreateMnemonicViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/8.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import MBProgressHUD
import walletverse_ios_sdk

class CreateMnemonicViewController: BaseViewController {
    
    var name: String?
    var pwdString: String?
    var mnemonicString : String?
    var mnemonicArray : NSArray?
    
    lazy var backV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    var iconIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "AssetsCreateTip"))
    }()
    
    var statusL : UILabel = {
        return CustomView.labelCustom(text: LocalString("assets_create_creating"), font: FontSystem(size: 15), color: Color_091C40, textAlignment: .center)
    }()
    
    var finishIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "AssetsHostSuccess"))
    }()
    
    var finishL : UILabel = {
        return CustomView.labelCustom(text: LocalString("assets_create_success"), font: FontSystemBold(size: 24), color: Color_091C40, textAlignment: .center)
    }()
    
    var backupBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("assets_create_backup"), font: FontSystem(size: 15), color: Color_FFFFFF, cornerRadius: 24, backColor: Color_0072DB_1)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBaseNaviLeft()
        baseNaviTitle.text = LocalString("asserts_host_no_create")
        createWallet()
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func configUI() {
        backV.frame = CGRect(x: 15, y: 0, width: ZSCREENWIDTH - 30, height: 215)
        backV.clipsToBounds = true
        backV.layer.cornerRadius = 4
        baseMainV.addSubview(backV)
        
        iconIV.frame = CGRect(x: (backV.width - 96)/2, y: 96, width: 96, height: 62)
        backV.addSubview(iconIV)
        
        statusL.frame = CGRect(x: 16, y: iconIV.bottom + 25, width: backV.width - 32, height: 20)
        backV.addSubview(statusL)
        
        finishIV.frame = CGRect(x: (backV.width - 54)/2, y: 66, width: 54, height: 54)
        finishIV.isHidden = true
        backV.addSubview(finishIV)
        
        finishL.frame = CGRect(x: 16, y: finishIV.bottom + 24, width: backV.width - 32, height: 33)
        finishL.isHidden = true
        backV.addSubview(finishL)
        
        backupBtn.frame = CGRect(x: 16, y: backV.bottom + 40, width: ZSCREENWIDTH - 32, height: 48)
        backupBtn.addTarget(self, action: #selector(backupBtnClick), for: .touchUpInside)
        baseMainV.addSubview(backupBtn)
        
        statusL.isHidden = false
        iconIV.isHidden = false
        finishL.isHidden = true
        finishIV.isHidden = true
        backupBtn.isHidden = true
    }
    
    func updateUI() {
        statusL.isHidden = true
        iconIV.isHidden = true
        finishL.isHidden = false
        finishIV.isHidden = false
        backupBtn.isHidden = false
    }
    
    func createWallet() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let jsParams = JSCoreParams()
            .put(key: "chainId", value: "0x1") ?? JSCoreParams()
        Walletverse.generateMnemonic(params: jsParams) { (returnData, error) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if let result = returnData {
                self.mnemonicString = result as? String
                self.mnemonicArray = self.mnemonicString?.split(separator: " ") as NSArray?
                self.updateUI()
            } else {
                
            }
        }
    }
    
    @objc func backupBtnClick() {
        if mnemonicArray?.count ?? 0 > 2 {
            let controller = BackupMnemonicViewController()
            controller.name = name
            controller.pwdString = pwdString
            controller.mnemonicString = mnemonicString
            controller.mnemonicArray = mnemonicArray
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

}
