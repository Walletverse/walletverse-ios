//
//  SearchTokenViewController.swift
//  Walletverse
//
//  Created by Kylin on 2022/10/26.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class SearchTokenViewController: BaseViewController, ChainTokenTableCellDelegate {
    var identityModel: IdentityModel?
    var chainCoin: CoinModel?
    
    var walletArray : [WalletCoinModel]? = [WalletCoinModel]()
    var coinArray: [Coin]? = [Coin]()
    
    var searchStr : String? = ""
    
    lazy var searchV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var searchTF : UITextField = {
        let nameTF = CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_333333, delegate: self, placeholder: LocalString("asserts_wallet_name"))
        return nameTF
    }()
    
    lazy var searchBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("Search"),font: FontSystemBold(size: 15),color: Color_1C1E27, cornerRadius: 0, backColor: UIColor.clear)
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
        tableV.register(cellType: ChainTokenTableCell.self)
        return tableV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBaseNaviLeft()
        baseNaviTitle.text = chainCoin?.symbol ?? ""
        
        searchV.frame = CGRect(x: naviLeftBtn.right + 10, y: ZSCREENNAVIBAR - 44, width: ZSCREENWIDTH - naviLeftBtn.right - 100, height: 44)
        searchV.clipsToBounds = true
        searchV.layer.cornerRadius = 22
        baseNaviBar.addSubview(searchV)
        
        searchTF.frame = CGRect(x: 15, y: 0, width: searchV.width - 30, height: 44)
        searchTF.keyboardType = .default
        searchV.addSubview(searchTF)
        
        searchBtn.frame = CGRect(x: ZSCREENWIDTH - 80, y: ZSCREENNAVIBAR - 44, width: 80, height: 44)
        searchBtn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        baseNaviBar.addSubview(searchBtn)
        
        baseMainV.addSubview(emptyDataView)
        baseMainV.addSubview(mainTableV)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        baseMainV.addGestureRecognizer(tapGesture)
    }
    
    override func configData() {
        let walletCoinModel = Walletverse.getWalletCoinModel()
        walletCoinModel.wid = identityModel?.wid ?? ""
        Walletverse.queryWalletCoins(walletCoinModel: walletCoinModel) { (result) in
            if let walletArray = result {
                if walletArray.count > 0 {
                    self.walletArray = walletArray
                }
            }
            self.searchBtnClick()
        }
    }
    
    func getData(_ address: String?) {
        let getTokenParams = GetTokenParams(chainId: chainCoin?.chainId ?? "", contractAddress: address ?? "")
        Walletverse.getToken(params: getTokenParams) { result in
            if result != nil && !((result?.chainId ?? "").isEmpty) {
                if var coin = result {
                    for walletCoin in self.walletArray ?? [WalletCoinModel]() {
                        if (walletCoin.chainId == coin.chainId && walletCoin.contractAddress == coin.contractAddress) {
                            coin.isAdd = true
                        }
                    }
                    self.coinArray?.append(coin)
                }
            }
            self.mainTableV.reloadData()
        }
    }
    
    @objc func tapClick() {
        view.endEditing(true)
    }
    
    @objc func searchBtnClick() {
        tapClick()
        coinArray?.removeAll()
        if !(searchTF.text?.trimmingCharacters( in : .whitespaces) ?? "").isEmpty {
            self.getData(searchTF.text?.trimmingCharacters( in : .whitespaces) ?? "")
        }
    }
}

extension SearchTokenViewController : UITableViewDelegate,UITableViewDataSource {
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

extension SearchTokenViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

