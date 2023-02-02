//
//  UserDefaultUtil.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

class UserDefaultUtil: NSObject {
    static func initDefault() {
        UserDefaultUtil.setValue(value: "", key: ZUSERDEFAULT_CURRENTWALLET)
        UserDefaultUtil.setValue(value: "", key: ZUSERDEFAULT_WALLETPASSWORD)
    }
    
    static func getValue(key : String) -> Any {
        return ZUSERDEFAULT.value(forKey: key) as Any
    }
    
    static func getBoolValue(key : String) -> Bool {
        return ZUSERDEFAULT.bool(forKey: key)
    }
    
    static func setValue(value : Any,key : String) {
        ZUSERDEFAULT.set(value, forKey: key)
        ZUSERDEFAULT.synchronize()
    }
    
    static func clearValue() {
        
    }
}
