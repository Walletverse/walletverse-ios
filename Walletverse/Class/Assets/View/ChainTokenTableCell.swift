//
//  ChainTokenTableCell.swift
//  Walletverse
//
//  Created by Ky on 2022/10/11.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

protocol ChainTokenTableCellDelegate  {
    func addChainTokenDelegate(coin: Coin?)
}

class ChainTokenTableCell: BaseTableViewCell {
    var delegate: ChainTokenTableCellDelegate?
    
    var coinModel : Coin?
    
    lazy var iconIV : UIImageView = {
        let iconIV = UIImageView()
        return iconIV
    }()
    
    lazy var nameL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_1C1E27)
    }()
    
    lazy var addressL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_7D7F86)
    }()
    
    lazy var addBtn : UIImageView = {
        let addBtn = UIImageView()
        return addBtn
    }()
    
    lazy var lineV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    override func configUI() {
        contentView.backgroundColor = UIColor.clear
        
        iconIV.frame = CGRect(x: 15, y: 16, width: 32, height: 32)
        iconIV.layer.cornerRadius = 16
        iconIV.clipsToBounds = true
        contentView.addSubview(iconIV)
        
        nameL.frame = CGRect(x: iconIV.right + 10, y: iconIV.centerY - 20, width: ZSCREENWIDTH - (iconIV.right + 10 + 50), height: 20)
        contentView.addSubview(nameL)
        
        addressL.frame = CGRect(x: iconIV.right + 10, y: nameL.bottom, width: nameL.width, height: 20)
        contentView.addSubview(addressL)
        
        addBtn.frame = CGRect(x: nameL.right + 10, y: 16, width: 32, height: 32)
        addBtn.contentMode = .center
        addBtn.isUserInteractionEnabled = true
        let addGesture = UITapGestureRecognizer.init(target: self, action: #selector(addGestureClick))
        addBtn.addGestureRecognizer(addGesture)
        contentView.addSubview(addBtn)
        
        lineV.frame = CGRect(x: iconIV.right + 10, y: 63, width: ZSCREENWIDTH - (iconIV.right + 10), height: 1)
        contentView.addSubview(lineV)
    }
    
    func setCoinModel(coinModel : Coin?) {
        if let model = coinModel {
            self.coinModel = model
            iconIV.kf.setImage(with: URL(string: self.coinModel?.iconUrl ?? ""), placeholder: UIImage(named: "IconPlaceholder"), options: nil, progressBlock: nil, completionHandler: nil)
            nameL.text = "\(model.symbol ?? "") (\(model.name ?? ""))"
            addressL.text = "\(model.contractAddress ?? "")"
            
            if model.isAdd {
                addBtn.image = UIImage(named: "AssetTokenSelect")
                addBtn.isUserInteractionEnabled = false
            } else {
                addBtn.image = UIImage(named: "AssetTokenUnselect")
                addBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func addGestureClick() {
        self.delegate?.addChainTokenDelegate(coin: coinModel)
    }
    
}
