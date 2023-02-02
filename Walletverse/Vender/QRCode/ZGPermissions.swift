//
//  ZGPermissions.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AssetsLibrary

class ZGPermissions: NSObject {
    static func authorizePhoto(comletion:@escaping (Bool)->Void ) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            comletion(true)
        case PHAuthorizationStatus.denied,PHAuthorizationStatus.restricted:
            comletion(false)
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    comletion(status == PHAuthorizationStatus.authorized ? true:false)
                }
            })
        @unknown default:
            break
        }
    }
    
    static func authorizeCamera(comletion:@escaping (Bool)->Void ) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        switch granted {
        case .authorized:
            comletion(true)
            break;
        case .denied:
            comletion(false)
            break;
        case .restricted:
            comletion(false)
            break;
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted:Bool) in
                DispatchQueue.main.async {
                    comletion(granted)
                }
            })
        @unknown default:
            break
        }
    }
    
    static func jumpToSystemPrivacySetting() {
        let appSetting = URL(string:UIApplication.openSettingsURLString)
        if appSetting != nil {
            if #available(iOS 10, *) {
                UIApplication.shared.open(appSetting!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appSetting!)
            }
        }
    }
    
}
