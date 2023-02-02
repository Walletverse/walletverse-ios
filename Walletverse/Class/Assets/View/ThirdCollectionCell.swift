//
//  ThirdCollectionCell.swift
//  Walletverse
//
//  Created by Kylin on 2022/10/24.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

protocol ThirdCollectionCellDelegate  {
    func selectActionDelegate(key: String)
}

class ThirdCollectionCell: BaseCollectionViewCell {
    var delegate: ThirdCollectionCellDelegate?
    
    lazy var iconIV : UIImageView = {
        let iconIV = UIImageView()
        return iconIV
    }()
    
    lazy var nameL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_1C1E27, textAlignment: .center)
    }()
    
    override func configUI() {
        backgroundColor = UIColor.clear
        iconIV.frame = CGRect(x: (ZSCREENWIDTH/5 - (ZSCREENWIDTH/5 - 10 - 20))/2, y: 5, width: ZSCREENWIDTH/5 - 10 - 20, height: ZSCREENWIDTH/5 - 10 - 20)
        iconIV.isUserInteractionEnabled = true
        let selectGesture = UITapGestureRecognizer.init(target: self, action: #selector(selectGestureClick))
        iconIV.addGestureRecognizer(selectGesture)
        addSubview(iconIV)
        nameL.frame = CGRect(x: 0, y: iconIV.bottom, width: ZSCREENWIDTH/5, height: 20)
        addSubview(nameL)
    }
    
    @objc func selectGestureClick() {
        self.delegate?.selectActionDelegate(key: nameL.text ?? "")
    }
}
