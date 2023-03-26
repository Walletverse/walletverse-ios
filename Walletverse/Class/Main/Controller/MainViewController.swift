//
//  MainViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import MBProgressHUD

class MainViewController: BaseTabBarController {
    var passwordS : String?
    var isHaveWallet : Bool?
    
    var count : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().backgroundColor = Color_FFFFFF
        UITabBar.appearance().isTranslucent = false
        
        if #available(iOS 13.0, *) {
            self.tabBar.tintColor = Color_091C40;
            self.tabBar.unselectedItemTintColor = Color_091C40;
        } else {
            
        }
        addChildViewController(childController: AssetsHostViewController(), title: LocalString("main_tab_assets"), image: UIImage(named: "main_tap_assets_false"), selectedImage: UIImage(named: "main_tap_assets_true"))
        addChildViewController(childController: NftViewController(), title: LocalString("main_tab_nfts"), image: UIImage(named: "main_tap_find_false"), selectedImage: UIImage(named: "main_tap_find_true"))
        addChildViewController(childController: DappViewController(), title: LocalString("main_tab_finds"), image: UIImage(named: "main_tap_find_false"), selectedImage: UIImage(named: "main_tap_find_true"))
        addChildViewController(childController: MineViewController(), title: LocalString("main_tab_mine"), image: UIImage(named: "main_tap_mine_false"), selectedImage: UIImage(named: "main_tap_mine_true"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addChildViewController(childController : UIViewController, title : String?, image : UIImage?,selectedImage : UIImage?) {
        childController.title = title
        
        childController.tabBarItem = UITabBarItem(title:title, image : image?.withRenderingMode(.alwaysOriginal), selectedImage:selectedImage?.withRenderingMode(.alwaysOriginal))
        
        let colorNormal : UIColor = Color_091C40
        let colorSelected : UIColor = Color_091C40
        
        if #available(iOS 13.0, *) {
            
        } else {
            let attributesNormal = [
                NSAttributedString.Key.foregroundColor : colorNormal
            ]
            let attributesSelected = [
                NSAttributedString.Key.foregroundColor : colorSelected
            ]
            childController.tabBarItem.setTitleTextAttributes(attributesNormal, for: .normal)
            childController.tabBarItem.setTitleTextAttributes(attributesSelected, for: .selected)
        }
        addChild(childController)
    }
}
