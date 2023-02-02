//
//  DappWebViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import MBProgressHUD
import BigInt
import walletverse_ios_sdk

class DappWebViewController: BaseViewController {
    var dappModel : DappModel?
    
    var decimalChain : String = "18"
    var value : String = ""
    var fee : [String: String]?
    
    var method : String?
    var id : String?
    var chain : String?
    var dappJsonModel : DappJsonModel?
    
    lazy var webView : DappWebview = {
        let webView = DappWebview(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height))
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    func initData() {
        let coinDecimals = CoinDecimals(chainId: Chains[dappModel?.chain ?? ""]?["chainId"] ?? "",contractAddress: "")
//        let decimalParams = JSCoreParams()
//            .put(key: "chainId", value: ) ?? JSCoreParams()
        Walletverse.decimals(params: coinDecimals) { (returnData) in
            if let decimal = returnData {
                self.decimalChain = decimal as? String ?? "18"
            }
        }
    }
    
    override func configUI() {
        baseNaviBar.isHidden = false
        initBaseNaviLeft()
        baseNaviTitle.text = dappModel?.name
        if let url = URL(string: dappModel?.url ?? "") {
            var request = NSURLRequest(url: url) as URLRequest
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            webView.dappModel = dappModel
            webView.dappDelegate = self
            webView.load(request)
            webView.frame = CGRect(x: 0, y: 0, width: baseMainV.width, height: baseMainV.height)
            baseMainV.addSubview(webView)
        }
    }
    
    func formatToPrecision(_ bigNumber: BigUInt, numberDecimals: Int = 18, formattingDecimals: Int = 4, decimalSeparator: String = ".", fallbackToScientific: Bool = false) -> String? {
        if bigNumber == 0 {
            return "0"
        }
        let unitDecimals = numberDecimals
        var toDecimals = formattingDecimals
        if unitDecimals < toDecimals {
            toDecimals = unitDecimals
        }
        let divisor = BigUInt(10).power(unitDecimals)
        let (quotient, remainder) = bigNumber.quotientAndRemainder(dividingBy: divisor)
        var fullRemainder = String(remainder);
        let fullPaddedRemainder = fullRemainder.leftPadding(toLength: unitDecimals, withPad: "0")
        let remainderPadded = fullPaddedRemainder[0..<toDecimals]
        if remainderPadded == String(repeating: "0", count: toDecimals) {
            if quotient != 0 {
                return String(quotient)
            } else if fallbackToScientific {
                var firstDigit = 0
                for char in fullPaddedRemainder {
                    if (char == "0") {
                        firstDigit = firstDigit + 1;
                    } else {
                        let firstDecimalUnit = String(fullPaddedRemainder[firstDigit ..< firstDigit+1])
                        var remainingDigits = ""
                        let numOfRemainingDecimals = fullPaddedRemainder.count - firstDigit - 1
                        if numOfRemainingDecimals <= 0 {
                            remainingDigits = ""
                        } else if numOfRemainingDecimals > formattingDecimals {
                            let end = firstDigit+1+formattingDecimals > fullPaddedRemainder.count ? fullPaddedRemainder.count : firstDigit+1+formattingDecimals
                            remainingDigits = String(fullPaddedRemainder[firstDigit+1 ..< end])
                        } else {
                            remainingDigits = String(fullPaddedRemainder[firstDigit+1 ..< fullPaddedRemainder.count])
                        }
                        if remainingDigits != "" {
                            fullRemainder = firstDecimalUnit + decimalSeparator + remainingDigits
                        } else {
                            fullRemainder = firstDecimalUnit
                        }
                        firstDigit = firstDigit + 1;
                        break
                    }
                }
                return fullRemainder + "e-" + String(firstDigit)
            }
        }
        if (toDecimals == 0) {
            return String(quotient)
        }
        return String(quotient) + decimalSeparator + remainderPadded
    }
    
    func valueTransformByDecimal(value: String, decimal: String) -> String {
        if value.starts(with: "0x") {
            var valueM : String? = value
            valueM = valueM?.replacingOccurrences(of: "0x", with: "")
            let decimalBig = BigUInt(valueM ?? "0x0",radix: 16)
            let valueStr = formatToPrecision(decimalBig ?? 0, numberDecimals: Int(decimal) ?? 18, formattingDecimals: 8, decimalSeparator: ".", fallbackToScientific: false)
            return valueStr ?? ""
        } else {
            let decimalBig = BigUInt(value)
            let valueStr = formatToPrecision(decimalBig ?? 0, numberDecimals: Int(decimal) ?? 18, formattingDecimals: 8, decimalSeparator: ".", fallbackToScientific: false)
            return valueStr ?? ""
        }
    }
    
    func verifyPassword(pwdString : String?) {
        let password = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
        if stringCompare(password, (pwdString ?? "")) {
            if stringCompare(method, "dappsSign") {
                dappsSignAction(password: pwdString ?? "")
            } else if stringCompare(method, "dappsSignSend") {
                dappsSignSendAction(password: pwdString ?? "")
            } else if stringCompare(method, "dappsSignMessage") {
                dappsSignMessageAction(password: pwdString ?? "")
            }
        } else {
            let alertV = CustomAlertView.init(title: "", message: LocalString("assets_paypwd_error"), preferredStyle: UIAlertController.Style.alert)
            alertV.addAction(UIAlertAction.init(title: LocalString("assets_inpput_again"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                let view = InputPasswordView()
                view.delegate = self
                view.show()
            }))
            self.present(alertV, animated: true, completion: nil)
        }
    }
    
    func dappsSignAction(password: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let walletCoinModel = Walletverse.getWalletCoinModel()
        walletCoinModel.wid = dappModel?.wid
        walletCoinModel.contract = Chains[dappModel?.chain ?? ""]?["contract"]
        walletCoinModel.symbol = Chains[dappModel?.chain ?? ""]?["symbol"]
        walletCoinModel.address = ""
        
        Walletverse.queryWalletCoin(walletCoinModel: walletCoinModel) { (result) in
            if let coinModel = result {
                
                let decodeParams = JSCoreParams().put(key: "message", value: coinModel.privateKey ?? "")?.put(key: "password", value: password) ?? JSCoreParams()
                Walletverse.decodeMessage(params: decodeParams) { (returnData, error) in
                    if let privateKey = returnData {
                        let chainNonce = ChainNonce(chainId: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "", address: coinModel.address ?? "")
                        Walletverse.nonce(params: chainNonce) { (returnData) in
                            if let nonce = returnData {

                                let signParams = SignTransactionParams(chainId: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "", privateKey: privateKey as? String ?? "", to: self.dappJsonModel?.to ?? "", value: self.value, decimals: Int(self.decimalChain), gasPrice: self.fee?["gasPrice"] ?? "0", gasLimit: self.fee?["gasLimit"] ?? "0", nonce: "\(nonce)", inputData: self.dappJsonModel?.data, contractAddress: "")
                                Walletverse.signDAppTransaction(params: signParams) { (returnData) in
                                    if let sign = returnData {
                                        self.webView.methodCallback(id: self.id ?? "", err: "", data: sign)
                                        MBProgressHUD.hide(for: self.view, animated: false)
                                    } else {
                                        MBProgressHUD.hide(for: self.view, animated: false)
                                    }
                                }
                            } else {
                                MBProgressHUD.hide(for: self.view, animated: false)
                            }
                        }
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: false)
                    }
                }
            } else {
                MBProgressHUD.hide(for: self.view, animated: false)
            }
        }
    }
    
//    func dappsSignAction(password: String) {
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//
//        let walletCoinModel = WalletCoinModel()
//        walletCoinModel.wid = dappModel?.wid
//        walletCoinModel.contract = Chains[dappModel?.chain ?? ""]?["contract"]
//        walletCoinModel.symbol = Chains[dappModel?.chain ?? ""]?["symbol"]
//        walletCoinModel.address = ""
//
//        Walletverse.queryWalletCoin(walletCoinModel: walletCoinModel) { (result) in
//            if let coinModel = result {
//
//                let decodeParams = JSCoreParams().put(key: "message", value: coinModel.privateKey ?? "")?.put(key: "password", value: password) ?? JSCoreParams()
//                Walletverse.decodeMessage(params: decodeParams) { (returnData, error) in
//                    if let privateKey = returnData {
//                        let chainNonce = ChainNonce(chainId: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "", address: coinModel.address ?? "")
//
////                        let nonceParams = JSCoreParams()
////                            .put(key: "chainId", value: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "")?
////                            .put(key: "address", value: coinModel.address ?? "") ?? JSCoreParams()
//                        Walletverse.nonce(params: chainNonce) { (returnData, error) in
//                            if let nonce = returnData {
//
//                                let signParams = SignTransactionParams(chainId: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "", privateKey: privateKey as? String ?? "", to: self.dappJsonModel?.to ?? "", value: self.value, decimals: Int(self.decimalChain), gasPrice: self.fee?["gasPrice"] ?? "0", gasLimit: self.fee?["gasLimit"] ?? "0", nonce: "\(nonce)", inputData: self.dappJsonModel?.data, contractAddress: "")
//                                Walletverse.signDAppTransaction(params: signParams) { (returnData) in
//                                    if let sign = returnData {
//                                        self.webView.methodCallback(id: self.id ?? "", err: "", data: sign)
//                                        MBProgressHUD.hide(for: self.view, animated: false)
//                                    } else {
//                                        MBProgressHUD.hide(for: self.view, animated: false)
//                                    }
//                                }
//                            } else {
//                                MBProgressHUD.hide(for: self.view, animated: false)
//                            }
//                        }
//                    } else {
//                        MBProgressHUD.hide(for: self.view, animated: false)
//                    }
//                }
//            } else {
//                MBProgressHUD.hide(for: self.view, animated: false)
//            }
//        }
//    }
    
    func dappsSignSendAction(password: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let walletCoinModel = Walletverse.getWalletCoinModel()
        walletCoinModel.wid = dappModel?.wid
        walletCoinModel.contract = Chains[dappModel?.chain ?? ""]?["contract"]
        walletCoinModel.symbol = Chains[dappModel?.chain ?? ""]?["symbol"]
        walletCoinModel.address = ""
        
        Walletverse.queryWalletCoin(walletCoinModel: walletCoinModel) { (result) in
            if let coinModel = result {
                
                let decodeParams = JSCoreParams().put(key: "message", value: coinModel.privateKey ?? "")?.put(key: "password", value: password) ?? JSCoreParams()
                Walletverse.decodeMessage(params: decodeParams) { (returnData, error) in
                    if let privateKey = returnData {
                        let chainNonce = ChainNonce(chainId: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "", address: coinModel.address ?? "")
                        Walletverse.nonce(params: chainNonce) { (returnData) in
                            if let nonce = returnData {
                                
                                let signParams = SignTransactionParams(chainId: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "", privateKey: privateKey as? String ?? "", to: self.dappJsonModel?.to ?? "", value: self.value, decimals: Int(self.decimalChain), gasPrice: self.fee?["gasPrice"] ?? "0", gasLimit: self.fee?["gasLimit"] ?? "0", nonce: "\(nonce)", inputData: self.dappJsonModel?.data, contractAddress: "")
                                Walletverse.signDAppTransaction(params: signParams) { (returnData) in
                                    if let sign = returnData {
                                        
                                        let transactionParams = TransactionParams(chainId: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "", from: self.dappJsonModel?.from ?? "", to: self.dappJsonModel?.to ?? "", sign: sign, value: self.value, contractAddress: "")
                                        Walletverse.transaction(params: transactionParams) { (returnData) in
                                            if let hash = returnData {
                                                self.webView.methodCallback(id: self.id ?? "", err: "", data: hash)
                                            }
                                            MBProgressHUD.hide(for: self.view, animated: false)
                                        }
                                    } else {
                                        MBProgressHUD.hide(for: self.view, animated: false)
                                    }
                                }
                            } else {
                                MBProgressHUD.hide(for: self.view, animated: false)
                            }
                        }
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: false)
                    }
                }
            } else {
                MBProgressHUD.hide(for: self.view, animated: false)
            }
        }
    }
    
//    func dappsSignSendAction(password: String) {
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//
//        let walletCoinModel = WalletCoinModel()
//        walletCoinModel.wid = dappModel?.wid
//        walletCoinModel.contract = Chains[dappModel?.chain ?? ""]?["contract"]
//        walletCoinModel.symbol = Chains[dappModel?.chain ?? ""]?["symbol"]
//        walletCoinModel.address = ""
//
//        Walletverse.queryWalletCoin(walletCoinModel: walletCoinModel) { (result) in
//            if let coinModel = result {
//
//                let decodeParams = JSCoreParams().put(key: "message", value: coinModel.privateKey ?? "")?.put(key: "password", value: password) ?? JSCoreParams()
//                Walletverse.decodeMessage(params: decodeParams) { (returnData, error) in
//                    if let privateKey = returnData {
//
//                        let nonceParams = JSCoreParams()
//                            .put(key: "chainId", value: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "")?
//                            .put(key: "address", value: coinModel.address ?? "") ?? JSCoreParams()
//                        Walletverse.nonce(params: nonceParams) { (returnData, error) in
//                            if let nonce = returnData {
//
//                                let signParams = SignTransactionParams(chainId: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "", privateKey: privateKey as? String ?? "", to: self.dappJsonModel?.to ?? "", value: self.value, decimals: Int(self.decimalChain), gasPrice: self.fee?["gasPrice"] ?? "0", gasLimit: self.fee?["gasLimit"] ?? "0", nonce: "\(nonce)", inputData: self.dappJsonModel?.data, contractAddress: "")
//                                Walletverse.signDAppTransaction(params: signParams) { (returnData) in
//                                    if let sign = returnData {
//
//                                        let transactionParams = TransactionParams(chainId: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "", from: self.dappJsonModel?.from ?? "", to: self.dappJsonModel?.to ?? "", sign: sign, value: self.value, contractAddress: "")
//                                        Walletverse.transaction(params: transactionParams) { (returnData) in
//                                            if let hash = returnData {
//                                                self.webView.methodCallback(id: self.id ?? "", err: "", data: hash)
//                                            }
//                                            MBProgressHUD.hide(for: self.view, animated: false)
//                                        }
//                                    } else {
//                                        MBProgressHUD.hide(for: self.view, animated: false)
//                                    }
//                                }
//                            } else {
//                                MBProgressHUD.hide(for: self.view, animated: false)
//                            }
//                        }
//                    } else {
//                        MBProgressHUD.hide(for: self.view, animated: false)
//                    }
//                }
//            } else {
//                MBProgressHUD.hide(for: self.view, animated: false)
//            }
//        }
//    }
    
    func dappsSignMessageAction(password: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let walletCoinModel = Walletverse.getWalletCoinModel()
        walletCoinModel.wid = dappModel?.wid
        walletCoinModel.contract = Chains[dappModel?.chain ?? ""]?["contract"]
        walletCoinModel.symbol = Chains[dappModel?.chain ?? ""]?["symbol"]
        walletCoinModel.address = ""
        
        Walletverse.queryWalletCoin(walletCoinModel: walletCoinModel) { (result) in
            if let coinModel = result {
                
                let decodeParams = JSCoreParams().put(key: "message", value: coinModel.privateKey ?? "")?.put(key: "password", value: password) ?? JSCoreParams()
                Walletverse.decodeMessage(params: decodeParams) { (returnData, error) in
                    if let privateKey = returnData {
                        let chainNonce = ChainNonce(chainId: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "", address: coinModel.address ?? "")
                    
                        Walletverse.nonce(params: chainNonce) { (returnData) in
                            if let nonce = returnData {
                                
                                let signParams = DAppMessageParams(data: self.dappJsonModel?.data, __type: self.dappJsonModel?.__type, privateKey: privateKey as? String ?? "", nonce: "\(nonce)")
                                let signMessageParams = SignMessageParams(chainId: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "", privateKey: privateKey as? String ?? "", message: signParams)
                                Walletverse.signMessage(params: signMessageParams) { (returnData) in
                                    if let signMessage = returnData {
                                        self.webView.methodCallback(id: self.id ?? "", err: "", data: signMessage)
                                        MBProgressHUD.hide(for: self.view, animated: false)
                                    } else {
                                        MBProgressHUD.hide(for: self.view, animated: false)
                                    }
                                }
                            } else {
                                MBProgressHUD.hide(for: self.view, animated: false)
                            }
                        }
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: false)
                    }
                }
            } else {
                MBProgressHUD.hide(for: self.view, animated: false)
            }
        }
    }
    
//    func dappsSignMessageAction(password: String) {
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//
//        let walletCoinModel = WalletCoinModel()
//        walletCoinModel.wid = dappModel?.wid
//        walletCoinModel.contract = Chains[dappModel?.chain ?? ""]?["contract"]
//        walletCoinModel.symbol = Chains[dappModel?.chain ?? ""]?["symbol"]
//        walletCoinModel.address = ""
//
//        Walletverse.queryWalletCoin(walletCoinModel: walletCoinModel) { (result) in
//            if let coinModel = result {
//
//                let decodeParams = JSCoreParams().put(key: "message", value: coinModel.privateKey ?? "")?.put(key: "password", value: password) ?? JSCoreParams()
//                Walletverse.decodeMessage(params: decodeParams) { (returnData, error) in
//                    if let privateKey = returnData {
//
//                        let nonceParams = JSCoreParams()
//                            .put(key: "chainId", value: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "")?
//                            .put(key: "address", value: coinModel.address ?? "") ?? JSCoreParams()
//                        Walletverse.nonce(params: nonceParams) { (returnData, error) in
//                            if let nonce = returnData {
//
//                                let signParams = DAppMessageParams(data: self.dappJsonModel?.data, __type: self.dappJsonModel?.__type, privateKey: privateKey as? String ?? "", nonce: "\(nonce)")
//                                let signMessageParams = SignMessageParams(chainId: Chains[self.dappModel?.chain ?? ""]?["chainId"] ?? "", privateKey: privateKey as? String ?? "", message: signParams)
//                                Walletverse.signMessage(params: signMessageParams) { (returnData) in
//                                    if let signMessage = returnData {
//                                        self.webView.methodCallback(id: self.id ?? "", err: "", data: signMessage)
//                                        MBProgressHUD.hide(for: self.view, animated: false)
//                                    } else {
//                                        MBProgressHUD.hide(for: self.view, animated: false)
//                                    }
//                                }
//                            } else {
//                                MBProgressHUD.hide(for: self.view, animated: false)
//                            }
//                        }
//                    } else {
//                        MBProgressHUD.hide(for: self.view, animated: false)
//                    }
//                }
//            } else {
//                MBProgressHUD.hide(for: self.view, animated: false)
//            }
//        }
//    }
    
    func dappsSign(method: String, id: String, chain: String, data: String, model: DappJsonModel?) {
        let value = valueTransformByDecimal(value: model?.value ?? "0", decimal: decimalChain)
        self.value = value
        
        let coinFee = CoinFee(chainId: Chains[dappModel?.chain ?? ""]?["chainId"] ?? "",from: model?.from ?? "", to: model?.to ?? "", value: value, decimals: decimalChain, data: model?.data ?? "")
        Walletverse.fee(params: coinFee) { (returnData) in
            if let fee = returnData {
                self.fee = [String: String]()
                self.fee?["gasPrice"] = fee.gasPrice
                self.fee?["gasLimit"] = fee.gasLimit
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: false)
                    
                    let view = DappTransferView()
                    view.delegate = self
                    view.setData(dappModel : self.dappModel,dappJsonModel : self.dappJsonModel,fee : fee as? [String : String])
                    view.show()
                }
            }
        }
    }
    
//    func dappsSign(method: String, id: String, chain: String, data: String, model: DappJsonModel?) {
//        let value = valueTransformByDecimal(value: model?.value ?? "0", decimal: decimalChain)
//        self.value = value
//        let feeParams = JSCoreParams()
//            .put(key: "chainId", value: Chains[dappModel?.chain ?? ""]?["chainId"] ?? "")?
//            .put(key: "from", value: model?.from ?? "")?
//            .put(key: "to", value: model?.to ?? "")?
//            .put(key: "value", value: value)?
//            .put(key: "decimals", value: decimalChain)?
//            .put(key: "data", value: model?.data ?? "") ?? JSCoreParams()
//        Walletverse.fee(params: feeParams) { (returnData, error) in
//            if let fee = returnData {
//                self.fee = fee as? [String: String]
//                DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: false)
//
//                    let view = DappTransferView()
//                    view.delegate = self
//                    view.setData(dappModel : self.dappModel,dappJsonModel : self.dappJsonModel,fee : fee as? [String : String])
//                    view.show()
//                }
//            }
//        }
//    }
    
    func dappsSignSend(method: String, id: String, chain: String, data: String, model: DappJsonModel?) {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        let value = valueTransformByDecimal(value: model?.value ?? "0", decimal: decimalChain)
        self.value = value
        let coinFee = CoinFee(chainId: Chains[dappModel?.chain ?? ""]?["chainId"] ?? "",from: model?.from ?? "", to: model?.to ?? "", value: value, decimals: decimalChain, data: model?.data ?? "")
        Walletverse.fee(params: coinFee) { (returnData) in
            if let fee = returnData {
                self.fee = [String: String]()
                self.fee?["gasPrice"] = fee.gasPrice
                self.fee?["gasLimit"] = fee.gasLimit
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: false)
                    
                    let view = DappTransferView()
                    view.delegate = self
                    view.setData(dappModel : self.dappModel,dappJsonModel : self.dappJsonModel,fee : fee as? [String : String])
                    view.show()
                }
            }
        }
    }
    
//    func dappsSignSend(method: String, id: String, chain: String, data: String, model: DappJsonModel?) {
//        DispatchQueue.main.async {
//            MBProgressHUD.showAdded(to: self.view, animated: true)
//        }
//        let value = valueTransformByDecimal(value: model?.value ?? "0", decimal: decimalChain)
//        self.value = value
//        let feeParams = JSCoreParams()
//            .put(key: "chainId", value: Chains[dappModel?.chain ?? ""]?["chainId"] ?? "")?
//            .put(key: "from", value: model?.from ?? "")?
//            .put(key: "to", value: model?.to ?? "")?
//            .put(key: "value", value: value)?
//            .put(key: "decimals", value: decimalChain)?
//            .put(key: "data", value: model?.data ?? "") ?? JSCoreParams()
//        Walletverse.fee(params: feeParams) { (returnData, error) in
//            if let fee = returnData {
//                self.fee = fee as? [String: String]
//                DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: false)
//
//                    let view = DappTransferView()
//                    view.delegate = self
//                    view.setData(dappModel : self.dappModel,dappJsonModel : self.dappJsonModel,fee : fee as? [String : String])
//                    view.show()
//                }
//            }
//        }
//    }
    
    func dappsSignMessage(method: String, id: String, chain: String, data: String, model: DappJsonModel?) {
        DispatchQueue.main.async {
            let view = InputPasswordView()
            view.delegate = self
            view.show()
        }
    }
}

extension DappWebViewController : DappWebviewDelegate {
    func DappMessageDelegate(json: JSON?) {
        if json?.count ?? 0 >= 4 {
            let method : String = json?[0].string ?? ""
            let id : String = json?[1].string ?? ""
            let chain : String = json?[2].string ?? ""
            let data : String = json?[3].string ?? ""
            
            self.method = method
            self.id = id
            self.chain = chain
            
            if let model = DappJsonModel.deserialize(from: data) {
                self.dappJsonModel = model
                DispatchQueue.global().async {
                    if stringCompare(method, "dappsSign") {
                        self.dappsSign(method: method, id: id, chain: chain, data: data, model : model)
                    } else if stringCompare(method, "dappsSignSend") {
                        self.dappsSignSend(method: method, id: id, chain: chain, data: data, model : model)
                    } else if stringCompare(method, "dappsSignMessage") {
                        self.dappsSignMessage(method: method, id: id, chain: chain, data: data, model : model)
                    }
                }
            }
        }
    }
}

extension DappWebViewController : DappTransferViewDelegate {
    func vertifyPay() {
        let view = InputPasswordView()
        view.delegate = self
        view.show()
    }
}

extension DappWebViewController : InputPasswordViewDelegate {
    func inputPasswordDelegate(pwd: String) {
        verifyPassword(pwdString : pwd)
    }
}
