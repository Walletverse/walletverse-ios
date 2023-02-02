//
//  BackupMnemonicViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/8.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

class BackupMnemonicViewController: BaseViewController {
    var name: String?
    var pwdString: String?
    var mnemonicString : String?
    var mnemonicArray : NSArray?
    
    lazy var backupMnemonicView : BackupMnemonicView = {
        let backupV = BackupMnemonicView.init(frame: CGRect(x: 16, y: 0, width: ZSCREENWIDTH - 32, height: 275))
        backupV.clipsToBounds = true
        backupV.layer.cornerRadius = 4
        backupV.configSubviewUI()
        backupV.delegate = self
        backupV.mnemonicArray = mnemonicArray
        return backupV
    }()
    
    lazy var saveBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("assets_create_backup"), font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 24, backColor: Color_0072DB_0)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ZNOTIFICATION.addObserver(self, selector: #selector(screenshots), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        
        initBaseNaviLeft()
        baseNaviTitle.text = LocalString("assets_backup_mnemonic")
    }
    
    override func configUI() {
        baseMainV.addSubview(backupMnemonicView)
        
        saveBtn.frame = CGRect(x: 16, y: backupMnemonicView.bottom + 40, width: ZSCREENWIDTH - 32, height: 48)
        saveBtn.isEnabled = false
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        baseMainV.addSubview(saveBtn)
        
        let tipV = BackupMnemonicSecureView()
        tipV.frame = CGRect(x: 0, y: baseMainV.height - 100 - 25 - ZSCREENBOTTOM, width: ZSCREENWIDTH, height: 100)
        tipV.configSubviewUI()
        tipV.frame = CGRect(x: 0, y: baseMainV.height - tipV.countHeight - 25 - ZSCREENBOTTOM, width: ZSCREENWIDTH, height: tipV.countHeight)
        baseMainV.addSubview(tipV)
    }
    
    override func naviLeftBtnClick() {
        laterBtnClick()
    }
    
    @objc func laterBtnClick() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func screenshots() {
        //        CommonToastView.showToastAction(message: LocalString("AssetsTradingCopy"))
    }
    
    @objc func saveBtnClick() {
        let controller = VertifyMnemonicViewController()
        controller.name = name
        controller.pwdString = pwdString
        controller.mnemonicString = mnemonicString
        controller.mnemonicArray = mnemonicArray
        navigationController?.pushViewController(controller, animated: true)
    }
    
    deinit {
        ZNOTIFICATION.removeObserver(self)
    }
}

extension BackupMnemonicViewController : BackupMnemonicViewDelegate {
    func showBtnDelegate() {
        saveBtn.backgroundColor = Color_0072DB_1
        saveBtn.frame = CGRect(x: 16, y: backupMnemonicView.bottom + 52, width: ZSCREENWIDTH - 32, height: 50)
        saveBtn.isEnabled = true
    }
}
