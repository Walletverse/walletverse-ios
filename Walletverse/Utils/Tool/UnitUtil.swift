//
//  UnitUtil.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class UnitUtil: NSObject {
    let unitArray : Array<String> = ["USDT","USD",]
    
    override init() {
        super.init()
    }
    
    func initUnit() {
        
    }
    
    func getCurrentUnit() -> String {
        let unitS = DefaultUtil.getValue(key: Constant_UNIT) as? String
        return unitS ?? "USDT"
    }
    
    func getCurrentUnitEnum() -> walletverse_ios_sdk.Unit {
        var unitE : walletverse_ios_sdk.Unit?
        let string = DefaultUtil.getValue(key: Constant_UNIT) as? String
        if string?.count ?? 0 > 0 {
            if stringCompareOrig(string,"USDT") {
                unitE = Unit.USDT
            } else if stringCompareOrig(string,"USD") {
                unitE = Unit.USD
            }
        } else {
            
        }
        return unitE ?? Unit.USD
    }
    
    func setCurrentUnit(_ unit : String?) {
        if unit?.count ?? 0 > 0 {
            DefaultUtil.setValue(value: unit ?? "USDT", key: Constant_UNIT)
        }
    }
}
