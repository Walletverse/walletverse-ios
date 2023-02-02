//
//  AppDelegate.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit
import CoreData
import FirebaseCore
import GoogleSignIn
import walletverse_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigation : BaseNavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()

        LocalUtil.shareInstance.initUserLanguage()
        object_setClass(Foundation.Bundle.main, Bundle.self)
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        applicationSetRootViewController()
        window?.makeKeyAndVisible();
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.cancelAllLocalNotifications()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func applicationSetRootViewController() {
        let vc = InitViewController.init()
        navigation = BaseNavigationController.init(rootViewController:vc)
        self.window?.rootViewController = navigation;
    }
    
    func applicationSetMainViewController() {
        let vc = MainViewController.init()
        navigation = BaseNavigationController.init(rootViewController:vc)
        self.window?.rootViewController = navigation;
    }
    
    func applicationSetRootViewController(controller : UIViewController) {
        navigation = BaseNavigationController.init(rootViewController:controller)
        self.window?.rootViewController = navigation;
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }

}
