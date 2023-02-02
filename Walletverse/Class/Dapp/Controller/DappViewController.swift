//
//  DappViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import MBProgressHUD
import walletverse_ios_sdk

class DappViewController: BaseViewController {
    var currentIdentity : IdentityModel?
    var walletCoinArray : [WalletCoinModel]?
    var chainCoinArray : [CoinModel]?
    var addCoin : CoinModel?
    
    var dappList : Array<DappModel>? = [DappModel]()
    
    lazy var titleL : UILabel = {
        return CustomView.labelCustom(text: LocalString("main_tab_finds"), font: FontSystem(size: 18), color: Color_333333)
    }()
    
    lazy var emptyDataView : EmptyDataView = {
        let emptyDataView = EmptyDataView.init()
        emptyDataView.frame = CGRect.init(x: mainTableV.centerX - emptyDataView.width/2, y: mainTableV.centerY - emptyDataView.height/2, width: emptyDataView.width, height: emptyDataView.height)
        return emptyDataView
    }()

    private lazy var mainTableV : UITableView = {
        let tableV = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: baseMainV.height - ZTABBARHEIGHT - ZSCREENBOTTOM))
        tableV.backgroundColor = UIColor.clear
        tableV.dataSource = self
        tableV.delegate = self
        tableV.alwaysBounceVertical = true
        tableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableV.scrollIndicatorInsets = tableV.contentInset
        tableV.separatorStyle = .none
        tableV.register(cellType: DappTableCell.self)
        return tableV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenNaviLeftBtn()
        
        titleL.frame = CGRect(x: 15, y: ZSCREENNAVIBAR - 44, width: 200, height: 44)
        baseNaviBar.addSubview(titleL)
        
        initConfigData()
    }
    
    override func configUI() {
        baseMainV.addSubview(emptyDataView)
        baseMainV.addSubview(mainTableV)
    }
    
    func initConfigData() {
        let dappModel1 = DappModel(wid: UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET) as? String, name: "ETH-UniSwap", url: "https://uniswap.token.im/", chain: "ETH")
        dappList?.append(dappModel1)
        
        let dappModel2 = DappModel(wid: UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET) as? String, name: "BNB-Pancake", url: "https://pancakeswap.finance/", chain: "BNB")
        dappList?.append(dappModel2)
        
        
        let dappModel3 = DappModel(wid: UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET) as? String, name: "MAP-Map Staking", url: "https://staking.mapprotocol.io/", chain: "MAP")
        dappList?.append(dappModel3)
        
        let dappModel4 = DappModel(wid: UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET) as? String, name: "FTM-Jetswap", url: "https://fantom.jetswap.finance/", chain: "FTM")
        dappList?.append(dappModel4)
        
//        let dappModel5 = DappModel(wid: UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET) as? String, name: "KCS-", url: "https://www.baidu.com", chain: "KCS")
//        dappList?.append(dappModel5)

        let dappModel6 = DappModel(wid: UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET) as? String, name: "CUBE-CAPRICORN Swap", url: "https://www.capricorn.finance/swap", chain: "CUBE")
        dappList?.append(dappModel6)
        
        let dappModel7 = DappModel(wid: UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET) as? String, name: "OKT-OKT Swap", url: "https://www.okx.com/web3/dex?inputChain=66&inputCurrency=OKT&outputChain=66&outputCurrency=0x382bb369d343125bfb2117af9c149795c6c65c50", chain: "OKT")
        dappList?.append(dappModel7)
        
        let dappModel8 = DappModel(wid: UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET) as? String, name: "KLAY-KlaySwap", url: "https://klayswap.com/exchange/swap", chain: "KLAY")
        dappList?.append(dappModel8)
        
        let dappModel9 = DappModel(wid: UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET) as? String, name: "TRUE-Staking", url: "https://staking.truedapp.network/#/?header=no", chain: "TRUE")
        dappList?.append(dappModel9)
        
        let dappModel10 = DappModel(wid: UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET) as? String, name: "AVAX-Tokenbb", url: "https://tokenbb.com/batch-transfer?utm_source=dapp_com", chain: "AVAX")
        dappList?.append(dappModel10)
        
        let dappModel11 = DappModel(wid: UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET) as? String, name: "MATIC-QUICKSWAP", url: "https://quickswap.exchange/#/swap", chain: "MATIC")
        dappList?.append(dappModel11)
        
        let dappModel12 = DappModel(wid: UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET) as? String, name: "ABEY-RevoMarketplace", url: "https://abeynft.revoland.com/RevoMarketplace", chain: "ABEY")
        dappList?.append(dappModel12)
        
        self.mainTableV.reloadData()
        
        Walletverse.queryChainCoins() { (result) in
            if let coinArray = result {
                self.chainCoinArray = coinArray
            }
        }
    }
}

extension DappViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dappList?.count ?? 0 > 0 {
            emptyDataView.isHidden = true
        } else {
            emptyDataView.isHidden = false
        }
        return self.dappList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DappTableCell.self)
        cell.configData(dappModel: dappList?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentWid = UserDefaultUtil.getValue(key: ZUSERDEFAULT_CURRENTWALLET)
        let identity = Walletverse.getIdentityModel()
        identity.wid = currentWid as? String ?? ""
        Walletverse.queryIdentity(identityModel: identity) { (result) in
            if let identityModel = result {
                self.currentIdentity = identityModel
            }
        }
        
        let dappModel = dappList?[indexPath.row]
        let contract = dappModel?.chain
        
        let walletCoinModel = Walletverse.getWalletCoinModel()
        walletCoinModel.wid = currentWid as? String ?? ""
        Walletverse.queryWalletCoins(walletCoinModel: walletCoinModel) { (result) in
            if let walletArray = result {
                if walletArray.count > 0 {
                    self.walletCoinArray = walletArray
                    var isAdd = false
                    for walletCoin in self.walletCoinArray ?? [WalletCoinModel]() {
                        if (walletCoin.contract == contract && walletCoin.symbol == contract) {
                            isAdd = true
                            break
                        }
                    }
                    if isAdd == true {
                        let controller = DappWebViewController()
                        controller.dappModel = self.dappList?[indexPath.row]
                        self.navigationController?.pushViewController(controller, animated: true)
                    } else {
                        for coin in self.chainCoinArray ?? [CoinModel]() {
                            if coin.contract == contract {
                                self.addCoin = coin
                            }
                        }
    
                        let message = String(format: LocalString("asserts_add_chain_tip"), contract ?? "")
                        let alertV = CustomAlertView.init(title: "Walletverse", message: message, preferredStyle: UIAlertController.Style.alert)
                        alertV.addAction(UIAlertAction.init(title: LocalString("confirm"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                            let controller = ChainTokenViewController()
                            controller.identityModel = self.currentIdentity
                            controller.chainCoin = self.addCoin
                            self.navigationController?.pushViewController(controller, animated: true)
                        }))
                        alertV.addAction(UIAlertAction.init(title: LocalString("cancel"), style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
                            
                        }))
                        self.present(alertV, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}
