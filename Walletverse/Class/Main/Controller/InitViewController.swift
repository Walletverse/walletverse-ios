//
//  InitViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit
import Reachability
import walletverse_ios_sdk

class InitViewController : BaseViewController {
    fileprivate var reachability: Reachability?
    
    var language = Language.EN
    var currency = Currency.USD
    var cs = Unit.USD
    
    var isInit = false
    
    var networkTrue = false
    var tapType = 0
    
    lazy var backImageView : UIImageView = {
        let backImageView = UIImageView()
        return backImageView
    }()
    
    lazy var logoImageView : UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var web2Btn : UIButton = {
        return CustomView.buttonCustom(text: "Web2.0", font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 22, backColor: Color_0072DB_0)
    }()
    
    lazy var web3Btn : UIButton = {
        return CustomView.buttonCustom(text: "Web3.0", font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 22, backColor: Color_0072DB_0)
    }()
    
    lazy var developBtn : UIButton = {
        return CustomView.buttonCustom(text: "Develop", font: FontSystem(size: 16), color: Color_FFFFFF, cornerRadius: 22, backColor: Color_0072DB_0)
    }()
    
    var commonLoadView : CommonLoadView?
    
    override func viewDidLoad() {
        isShowNaviBar = false
        super.viewDidLoad()
        
        checkNetworkState { isTrue in
            if isTrue {
                self.initWalletverse()
            } else {
                CommonToastView.showToastAction(message: LocalString("network_failed"))
            }
        }
    }
    
    fileprivate func checkNetworkState(action :@escaping ((Bool)->())) {
        reachability = try! Reachability()
        reachability?.whenReachable = { reach in
            switch reach.connection {
            case .wifi:
                self.networkTrue = true
                action(true)
                print("Reachable via WiFi")
            case .cellular:
                self.networkTrue = true
                action(true)
                print("Reachable via Cellular")
            case .unavailable, .none:
                fallthrough
            default:
                self.networkTrue = false
                action(false)
                print("Network not reachable")
            }
        }
        reachability?.whenUnreachable = { _ in
            print("Not reachable")
            self.networkTrue = false
            action(false)
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            self.networkTrue = false
            action(false)
            print("Unable to start notifier")
        }
    }
    
    @objc func delayExecution() {
        self.commonLoadView?.dismiss()
        if tapType == 1 {
            Walletverse.queryIdentities { (identityArray) in
                if identityArray?.count ?? 0 > 0 {
                    let controller = MainViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                } else {
                    let controller = Web2ViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        } else if tapType == 2 {
            Walletverse.queryIdentities { (identityArray) in
                if identityArray?.count ?? 0 > 0 {
                    let controller = MainViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                } else {
                    let controller = Web3ViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        } else if tapType == 3 {
            let controller = DevelopViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func initWalletverse() {
        commonLoadView = CommonLoadView()
        commonLoadView?.show()
        self.perform(#selector(delayExecution), with: nil, afterDelay: 5)
        
        if isInit == true {
            
        } else {
            isInit = true
            language = LocalUtil.shareInstance.getCurrentLanguageEnum()
            currency = CurrencyUtil().getCurrentCurrencyEnum()
            cs = UnitUtil().getCurrentUnitEnum()
            
            let userConfig = UserConfig()
            userConfig.uuid = Constant_UUID
            userConfig.language = language
            userConfig.currency = currency
            userConfig.cs = cs
            Walletverse.install(appId: "97a183f8e0fd9f0629d30ceea2105dc0", appKey: "231fff545322962d9278c19de7f80180", userConfig: userConfig) { (result) in
                print(result)
            }
        }
    }
    
    override func configUI() {
        backImageView.frame = CGRect(x: 0, y: 0, width: baseMainV.width, height: baseMainV.height)
        backImageView.image = UIImage.init(named: "init_back")
        baseMainV.addSubview(backImageView)
        
        logoImageView.frame = CGRect(x:baseMainV.width/4, y: baseMainV.width/4, width: baseMainV.width/2, height: (baseMainV.width/2)/393*327)
        logoImageView.image = UIImage.init(named: "init_logo")
        baseMainV.addSubview(logoImageView)
        
        web2Btn.frame = CGRect(x: 20, y: logoImageView.bottom + 200, width: baseMainV.width - 40, height: 44)
        web2Btn.layer.borderWidth = 2
        web2Btn.layer.borderColor = Color_FFFFFF.cgColor
        web2Btn.addTarget(self, action: #selector(web2BtnClick), for: .touchUpInside)
        baseMainV.addSubview(web2Btn)
        
        web3Btn.frame = CGRect(x: 20, y: web2Btn.bottom + 20, width: baseMainV.width - 40, height: 44)
        web3Btn.layer.borderWidth = 2
        web3Btn.layer.borderColor = Color_FFFFFF.cgColor
        web3Btn.addTarget(self, action: #selector(web3BtnClick), for: .touchUpInside)
        baseMainV.addSubview(web3Btn)
        
        developBtn.frame = CGRect(x: 20, y: web3Btn.bottom + 20, width: baseMainV.width - 40, height: 44)
        developBtn.layer.borderWidth = 2
        developBtn.layer.borderColor = Color_FFFFFF.cgColor
        developBtn.addTarget(self, action: #selector(developBtnClick), for: .touchUpInside)
        baseMainV.addSubview(developBtn)
        
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func web2BtnClick() {
        tapType = 1
        if isInit == false {
            checkNetworkState { isTrue in
                if isTrue {
                    self.initWalletverse()
                } else {
                    CommonToastView.showToastAction(message: LocalString("network_failed"))
                }
            }
        } else {
            Walletverse.queryIdentities { (identityArray) in
                if identityArray?.count ?? 0 > 0 {
                    let controller = MainViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                } else {
                    let controller = Web2ViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    @objc func web3BtnClick() {
        tapType = 2
        if isInit == false {
            checkNetworkState { isTrue in
                if isTrue {
                    self.initWalletverse()
                } else {
                    CommonToastView.showToastAction(message: LocalString("network_failed"))
                }
            }
        } else {
            Walletverse.queryIdentities { (identityArray) in
                if identityArray?.count ?? 0 > 0 {
                    let controller = MainViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                } else {
                    let controller = Web3ViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    @objc func developBtnClick() {
        tapType = 3
        if isInit == false {
            checkNetworkState { isTrue in
                if isTrue {
                    self.initWalletverse()
                } else {
                    CommonToastView.showToastAction(message: LocalString("network_failed"))
                }
            }
        } else {
            let controller = DevelopViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
