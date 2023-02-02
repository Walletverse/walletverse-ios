//
//  TokenViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/10.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class TokenViewController: BaseViewController {
    var identityModel: IdentityModel?
    var walletCoin: WalletCoinModel?
    
    var tradeArray: [TransactionRecord]?
    
    var currentPage = 1
    
    var headerIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "TokenHeaderBack"))
    }()
    
    var topV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var iconIV : UIImageView = {
        let iconIV = UIImageView()
        return iconIV
    }()
    
    lazy var balanceL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 25), color: Color_1C1E27)
    }()
    
    lazy var totalPriceL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    var addressV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var addressL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    lazy var addressIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "AssetAddressCopy"))
    }()
    
    lazy var bottomV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    lazy var hideBtn : UIButton = {
        return CustomView.buttonCustom(normalImage: UIImage(named: "AssetsWalletManage"), selectedImage: UIImage(named: "AssetsWalletManage"))
    }()
        
    lazy var transfreBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("asserts_transfer"), font: FontSystemBold(size: 16), color: Color_FFFFFF, cornerRadius: 4, backColor: Color_1C1E27)
    }()
        
    lazy var receiptBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("asserts_receive"), font: FontSystemBold(size: 16), color: Color_1C1E27, cornerRadius: 4, backColor: Color_5C74FF)
    }()
        
    lazy var emptyDataView : EmptyDataView = {
        let emptyDataView = EmptyDataView.init()
        emptyDataView.frame = CGRect.init(x: mainTableV.centerX - emptyDataView.width/2, y: mainTableV.centerY - emptyDataView.height/2, width: emptyDataView.width, height: emptyDataView.height)
        return emptyDataView
    }()

    private lazy var mainTableV : UITableView = {
        let tableV = UITableView.init(frame: CGRect.init(x: 0, y: topV.bottom + 20, width: ZSCREENWIDTH - 0, height: baseMainV.height - ZSCREENBOTTOM - topV.bottom - 68 - 30))
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
        tableV.register(cellType: TokenTableCell.self)
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
        isShowNaviBar = false
        super.viewDidLoad()
    
        headerIV.frame = CGRect(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENWIDTH/1125*600)
        baseMainV.addSubview(headerIV)
        
        initBaseNaviBar()
        initBaseNaviLeft()
        baseNaviBar.backgroundColor = UIColor.clear
        baseNaviTitle.text = walletCoin?.symbol ?? ""
        
        if walletCoin?.contractAddress?.count ?? 0 > 0 {
            hideBtn.frame = CGRect(x: ZSCREENWIDTH - 44, y: ZSCREENNAVIBAR - 44, width: 44, height: 44)
            hideBtn.addTarget(self, action: #selector(hideBtnClick), for: .touchUpInside)
            baseNaviBar.addSubview(hideBtn)
        }
        
        topV.frame = CGRect(x: 20, y: headerIV.bottom - 80, width: ZSCREENWIDTH - 40, height: 200)
        topV.layer.cornerRadius = 10
        topV.clipsToBounds = true
        baseMainV.addSubview(topV)
        
        iconIV.frame = CGRect(x: (topV.width - 40)/2, y: 30, width: 40, height: 40)
        iconIV.layer.cornerRadius = 20
        iconIV.clipsToBounds = true
        topV.addSubview(iconIV)
        
        balanceL.frame = CGRect(x: 20, y: 80, width: topV.width - 40, height: 30)
        balanceL.textAlignment = .center
        topV.addSubview(balanceL)
        
        totalPriceL.frame = CGRect(x: 20, y:110, width: topV.width - 40, height: 20)
        totalPriceL.textAlignment = .center
        topV.addSubview(totalPriceL)

        addressV.frame = CGRect(x: 80, y: totalPriceL.bottom + 20, width: topV.width - 160, height: 30)
        addressV.layer.cornerRadius = 15
        addressV.clipsToBounds = true
        addressV.layer.borderWidth = 1
        addressV.layer.borderColor = Color_F5F6FA.cgColor
        let addressGesture = UITapGestureRecognizer.init(target: self, action: #selector(addressGestureClick))
        addressV.addGestureRecognizer(addressGesture)
        topV.addSubview(addressV)

        addressL.frame = CGRect(x: 5, y: 0, width: addressV.width - 35, height: 30)
        addressL.lineBreakMode = .byTruncatingMiddle
        addressV.addSubview(addressL)

        addressIV.frame = CGRect(x: addressL.width + 8, y: 5, width: 20, height: 20)
//        addressIV.contentMode = .center
        addressV.addSubview(addressIV)
        
        baseMainV.addSubview(emptyDataView)
        baseMainV.addSubview(mainTableV)
        
        bottomV.frame = CGRect(x: 0, y: mainTableV.bottom + 10, width: ZSCREENWIDTH, height: 68 + ZSCREENBOTTOM)
        baseMainV.addSubview(bottomV)
            
        transfreBtn.frame = CGRect(x: 25, y: 0, width: ZSCREENWIDTH/2 - 35, height: 48)
        transfreBtn.layer.cornerRadius = 24
        transfreBtn.clipsToBounds = true
        transfreBtn.addTarget(self, action: #selector(transfreBtnClick), for: .touchUpInside)
        bottomV.addSubview(transfreBtn)
            
        receiptBtn.frame = CGRect(x: transfreBtn.right + 20, y: 0, width: transfreBtn.width, height: transfreBtn.height)
        receiptBtn.layer.cornerRadius = 24
        receiptBtn.clipsToBounds = true
        receiptBtn.addTarget(self, action: #selector(receiptBtnClick), for: .touchUpInside)
        bottomV.addSubview(receiptBtn)
        
    }
    
    override func configData() {
        iconIV.kf.setImage(urlString: walletCoin?.iconUrl, placeholder: UIImage(named: "IconPlaceholder"))
        balanceL.text = (walletCoin?.balance ?? "").isEmpty ? "0" : walletCoin?.balance
        if ((walletCoin?.totalPrice ?? "").isEmpty) {
            totalPriceL.text = "≈\(CurrencyUtil.getHostAmountMoney())0"
        } else {
            totalPriceL.text = "≈\(CurrencyUtil.getHostAmountMoney())\(walletCoin?.totalPrice ?? "")"
        }
        
        addressL.text = walletCoin?.address ?? ""
        
        currentPage = 1
        self.getData()
    }
    
    func getData() {
        let recordParams = TransactionRecordParams(page: "\(currentPage)", size: "50", chainId: walletCoin?.chainId, address: walletCoin?.address, condition: Condition.OUT, contractAddress: walletCoin?.contractAddress)
        Walletverse.getTransactionRecords(params: recordParams) { (result) in
            if let recordArray = result {
                if self.currentPage == 1 {
                    self.tradeArray = recordArray
                } else {
                    self.tradeArray?.append(contentsOf: recordArray)
                }
                
                self.mainTableV.reloadData()
            }
        }
    }
    
    @objc func hideBtnClick() {
        let alertSheet = UIAlertController(title: LocalString("asserts_hide"), message: nil, preferredStyle: .actionSheet)
        let idAction = UIAlertAction(title: LocalString("confirm"), style: .default, handler: {
            action in
            
            Walletverse.deleteWalletCoin(walletCoinModel: self.walletCoin ?? Walletverse.getWalletCoinModel()) { (result) in
                self.naviLeftBtnClick()
            }
        })
        let cancelAction = UIAlertAction(title: LocalString("cancel"), style: .cancel, handler: {
            action in
            
        })
        alertSheet.addAction(idAction)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true, completion: nil)
    }
    
    @objc func addressGestureClick() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = walletCoin?.address ?? ""
        CommonToastView.showToastAction(message: LocalString("common_already_copy"))
    }
    
    @objc func transfreBtnClick() {
        let controller = TransferViewController()
        controller.identityModel = identityModel
        controller.walletCoin = walletCoin
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func receiptBtnClick() {
        let controller = ReceiveViewController()
        controller.identityModel = identityModel
        controller.walletCoin = walletCoin
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TokenViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tradeArray?.count ?? 0 > 0 {
            emptyDataView.isHidden = true
        } else {
            emptyDataView.isHidden = false
        }
        return self.tradeArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TokenTableCell.self)
        if let coinModel = tradeArray?[indexPath.row] {
            cell.setTransactionRecord(transactionRecord: coinModel, walletCoin: walletCoin)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tradeModel = tradeArray?[indexPath.row] {
            let controller = TransferDetailViewController()
            controller.identityModel = identityModel
            controller.walletCoin = walletCoin
            controller.transactionRecord = tradeModel
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
