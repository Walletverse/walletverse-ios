//
//  BaseViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

enum NaviBarType {
    case NaviBarTypeBlack
    case NaviBarTypeWhite
}

class BaseViewController: UIViewController {

    var isShowNaviBar : Bool = true
    
    var baseNaviBar : UIView = UIView()
    var baseNaviTitle : UILabel = UILabel()
    var naviLeftBtn : UIButton = UIButton()
    var naviBarType : NaviBarType = .NaviBarTypeBlack
    
    var baseMainV : UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.isTranslucent = false
        
        view.backgroundColor = Color_FFFFFF
        
        if isShowNaviBar {
            initBaseNaviBar()
            initBaseMainV()
        } else {
            initBaseMainV()
        }
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        configUI()
        configData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        configNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        //        return .lightContent
        return .default
    }
    
    func initBaseNaviBar() {
        baseNaviBar.frame = CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENNAVIBAR)
        baseNaviBar.backgroundColor = Color_FFFFFF
        view.addSubview(baseNaviBar)
        
        baseNaviTitle.frame = CGRect.init(x: 50, y: ZSCREENNAVIBAR - 44, width: ZSCREENWIDTH - 100, height: 44)
        baseNaviTitle.textColor = Color_091C40
        baseNaviTitle.font = UIFont.boldSystemFont(ofSize: 18)
        baseNaviTitle.textAlignment = .center
        baseNaviBar.addSubview(baseNaviTitle)
    }
    
    func initBaseMainV() {
        if isShowNaviBar {
            baseMainV.frame = CGRect.init(x: 0, y: baseNaviBar.bottom, width: ZSCREENWIDTH, height: ZSCREENHEIGHT - ZSCREENNAVIBAR)
            baseMainV.backgroundColor = Color_FFFFFF
            view.addSubview(baseMainV)
        } else {
            baseMainV.frame = CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENHEIGHT)
            baseMainV.backgroundColor = Color_FFFFFF
            view.addSubview(baseMainV)
        }
    }
    
    func initBaseNaviLeft() {
        naviLeftBtn.frame = CGRect.init(x: 0, y: ZSCREENNAVIBAR - 44, width: 44, height: 44)
        naviLeftBtn.setImage(UIImage.init(named: "navi_back"), for: .normal)
        naviLeftBtn.addTarget(self, action: #selector(naviLeftBtnClick), for: .touchUpInside)
        baseNaviBar.addSubview(naviLeftBtn)
    }
    
    func configUI() {
        
    }
    
    func configData() {
        
    }
    
    func configNavigationBar() {
        
    }
    
    func setNaviBarType(naviBarType : NaviBarType) {
        self.naviBarType = naviBarType
        switch self.naviBarType {
        case .NaviBarTypeBlack:
            naviLeftBtn.setImage(UIImage.init(named: "navi_back"), for: .normal)
            baseNaviTitle.textColor = Color_091C40
            break
        case .NaviBarTypeWhite:
            naviLeftBtn.setImage(UIImage.init(named: "navi_back_white"), for: .normal)
            baseNaviTitle.textColor = ColorHex(0xFFFFFF)
            break
        }
    }
    
    func hiddenNaviLeftBtn() {
        naviLeftBtn.isHidden = true
    }
    
    @objc func naviLeftBtnClick() {
        naviLeftBtn.isEnabled = false
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }

}

extension BaseViewController {
    
}
