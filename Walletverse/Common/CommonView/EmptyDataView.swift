//
//  EmptyDataView.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

class EmptyDataView: BaseView {
    
    lazy var mainV : UIView = {
        let mainV = UIView()
        mainV.backgroundColor = UIColor.clear
        return mainV
    }()
    
    lazy var imageV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "nodata"))
    }()
    
    lazy var contentL : UILabel = {
        return CustomView.labelCustom(text: LocalString("no_data"), font: FontSystem(size: 14), color: ColorHex(0xd8d8d8), textAlignment: .center)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 300, height: 130)
        configSubviews(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubviews(frame: CGRect) {
        mainV.frame = CGRect(x: 0, y: 0, width: 300, height: 130)
        addSubview(mainV)
        
        imageV.frame = CGRect(x: (mainV.width - 100)/2, y: 0, width: 100, height: 100)
        mainV.addSubview(imageV)
        
        contentL.frame = CGRect(x: 10, y: mainV.height - 20, width: mainV.width - 20, height: 20)
        mainV.addSubview(contentL)
    }

}
