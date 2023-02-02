//
//  ChainManageViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/10.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class ChainManageViewController: BaseViewController, ChainManageTableCellDelegate {
    
    var identityModel: IdentityModel?
    var walletCoinArray : [WalletCoinModel]?
    var chainCoinArray : [WalletCoinModel]? = [WalletCoinModel]()
    
    var commonLoadView : CommonLoadView?
    
    lazy var manageBtn : UIButton = {
        return CustomView.buttonCustom(normalImage: UIImage(named: "AssetWalletSet"), selectedImage: UIImage(named: "AssetWalletSet"))
    }()
    
    lazy var emptyDataView : EmptyDataView = {
        let emptyDataView = EmptyDataView.init()
        emptyDataView.frame = CGRect.init(x: mainTableV.centerX - emptyDataView.width/2, y: mainTableV.centerY - emptyDataView.height/2, width: emptyDataView.width, height: emptyDataView.height)
        return emptyDataView
    }()
    
    private lazy var mainTableV : UITableView = {
        let tableV = UITableView.init()
        tableV.backgroundColor = UIColor.clear
        tableV.dataSource = self
        tableV.delegate = self
        tableV.alwaysBounceVertical = true
        tableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableV.scrollIndicatorInsets = tableV.contentInset
        tableV.separatorStyle = .none
        tableV.register(cellType: ChainManageTableCell.self)
        return tableV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBaseNaviLeft()
        baseNaviTitle.text = LocalString("asserts_chain_manage")
        
        manageBtn.frame = CGRect(x: ZSCREENWIDTH - 50, y: ZSCREENNAVIBAR - 44, width: 44, height: 44)
        manageBtn.addTarget(self, action: #selector(manageBtnClick), for: .touchUpInside)
        baseNaviBar.addSubview(manageBtn)
        
        mainTableV.frame = CGRect.init(x: 0, y: 1, width: ZSCREENWIDTH, height: baseMainV.height - ZSCREENTABBAR - 5)
        emptyDataView.frame = CGRect.init(x: mainTableV.centerX - emptyDataView.width/2, y: mainTableV.centerY - emptyDataView.height/2, width: emptyDataView.width, height: emptyDataView.height)
        baseMainV.addSubview(emptyDataView)
        baseMainV.addSubview(mainTableV)
    }
    
    override func configData() {
        let walletCoinModel = Walletverse.getWalletCoinModel()
        walletCoinModel.wid = identityModel?.wid
        Walletverse.queryWalletCoins(walletCoinModel: walletCoinModel) { (result) in
            if let walletArray = result {
                if walletArray.count > 0 {
                    self.walletCoinArray = walletArray
                    self.chainCoinArray?.removeAll()
                    for wallet in walletArray {
                        if wallet.type == "CHAIN" {
                            self.chainCoinArray?.append(wallet)
                        }
                    }
                    self.mainTableV.reloadData()
                }
            }
        }
    }
    
    @objc func manageBtnClick() {
        let controller = WalletManageViewController()
        controller.identityModel = identityModel
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ChainManageViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chainCoinArray?.count ?? 0 > 0 {
            emptyDataView.isHidden = true
        } else {
            emptyDataView.isHidden = false
        }
        return chainCoinArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ChainManageTableCell.self)
        cell.backgroundColor = UIColor.clear
        let walletCoin = self.chainCoinArray?[indexPath.row]
        cell.setWalletCoin(walletCoin: walletCoin)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func hideWalletDelegate(walletCoin: WalletCoinModel?) {
        let alertSheet = UIAlertController(title: LocalString("asserts_hide"), message: nil, preferredStyle: .actionSheet)
        let idAction = UIAlertAction(title: LocalString("confirm"), style: .default, handler: {
            action in
            
            self.commonLoadView = CommonLoadView()
            self.commonLoadView?.show()
            
            Walletverse.queryWalletCoins(walletCoinModel: walletCoin ?? Walletverse.getWalletCoinModel()) { (result) in
                if let walletArray = result {
                    var count = walletArray.count
                    for wallet in walletArray {
                        if walletCoin?.chainId == wallet.chainId {
                            Walletverse.deleteWalletCoin(walletCoinModel: wallet) { (result) in
                                count = count - 1
                                if count == 0 {
                                    self.commonLoadView?.dismiss()
                                    self.configData()
                                }
                            }
                        } else {
                            count = count - 1
                        }
                    }
                }
            }
        })
        let cancelAction = UIAlertAction(title: LocalString("cancel"), style: .cancel, handler: {
            action in
            
        })
        alertSheet.addAction(idAction)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true, completion: nil)
    }
}
