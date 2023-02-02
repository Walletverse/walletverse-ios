//
//  MonetaryUtil.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class CurrencyUtil: NSObject {
    let currencyArray : Array<Dictionary<String,String>> =
        [["key":LocalString("mine_currency_my") , "value":"USD"],
        ["key":LocalString("mine_currency_hy") , "value":"KRW"],
        ["key":LocalString("mine_currency_rmb") , "value":"CNY"],
        ]
    
    override init() {
        super.init()
    }
    
    func initCurrency() {
        
    }
    
    func getCurrentCurrency() -> String {
        var monetaryS : String?
        let string = DefaultUtil.getValue(key: Constant_CURRENCY) as? String
        if string?.count ?? 0 > 0 {
            if stringCompareOrig(string,"CNY") {
                monetaryS = LocalString("mine_currency_rmb")
            } else if stringCompareOrig(string,"USD") {
                monetaryS = LocalString("mine_currency_my")
            } else if stringCompareOrig(string,"KRW") {
                monetaryS = LocalString("mine_currency_hy")
            }
        }
        return monetaryS ?? LocalString("mine_currency_my")
    }
    
    func getCurrentCurrencyEnum() -> Currency {
        var monetaryE : Currency?
        let string = DefaultUtil.getValue(key: Constant_CURRENCY) as? String
        if string?.count ?? 0 > 0 {
            if stringCompareOrig(string,"CNY") {
                monetaryE = Currency.CNY
            } else if stringCompareOrig(string,"USD") {
                monetaryE = Currency.USD
            } else if stringCompareOrig(string,"KRW") {
                monetaryE = Currency.KRW
            }
        }
        return monetaryE ?? Currency.USD
    }
    
    func setCurrentCurrency(_ monetary : String?) {
        if monetary?.count ?? 0 > 0 {
            DefaultUtil.setValue(value: monetary ?? "USD", key: Constant_CURRENCY)
        }
    }
    
    static func getHostAmountMoney() -> String {
        var char : String = ""
        let string = DefaultUtil.getValue(key: Constant_CURRENCY) as? String
        switch (string) {
            case "CNY":
                char = "¥"
            case "USD":
                char = "$"
            case "KRW":
                char = "₩"
            default:
                char = "$"
        }
        return char
    }
}
