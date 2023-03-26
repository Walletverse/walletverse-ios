//
//  NftViewController.swift
//  Walletverse
//
//  Created by Kylin on 2023/3/25.
//  Copyright © 2023 marcopolo. All rights reserved.
//

import Foundation
import MBProgressHUD
import walletverse_ios_sdk

class NftViewController: BaseViewController {
    var currentIdentity : IdentityModel?
    var walletCoinArray : [WalletCoinModel]?
    var chainCoinArray : [CoinModel]?
    var addCoin : CoinModel?
    
    var nftList : Array<NftModel>? = [NftModel]()
    
    lazy var titleL : UILabel = {
        return CustomView.labelCustom(text: LocalString("main_tab_nfts"), font: FontSystem(size: 18), color: Color_333333)
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
        tableV.register(cellType: NftTableCell.self)
        return tableV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenNaviLeftBtn()
        
        titleL.frame = CGRect(x: 15, y: ZSCREENNAVIBAR - 44, width: 200, height: 44)
        baseNaviBar.addSubview(titleL)
        
        initConfigData()
        initNftList()
    }
    
    override func configUI() {
        baseMainV.addSubview(emptyDataView)
        baseMainV.addSubview(mainTableV)
    }
    
    func initConfigData() {
        self.mainTableV.reloadData()
        
        Walletverse.queryChainCoins() { (result) in
            if let coinArray = result {
                self.chainCoinArray = coinArray
            }
        }
    }
    
    func initNftList() {
        let nftItemsParams = NftItemsParams(chainId: "0x58f8", address: "0x97bc095c706Ab7b300B88fD6255CaD557c1a5b32", contractAddress: "0x8b6d309d2a68a4bdd6ead9f12bc44bc4baa0f8c8")
        Walletverse.getNftItems(params: nftItemsParams) { (result) in
            if let nftArray = result {
                self.nftList = nftArray
                self.mainTableV.reloadData()
            }
        }
    }
}

extension NftViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.nftList?.count ?? 0 > 0 {
            emptyDataView.isHidden = true
        } else {
            emptyDataView.isHidden = false
        }
        return self.nftList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NftTableCell.self)
        cell.configData(nftModel: nftList?[indexPath.row])
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
        
        let nftModel = nftList?[indexPath.row]
        let contract = "ETH"
        
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
                        let controller = NftDetailViewController()
                        controller.nftModel = self.nftList?[indexPath.row]
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
