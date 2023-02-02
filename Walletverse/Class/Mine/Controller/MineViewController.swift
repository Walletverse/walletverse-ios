//
//  MineViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class MineViewController: BaseViewController {
    
    var passwordS : String = ""
    var contentS : String? = ""
    var count = 0
    
    private lazy var mainTableV : UITableView = {
        let tableV = UITableView()
        tableV.backgroundColor = Color_FFFFFF
        tableV.clipsToBounds = true
        tableV.layer.cornerRadius = 4
        tableV.dataSource = self
        tableV.delegate = self
        tableV.alwaysBounceVertical = true
        tableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableV.scrollIndicatorInsets = tableV.contentInset
        tableV.separatorStyle = .none
        tableV.register(cellType: MineTableCell.self)
        return tableV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenNaviLeftBtn()
        baseNaviTitle.text = LocalString("main_tab_mine")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainTableV.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainTableV.reloadData()
    }
    
    override func configUI() {
        mainTableV.frame = CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: baseMainV.height - ZSCREENTABBAR - 15)
        baseMainV.addSubview(mainTableV)
    }
    
    func showPasswordView() {
        let view = InputPasswordView()
        view.delegate = self as InputPasswordViewDelegate
        view.show()
    }
    
    func verifyPassword(pwdString : String?) {
        let password = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
        if stringCompare(password, (pwdString ?? "")) {
            passwordS = pwdString ?? ""
            
            Walletverse.queryIdentities { (result) in
                self.contentS = ""
                if let identities = result {
                    if identities.count > 0 {
                        self.count = identities.count
                        for identity in identities {
                            let walletCoinModel = Walletverse.getWalletCoinModel()
                            walletCoinModel.wid = identity.wid
                            Walletverse.queryWalletCoins(walletCoinModel: walletCoinModel) { (result) in
                                if let walletArray = result {
                                    if walletArray.count > 0 {
                                        for wallet in walletArray {
                                            if wallet.type == "CHAIN" {
                                                let decodeParams = JSCoreParams().put(key: "message", value: wallet.privateKey ?? "")?.put(key: "password", value: self.passwordS) ?? JSCoreParams()
                                                Walletverse.decodeMessage(params: decodeParams) { (returnData, error) in
                                                    self.count = self.count - 1
                                                    if let privateKey = returnData {
                                                        if (self.contentS ?? "").isEmpty {
                                                            self.contentS = "\(identity.name ?? "")@\(wallet.contract ?? ""):\(privateKey)"
                                                        } else {
                                                            self.contentS = "\(self.contentS ?? "")\n\(identity.name ?? "")@\(wallet.contract ?? ""):\(privateKey)"
                                                        }
                                                        if self.count == 0 {
                                                            let alertV = CustomAlertView.init(title: "Walletverse", message: self.contentS, preferredStyle: UIAlertController.Style.alert)
                                                            alertV.addAction(UIAlertAction.init(title: "Copy", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                                                                let pasteboard = UIPasteboard.general
                                                                pasteboard.string =  self.contentS
                                                                CommonToastView.showToastAction(message: LocalString("common_already_copy"))
                                                            }))
                                                            self.present(alertV, animated: true, completion: nil)
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }

                        }
                    }
                }
            }
            
        } else {
            let alertV = CustomAlertView.init(title: "", message: LocalString("assets_host_password_error"), preferredStyle: UIAlertController.Style.alert)
            alertV.addAction(UIAlertAction.init(title: LocalString("assets_inpput_again"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                self.showPasswordView()
            }))
            self.present(alertV, animated: true, completion: nil)
        }
    }
}

extension MineViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MineTableCell.self)
        switch indexPath.row {
        case 0:
            cell.iconIV.image = UIImage(named: "MineSet")
            cell.nameL.text = LocalString("mine_set")
            break
        case 1:
            cell.iconIV.image = UIImage(named: "MineExport")
            cell.nameL.text = LocalString("mine_export")
        
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let controller = MineSetViewController()
            navigationController?.pushViewController(controller, animated: true)
            break
        case 1:
            showPasswordView()
            break
        default:
            break
        }
    }
    
}

extension MineViewController : InputPasswordViewDelegate {
    func inputPasswordDelegate(pwd: String) {
        verifyPassword(pwdString : pwd)
    }
}
