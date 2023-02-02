//
//  Web3ViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

class Web3ViewController : BaseViewController {
    
    lazy var mainV : UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var iconIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "AssetsHostNodata"))
    }()
    
    lazy var createV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var createTitleL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_host_no_create"), font: FontSystem(size: 16), color: Color_091C40)
    }()
    
    lazy var createContentL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_host_no_create_tip"), font: FontSystem(size: 12), color: Color_717782)
    }()
    
    lazy var createArrowIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "CommonArrowRight"))
    }()
    
    lazy var importV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var importTitleL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_host_no_import"), font: FontSystem(size: 15), color: Color_091C40)
    }()
    
    lazy var importContentL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_host_no_import_tip"), font: FontSystem(size: 12), color: Color_717782)
    }()
    
    lazy var importArrowIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "CommonArrowRight"))
    }()
    
    
    override func viewDidLoad() {
        isShowNaviBar = false
        super.viewDidLoad()
    }
    
    override func configUI() {
        mainV.frame = CGRect(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENHEIGHT - ZSCREENTABBAR)
        mainV.bounces = false
        mainV.backgroundColor = Color_FFFFFF
        view.addSubview(mainV)
        
        iconIV.frame = CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENWIDTH/375*356)
        iconIV.contentMode = .scaleAspectFit
        mainV.addSubview(iconIV)
        
        createV.frame = CGRect(x: 15, y: iconIV.bottom + 100, width: ZSCREENWIDTH - 32, height: 76)
        createV.clipsToBounds = true
        createV.layer.cornerRadius = 4
        createV.isUserInteractionEnabled = true
        createV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createBtnClick(tapGesture:))))
        mainV.addSubview(createV)
        
        createTitleL.frame = CGRect(x: 23, y: 17, width: createV.width - 72, height: 21)
        createV.addSubview(createTitleL)
        
        createContentL.frame = CGRect(x: 23, y: createTitleL.bottom + 5, width: createV.width - 72, height: 17)
        createV.addSubview(createContentL)
        
        createArrowIV.frame = CGRect(x: createTitleL.right, y: 0, width: 48, height: createV.height)
        createArrowIV.contentMode = .center
        createV.addSubview(createArrowIV)
        
        importV.frame = CGRect(x: 15, y: createV.bottom + 12, width: ZSCREENWIDTH - 32, height: 76)
        importV.clipsToBounds = true
        importV.layer.cornerRadius = 4
        importV.isUserInteractionEnabled = true
        importV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(importBtnClick(tapGesture:))))
        mainV.addSubview(importV)
        
        importTitleL.frame = CGRect(x: 23, y: 17, width: importV.width - 72, height: 21)
        importV.addSubview(importTitleL)
        
        importContentL.frame = CGRect(x: 23, y: importTitleL.bottom + 5, width: importV.width - 72, height: 17)
        importV.addSubview(importContentL)
        
        importArrowIV.frame = CGRect(x: importTitleL.right, y: 0, width: 48, height: importV.height)
        importArrowIV.contentMode = .center
        importV.addSubview(importArrowIV)
        
        mainV.contentSize = CGSize(width: mainV.width,height: importV.bottom + 40)
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        createV.isUserInteractionEnabled = false
        importV.isUserInteractionEnabled = false
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        createV.isUserInteractionEnabled = true
        importV.isUserInteractionEnabled = true
    }
    
    @objc func createBtnClick(tapGesture : UITapGestureRecognizer) {
        
        createV.isUserInteractionEnabled = false
        perform(#selector(createBtnEnable), with: nil, afterDelay: 0.5)
        
        let controller = CreateWalletViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func importBtnClick(tapGesture : UITapGestureRecognizer) {
        
        importV.isUserInteractionEnabled = false
        perform(#selector(importBtnEnable), with: nil, afterDelay: 0.5)
        
        let controller = ImportWalletViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func createBtnEnable() {
        createV.isUserInteractionEnabled = true
    }

    @objc func importBtnEnable() {
        importV.isUserInteractionEnabled = true
    }
    
}
