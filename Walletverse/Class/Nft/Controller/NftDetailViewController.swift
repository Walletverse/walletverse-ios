//
//  NftDetailViewController.swift
//  Walletverse
//
//  Created by Kylin on 2023/3/26.
//  Copyright © 2023 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class NftDetailViewController: BaseViewController {
    var nftModel: NftModel?
    
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
    
    lazy var nameL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 25), color: Color_1C1E27)
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
        
    lazy var transfreDataBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("nft_transfer_data"), font: FontSystemBold(size: 16), color: Color_FFFFFF, cornerRadius: 4, backColor: Color_1C1E27)
    }()
        
    lazy var tokenUriBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("nft_token_uri"), font: FontSystemBold(size: 16), color: Color_1C1E27, cornerRadius: 4, backColor: Color_5C74FF)
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
        tableV.register(cellType: NftAttributeTableCell.self)
        return tableV
    }()
    
    
    override func viewDidLoad() {
        isShowNaviBar = false
        super.viewDidLoad()
    
        headerIV.frame = CGRect(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENWIDTH/1125*600)
        baseMainV.addSubview(headerIV)
        
        initBaseNaviBar()
        initBaseNaviLeft()
        baseNaviBar.backgroundColor = UIColor.clear
        baseNaviTitle.text = nftModel?.name ?? ""
        
        topV.frame = CGRect(x: 20, y: headerIV.bottom - 80, width: ZSCREENWIDTH - 40, height: 200)
        topV.layer.cornerRadius = 10
        topV.clipsToBounds = true
        baseMainV.addSubview(topV)
        
        iconIV.frame = CGRect(x: (topV.width - 40)/2, y: 30, width: 40, height: 40)
        iconIV.layer.cornerRadius = 20
        iconIV.clipsToBounds = true
        topV.addSubview(iconIV)
        
        nameL.frame = CGRect(x: 20, y: 80, width: topV.width - 40, height: 30)
        nameL.textAlignment = .center
        topV.addSubview(nameL)

        addressV.frame = CGRect(x: 80, y: nameL.bottom + 20, width: topV.width - 160, height: 30)
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
            
        transfreDataBtn.frame = CGRect(x: 25, y: 0, width: ZSCREENWIDTH/2 - 35, height: 48)
        transfreDataBtn.layer.cornerRadius = 24
        transfreDataBtn.clipsToBounds = true
        transfreDataBtn.addTarget(self, action: #selector(transfreDataBtnClick), for: .touchUpInside)
        bottomV.addSubview(transfreDataBtn)
            
        tokenUriBtn.frame = CGRect(x: transfreDataBtn.right + 20, y: 0, width: transfreDataBtn.width, height: transfreDataBtn.height)
        tokenUriBtn.layer.cornerRadius = 24
        tokenUriBtn.clipsToBounds = true
        tokenUriBtn.addTarget(self, action: #selector(tokenUriBtnClick), for: .touchUpInside)
        bottomV.addSubview(tokenUriBtn)
        
    }
    
    override func configData() {
        iconIV.kf.setImage(urlString: nftModel?.image, placeholder: UIImage(named: "IconPlaceholder"))
        nameL.text = (nftModel?.name ?? "").isEmpty ? "0" : nftModel?.name
        addressL.text = nftModel?.contractAddress ?? ""
        
    }
    
    @objc func addressGestureClick() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = nftModel?.contractAddress ?? ""
        CommonToastView.showToastAction(message: LocalString("common_already_copy"))
    }
    
    @objc func transfreDataBtnClick() {
        let nftTransferDataParams = NftTransferDataParams(chainId: "0x1", tokenId: nftModel?.tokenId ?? "", contractAddress: "0x3A2C64e82f31E70aaf02849bc1e0952A610b95F3", from: "0xF42Dc31cef8462eC1C4831FAF39F8dd2B0C5a0f8", to: "0xdaA36E030c987e1B0F950703BeF628b46088bD39")
        Walletverse.getNftTransferData(params: nftTransferDataParams) { (result) in
            if let message = result {
                let alertV = CustomAlertView.init(title: LocalString("nft_transfer_data"), message: message, preferredStyle: UIAlertController.Style.alert)
                alertV.addAction(UIAlertAction.init(title: LocalString("copy"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = message
                    CommonToastView.showToastAction(message: LocalString("common_already_copy"))
                }))
                alertV.addAction(UIAlertAction.init(title: LocalString("cancel"), style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
                    
                }))
                self.present(alertV, animated: true, completion: nil)
            }
        }
    }
    
    @objc func tokenUriBtnClick() {
        let nftTokenURIParams = NftTokenURIParams(chainId: "0x1", tokenId: nftModel?.tokenId ?? "", contractAddress: "0x3A2C64e82f31E70aaf02849bc1e0952A610b95F3")
        Walletverse.getNftTokenURI(params: nftTokenURIParams) { (result) in
            if let message = result {
                let alertV = CustomAlertView.init(title: LocalString("nft_token_uri"), message: message, preferredStyle: UIAlertController.Style.alert)
                alertV.addAction(UIAlertAction.init(title: LocalString("copy"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = message
                    CommonToastView.showToastAction(message: LocalString("common_already_copy"))
                }))
                alertV.addAction(UIAlertAction.init(title: LocalString("cancel"), style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
                    
                }))
                self.present(alertV, animated: true, completion: nil)
            }
        }
    }
}

extension NftDetailViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.nftModel?.attributes?.count ?? 0 > 0 {
            emptyDataView.isHidden = true
        } else {
            emptyDataView.isHidden = false
        }
        return self.nftModel?.attributes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NftAttributeTableCell.self)
        if let nftAttribute = nftModel?.attributes?[indexPath.row] {
            cell.configData(nftAttribute: nftAttribute)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
