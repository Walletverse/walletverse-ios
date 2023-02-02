//
//  PredicateUtil.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

class PredicateUtil: NSObject {
    static func vertifyPassword(_ string : String) -> Bool {
        let passwordRule = "^[0-9]{6}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",passwordRule)
        if regexPassword.evaluate(with: string) == true {
            return true
        } else {
            return false
        }
    }
    
    static func vertifyEmail(_ email:String) -> Bool {
        let passwordRule = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",passwordRule)
        if regexPassword.evaluate(with: email) == true {
            return true
        } else {
            return false
        }
    }
}
