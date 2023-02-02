//
//  AssetsHostViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class AssetsHostViewController: BaseViewController {
    
    var currentIdentity : IdentityModel?
    var walletCoinArray : [WalletCoinModel]?
    var chainCoinArray : [CoinModel]?
    
    lazy var titleL : UILabel = {
        return CustomView.labelCustom(text: LocalString("main_tab_assets"), font: FontSystem(size: 18), color: Color_091C40,textAlignment: .center)
    }()
    
    lazy var helpBtn : UIButton = {
        return CustomView.buttonCustom(image: UIImage(named: "AssetsHostHelp"))
    }()
    
    lazy var addBtn : UIButton = {
        return CustomView.buttonCustom(normalImage: UIImage(named: "AssetTokenAdd"), selectedImage: UIImage(named: "AssetTokenAdd"))
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
        tableV.uHead = URefreshHeader { [weak self] in
            self?.loadData()
        }
        tableV.register(cellType: AssetsWalletTableCell.self)
        return tableV
    }()
    
    private func loadData() {
        mainTableV.uHead.endRefreshing()
        mainTableV.uempty?.allowShow = true
        updateData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        hiddenNaviLeftBtn()
        
        titleL.frame = CGRect(x: 50, y: ZSCREENNAVIBAR - 44, width: ZSCREENWIDTH - 100, height: 44)
        baseNaviBar.addSubview(titleL)
        
        helpBtn.frame = CGRect(x: 0, y: ZSCREENNAVIBAR - 44, width: 44, height: 44)
        helpBtn.addTarget(self, action: #selector(helpBtnClick), for: .touchUpInside)
        baseNaviBar.addSubview(helpBtn)
        
        
        addBtn.frame = CGRect(x: ZSCREENWIDTH - 44, y: ZSCREENNAVIBAR - 44, width: 44, height: 44)
        addBtn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        baseNaviBar.addSubview(addBtn)
        
        mainTableV.frame = CGRect.init(x: 0, y: 1, width: ZSCREENWIDTH, height: baseMainV.height - ZSCREENTABBAR - 5)
        emptyDataView.frame = CGRect.init(x: mainTableV.centerX - emptyDataView.width/2, y: mainTableV.centerY - emptyDataView.height/2, width: emptyDataView.width, height: emptyDataView.height)
        baseMainV.addSubview(emptyDataView)
        baseMainV.addSubview(mainTableV)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configData()
    }
    
    override func configData() {
        let currentWid = UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET)
        let identity = Walletverse.getIdentityModel()
        identity.wid = currentWid as? String ?? ""
        Walletverse.queryIdentity(identityModel: identity) { (result) in
            if let identityModel = result {
                self.currentIdentity = identityModel
            }
        }
        
        let walletCoinModel = Walletverse.getWalletCoinModel()
        walletCoinModel.wid = currentWid as? String ?? ""
        Walletverse.queryWalletCoins(walletCoinModel: walletCoinModel) { (result) in
            if let walletArray = result {
                if walletArray.count > 0 {
                    self.walletCoinArray = walletArray
                    var count = walletArray.count
                    for walletCoin in self.walletCoinArray ?? [WalletCoinModel]() {
//                        let balanceParams = JSCoreParams()
//                            .put(key: "chainId", value: walletCoin.chainId ?? "")?
//                            .put(key: "address", value: walletCoin.address ?? "")?
//                            .put(key: "contractAddress", value: walletCoin.contractAddress ?? "") ?? JSCoreParams()
                        let coinBalance = CoinBalance(chainId: walletCoin.chainId ?? "", address:  walletCoin.address ?? "", contractAddress: walletCoin.contractAddress ?? "")
                        Walletverse.balance(params: coinBalance) { (returnData) in
                            if let result = returnData {
                                let balanceS = result as? String ?? ""
                                let balance = String(format: "%.7F",(Double(balanceS) ?? 0))
                                walletCoin.balance = balance
                            }
                            
                            let priceParams = GetPriceParams(symbol: walletCoin.symbol ?? "", contractAddress: walletCoin.contractAddress ?? "")
                            Walletverse.getPrice(params: priceParams) { (returnData) in
                                count = count - 1
                                
                                if let result = returnData {
                                    let priceS = result as? String ?? ""
                                    let price = String(format: "%.7F",(Double(priceS) ?? 0))
                                    walletCoin.price = price
                                    
                                    if (walletCoin.balance ?? "").isEmpty == false {
                                        let totalPrice = (Double(walletCoin.price ?? "0") ?? 0) * (Double(walletCoin.balance ?? "0") ?? 0)
                                        walletCoin.totalPrice = String(format: "%.7F",totalPrice)
                                    }
                                    
                                }
                                
                                if count == 0 {
                                    self.mainTableV.reloadData()
                                }
                            }
                        }
                    }
                    
                    self.mainTableV.reloadData()
                }
            }
        }
    }
    
    func updateData() {
        let currentWid = UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET)
        let identity = Walletverse.getIdentityModel()
        identity.wid = currentWid as? String ?? ""
        Walletverse.queryIdentity(identityModel: identity) { (result) in
            if let identityModel = result {
                self.currentIdentity = identityModel
            }
        }
        
        let walletCoinModel = Walletverse.getWalletCoinModel()
        walletCoinModel.wid = currentWid as? String ?? ""
        Walletverse.queryWalletCoins(walletCoinModel: walletCoinModel) { (result) in
            if let walletArray = result {
                if walletArray.count > 0 {
                    self.walletCoinArray = walletArray
                    var count = walletArray.count
                    for walletCoin in self.walletCoinArray ?? [WalletCoinModel]() {
//                        let balanceParams = JSCoreParams()
//                            .put(key: "chainId", value: walletCoin.chainId ?? "")?
//                            .put(key: "address", value: walletCoin.address ?? "")?
//                            .put(key: "contractAddress", value: walletCoin.contractAddress ?? "") ?? JSCoreParams()
                        let coinBalance = CoinBalance(chainId: walletCoin.chainId ?? "", address:  walletCoin.address ?? "", contractAddress: walletCoin.contractAddress ?? "")
                        Walletverse.balance(params: coinBalance) { (returnData) in
                            if let result = returnData {
                                let balanceS = result as? String ?? ""
                                let balance = String(format: "%.7F",(Double(balanceS) ?? 0))
                                walletCoin.balance = balance
                            }
                            
                            let priceParams = GetPriceParams(symbol: walletCoin.symbol ?? "", contractAddress: walletCoin.contractAddress ?? "")
                            Walletverse.getPrice(params: priceParams) { (returnData) in
                                count = count - 1
                                
                                if let result = returnData {
                                    let priceS = result as? String ?? ""
                                    let price = String(format: "%.7F",(Double(priceS) ?? 0))
                                    walletCoin.price = price
                                    
                                    if (walletCoin.balance ?? "").isEmpty == false {
                                        let totalPrice = (Double(walletCoin.price ?? "0") ?? 0) * (Double(walletCoin.balance ?? "0") ?? 0)
                                        walletCoin.totalPrice = String(format: "%.7F",totalPrice)
                                    }
                                    
                                }
                                
                                if count == 0 {
                                    self.mainTableV.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    @objc func helpBtnClick() {
        let assetsMenuLeftView = AssetsMenuLeftView()
        assetsMenuLeftView.delegate = self
        assetsMenuLeftView.currentIdentity = currentIdentity
        assetsMenuLeftView.show()
    }
    
    @objc func addBtnClick() {
        Walletverse.queryChainCoins() { (result) in
            if let coinArray = result {
                self.chainCoinArray = coinArray
                let view = SelectChainView()
                view.delegate = self
                view.setData(coinArray : coinArray)
                view.show()
            }
        }
    }
    
    deinit {
        ZNOTIFICATION.removeObserver(self)
    }

}

extension AssetsHostViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if walletCoinArray?.count ?? 0 > 0 {
            emptyDataView.isHidden = true
        } else {
            emptyDataView.isHidden = false
        }
        return walletCoinArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AssetsWalletTableCell.self)
        cell.backgroundColor = UIColor.clear
        let walletCoin = self.walletCoinArray?[indexPath.row]
        cell.setWalletCoin(walletCoin: walletCoin,isShow : true)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if walletCoinArray?.count ?? 0 > indexPath.row {
            let walletCoin = walletCoinArray?[indexPath.row]
            let controller = TokenViewController()
            controller.identityModel = currentIdentity
            controller.walletCoin = walletCoin
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension AssetsHostViewController : AssetsMenuLeftViewDelegate {
    func selectWalletDelegate(identityModel: IdentityModel?) {
        if identityModel != nil {
            currentIdentity = identityModel
            UserDefaultUtil.setValue(value: identityModel?.wid ?? "", key: ZUSERDEFAULT_CURRENTWALLET)
            configData()
        }
    }
    
    func manageWalletDelegate(identityModel: IdentityModel?) {
        let controller = ChainManageViewController()
        controller.identityModel = identityModel
        navigationController?.pushViewController(controller, animated: true)
    }

    func addWalletDelegate() {
        let controller = Web2ViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension AssetsHostViewController : SelectChainViewDelegate {
    func selectChainModel(coinModel: CoinModel?) {
        if let coin = coinModel {
            let controller = ChainTokenViewController()
            controller.identityModel = self.currentIdentity
            controller.chainCoin = coin
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
