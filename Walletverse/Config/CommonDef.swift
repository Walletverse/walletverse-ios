//
//  CommonDef.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit

class CommonDef: NSObject {

}

let ZDELEGATE = UIApplication.shared.delegate as? AppDelegate

let ZWINDOW = UIApplication.shared.keyWindow
let ZAPPDELEGATE = UIApplication.shared.delegate as? AppDelegate
let ZAPPNAME = Bundle.main.infoDictionary?.index(forKey: "CFBundleDisplayName")
let ZAPPVERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
let ZAPPBUILDVERSION = Bundle.main.infoDictionary?["CFBundleVersion"]

let ZSCREENBOUNDS = UIScreen.main.bounds

let ZNOTIFICATION = NotificationCenter.default

let ZSCREENWIDTH : CGFloat = ZSCREENBOUNDS.size.width
let ZSCREENHEIGHT : CGFloat = ZSCREENBOUNDS.size.height


let ZDEVICEISIPHONEX : Bool = DeviceUtil.iphoneNotchScreen()
let ZSCREENNAVIBAR : CGFloat = ZDEVICEISIPHONEX ? 88 : 64
let ZSCREENTABBAR : CGFloat = ZDEVICEISIPHONEX ? 83 : 49
let ZSCREENBOTTOM : CGFloat = ZDEVICEISIPHONEX ? 35 : 0
let ZTABBARHEIGHT : CGFloat = 49

let ZUSERDEFAULT = UserDefaults.standard


func FontSystem(size:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}

func FontSystemBold(size:CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size)
}

func FontSystemItalic(size:CGFloat) -> UIFont {
    return UIFont.italicSystemFont(ofSize: size)
}


func LocalString(_ key : String) -> String {
    return NSLocalizedString(key, comment: "")
}


func ColorHex(_ value : UInt32) -> UIColor {
    return UIColor.UIColorHex(value)
}

func ColorHex(_ value : UInt32,alpha : CGFloat) -> UIColor {
    return UIColor.UIColorHex_Alpha(value, alpha: alpha)
}


func stringCompare(_ aString : String?,_ bString : String?) -> Bool {
    if aString?.uppercased().compare(bString?.uppercased() ?? "").rawValue == 0 {
        return true
    } else {
        return false
    }
}
func stringCompareOrig(_ aString : String?,_ bString : String?) -> Bool {
    if aString?.compare(bString ?? "").rawValue == 0 {
        return true
    } else {
        return false
    }
}

func clearZero(_ number: String) -> String {
    var outNumber = number
    var i = 1

    if number.contains(".") {
        while i < number.count {
            if outNumber.hasSuffix("0") {
                outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
                i = i + 1
            } else {
                break
            }
        }
        if outNumber.hasSuffix("."){
            outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
        }
        return outNumber
    } else {
        return number
    }
}
