//
//  ChainTokenViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/11.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class ChainTokenViewController: BaseViewController, ChainTokenTableCellDelegate {
    var identityModel: IdentityModel?
    var chainCoin: CoinModel?
    
    var walletArray : [WalletCoinModel]?
    var coinArray: [Coin]? = [Coin]()
    
    var currentPage = 1
    
    lazy var searchBtn : UIButton = {
        return CustomView.buttonCustom(normalImage: UIImage(named: "icon_search"), selectedImage: UIImage(named: "icon_search"))
    }()
    
    lazy var emptyDataView : EmptyDataView = {
        let emptyDataView = EmptyDataView.init()
        emptyDataView.frame = CGRect.init(x: mainTableV.centerX - emptyDataView.width/2, y: mainTableV.centerY - emptyDataView.height/2, width: emptyDataView.width, height: emptyDataView.height)
        return emptyDataView
    }()

    private lazy var mainTableV : UITableView = {
        let tableV = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: baseMainV.height - ZSCREENBOTTOM))
        tableV.clipsToBounds = true
        tableV.layer.cornerRadius = 4
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
        tableV.uFoot = URefreshFooter { [weak self] in
            self?.loadMore()
        }
        tableV.register(cellType: ChainTokenTableCell.self)
        return tableV
    }()
        
    private func loadData() {
        mainTableV.uHead.endRefreshing()
        mainTableV.uempty?.allowShow = true
        
        currentPage = 1
        getData()
    }
        
    private func loadMore() {
        mainTableV.uFoot.endRefreshing()
        mainTableV.uempty?.allowShow = true
    
        currentPage = currentPage + 1
        getData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBaseNaviLeft()
        baseNaviTitle.text = chainCoin?.symbol ?? ""
        
        searchBtn.frame = CGRect(x: ZSCREENWIDTH - 50, y: ZSCREENNAVIBAR - 44, width: 44, height: 44)
        searchBtn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        baseNaviBar.addSubview(searchBtn)
        
        baseMainV.addSubview(emptyDataView)
        baseMainV.addSubview(mainTableV)
    }
    
    override func configData() {
        currentPage = 1
        let walletCoinModel = Walletverse.getWalletCoinModel()
        walletCoinModel.wid = identityModel?.wid ?? ""
        Walletverse.queryWalletCoins(walletCoinModel: walletCoinModel) { (result) in
            if let walletArray = result {
                if walletArray.count > 0 {
                    self.walletArray = walletArray
                }
            }
            self.getData()
        }
    }
    
    func getData() {
        let tokenParams = TokenParams(page: "\(currentPage)", size: "50", chainId: chainCoin?.chainId)
        Walletverse.getTokenList(params: tokenParams) { (result) in
            if let tokenArray = result {
                if self.currentPage == 1 {
                    self.coinArray?.removeAll()
                    for var coin in tokenArray {
                        for walletCoin in self.walletArray ?? [WalletCoinModel]() {
                            if walletCoin.contractAddress == coin.contractAddress {
                                coin.isAdd = true
                            }
                        }
                        self.coinArray?.append(coin)
                    }
                } else {
                    for var coin in tokenArray {
                        for walletCoin in self.walletArray ?? [WalletCoinModel]() {
                            if walletCoin.contractAddress == coin.contractAddress {
                                coin.isAdd = true
                            }
                        }
                        self.coinArray?.append(coin)
                    }
                }
                
                self.mainTableV.reloadData()
            }
        }
    }
    
    @objc func searchBtnClick() {
        let controller = SearchTokenViewController()
        controller.identityModel = self.identityModel
        controller.chainCoin = chainCoin
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension ChainTokenViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.coinArray?.count ?? 0 > 0 {
            emptyDataView.isHidden = true
        } else {
            emptyDataView.isHidden = false
        }
        return self.coinArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ChainTokenTableCell.self)
        if let coinModel = coinArray?[indexPath.row] {
            cell.setCoinModel(coinModel: coinModel)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func addToken(coin: Coin?) {
        let password = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
        if password?.count ?? 0 > 0 {
            let walletCoin = Walletverse.getWalletCoinModel()
            walletCoin.updateFromCoin(coin: coin ?? Coin())
            let saveCoinParams = SaveCoinParams(wid: identityModel?.wid ?? "", pin: password, walletCoinModel: walletCoin)
            Walletverse.saveWalletCoin(saveCoinParams: saveCoinParams) { (result) in
                if (result) {
                    CommonToastView.showToastAction(message: LocalString("asserts_add_success"))
                    self.configData()
                } else {
                    CommonToastView.showToastAction(message: LocalString("asserts_add_failed"))
                }
            }
        }
    }
    
    func addChainAndToken(coin: Coin?) {
        let password = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
        if password?.count ?? 0 > 0 {
            let walletCoin = Walletverse.getWalletCoinModel()
            walletCoin.updateFromCoinModel(coin: chainCoin ?? Walletverse.getCoinModel())
            let saveCoinParams = SaveCoinParams(wid: identityModel?.wid ?? "", pin: password, walletCoinModel: walletCoin)
            Walletverse.saveWalletCoin(saveCoinParams: saveCoinParams) { (result) in
                if (result) {
                    self.addToken(coin: coin)
                } else {
                    CommonToastView.showToastAction(message: LocalString("asserts_add_failed"))
                }
            }
        }
    }
    
    func addChainTokenDelegate(coin: Coin?) {
        if let coinModel = coin {
            var isHasChain = false
            for wallet in self.walletArray ?? [WalletCoinModel]() {
                if wallet.chainId == coinModel.chainId {
                    isHasChain = true
                    break
                }
            }
            if isHasChain {
                self.addToken(coin: coinModel)
            } else {
                let message = String(format: LocalString("asserts_add_chain_tip"), coin?.chainName ?? "")
                
                let alertV = CustomAlertView.init(title: "Walletverse", message: message, preferredStyle: UIAlertController.Style.alert)
                alertV.addAction(UIAlertAction.init(title: LocalString("confirm"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    self.addChainAndToken(coin: coinModel)
                }))
                alertV.addAction(UIAlertAction.init(title: LocalString("cancel"), style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
                    
                }))
                self.present(alertV, animated: true, completion: nil)
            }
        }
    }
    
}
