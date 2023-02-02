//
//  LocalUtil.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class LocalUtil: NSObject {
    static let shareInstance : LocalUtil = {
        let instance = LocalUtil()
        return instance
    }()
    
    let languageArray : Array<Dictionary<String,String>> = [["key":"繁體中文" , "value":"zh-Hans"],
                                                            ["key":"English" , "value":"en"],
                                                            ["key":"한국어" , "value":"ko-KR"]
                                                            ]
    
    var bundle : Foundation.Bundle?
    
    override init() {
        super.init()
    }
    
    func initUserLanguage() {
        let st = getCurrentLanguage()
        print(st)
    }
    
    func getCurBundle() -> Foundation.Bundle? {
        var string:String = DefaultUtil.getValue(key: Constant_LANGUAGE) as? String ?? ""
        if string == "" {
            let languages = ZUSERDEFAULT.object(forKey: ZUSERDEFAULT_APPLELANGUAGE) as? NSArray
            if languages?.count != 0 {
                let current = languages?.object(at: 0) as? String
                if current != nil {
                    string = current!
                    DefaultUtil.setValue(value: current ?? "en", key: Constant_LANGUAGE)
                }
            }
        }
        if (string).hasPrefix("zh") {
            string = "zh-Hans"
        } else {
            string = string.replacingOccurrences(of: "-VN", with: "")
            string = string.replacingOccurrences(of: "-US", with: "")
            string = string.replacingOccurrences(of: "-KR", with: "")
        }
        let mainBundle = Foundation.Bundle.main
        if let path = mainBundle.path(forResource: string, ofType: "lproj"),
            let bundle = Foundation.Bundle(path: path) {
            return bundle
        } else {
            return nil
        }
    }
    
    func getCurrentLanguageName() -> String {
        var languageS : String?
        var string = DefaultUtil.getValue(key: Constant_LANGUAGE) as? String
        if string?.count ?? 0 <= 0 {
            string = getLanguageType()
        }
        if string?.count ?? 0 > 0 {
            if (string ?? "").hasPrefix("zh-Hans") {
                languageS = "繁體中文"
            } else if (string ?? "").hasPrefix("zh") {
                languageS = "繁體中文"
            } else if (string ?? "").hasPrefix("ko-") {
                languageS = "한국어"
            } else {
                languageS = "English"
            }
        }
        return languageS ?? "English"
    }
    
    func getCurrentLanguage() -> String {
        var languageS : String?
        let string = DefaultUtil.getValue(key: Constant_LANGUAGE) as? String
        if string?.count ?? 0 > 0 {
            if (string ?? "").hasPrefix("zh-Hans") {
                languageS = "zh-Hans"
            } else if (string ?? "").hasPrefix("zh-") {
                languageS = "zh-Hans"
            } else if (string ?? "").hasPrefix("ko-") {
                return "ko-KR"
            } else {
                return "en"
            }
        } else {
            languageS = getLanguageType()
        }
        return languageS ?? "en"
    }
    
    func getCurrentLanguageEnum() -> Language {
        var languageE : Language?
        let string = DefaultUtil.getValue(key: Constant_LANGUAGE) as? String
        if string?.count ?? 0 > 0 {
            if (string ?? "").hasPrefix("zh-Hans") {
                languageE = Language.ZH
            } else if (string ?? "").hasPrefix("zh-") {
                languageE = Language.ZH
            } else if (string ?? "").hasPrefix("ko-") {
                languageE = Language.EN
            } else {
                languageE = Language.EN
            }
        } else {
            languageE = Language.EN
        }
        return languageE ?? Language.EN
    }
    
    func getLanguageType() -> String {
        let def = UserDefaults.standard
        let allLanguages: [String] = def.object(forKey: ZUSERDEFAULT_APPLELANGUAGE) as! [String]
        let chooseLanguage = allLanguages.first
        print(allLanguages)
        if let language = chooseLanguage {
            if language.hasPrefix("zh-Hans") {
                return "zh-Hans"
            } else if language.hasPrefix("zh") {
                return "zh-Hans"
            } else if language.hasPrefix("ko-") {
                return "ko-KR"
            } else {
                return "en"
            }
        } else {
            return "en"
        }
    }
    
    func setCurrentLanguage(_ language : String?) {
        if language?.count ?? 0 > 0 {
            DefaultUtil.setValue(value: language ?? "en", key: Constant_LANGUAGE)
            ZUSERDEFAULT.synchronize()
        }
    }
}

class Bundle: Foundation.Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = LocalUtil.shareInstance.getCurBundle() {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}
