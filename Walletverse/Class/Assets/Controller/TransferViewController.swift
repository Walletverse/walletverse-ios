//
//  TransferViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/10.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import BigInt
import MBProgressHUD
import walletverse_ios_sdk

class TransferViewController: BaseViewController {
    
    var identityModel: IdentityModel?
    var walletCoin: WalletCoinModel?
    
    var fee : [String: String]?
    var curPrice: BigUInt?
    var curLimit: BigUInt?
    var currentIndex: Int = 3
    
    var inputData : String?
    
    var isShowFee = false
    
    var keyboardHeight:CGFloat = 0.0
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        return scrollView
    }()
    
    lazy var scanBtn : UIButton = {
        return CustomView.buttonCustom(normalImage: UIImage(named: "AssetsTransferScan"), selectedImage: UIImage(named: "AssetsTransferScan"))
    }()
    
    var toV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    lazy var toL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_to"), font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    lazy var addressTF : UITextField = {
        return CustomView.textFieldCustom(text: "", font: FontSystem(size: 16), color: Color_1C1E27, delegate: self, placeholder: LocalString("asserts_to"),tintColor:Color_7D7F86)
    }()
    
    var amountV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    lazy var amountTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_amount"), font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    lazy var availableL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_available"), font: FontSystem(size: 14), color: Color_1C1E27)
    }()
    
    lazy var amountTF : UITextField = {
        return CustomView.textFieldCustom(text: "", font: FontSystem(size: 16), color: Color_1C1E27, delegate: self, placeholder: "0.00",tintColor:Color_7D7F86)
    }()
    
    lazy var totalPriceL : UILabel = {
        return CustomView.labelCustom(text: "=$0", font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    var feeV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    lazy var feeTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_fee"), font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    lazy var feeL : UILabel = {
        return CustomView.labelCustom(text: "0.00", font: FontSystemBold(size: 14), color: Color_1C1E27)
    }()
    
    lazy var feeDetailL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    lazy var arrowIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "MineRightArrow"))
    }()
    
    lazy var transferBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("asserts_transfer"), font: FontSystemBold(size: 14), color: Color_FFFFFF, cornerRadius: 4, backColor: Color_0072DB)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBaseNaviLeft()
        baseNaviTitle.text = walletCoin?.symbol ?? ""
        
        registerNotification()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: baseMainV.width, height: baseMainV.height - ZSCREENBOTTOM)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        scrollView.addGestureRecognizer(tapGesture)
        baseMainV.addSubview(scrollView)
        
        scanBtn.frame = CGRect(x: ZSCREENWIDTH - 50, y: ZSCREENNAVIBAR - 44, width: 44, height: 44)
        scanBtn.addTarget(self, action: #selector(scanBtnClick), for: .touchUpInside)
        baseNaviBar.addSubview(scanBtn)
        
        toV.frame = CGRect(x: 20, y: 30, width: ZSCREENWIDTH - 40, height: 90)
        toV.layer.cornerRadius = 4
        toV.clipsToBounds = true
        toV.layer.borderWidth = 1
        toV.layer.borderColor = Color_F0F1F5.cgColor
        
        scrollView.addSubview(toV)
        
        amountV.frame = CGRect(x: 20, y: toV.bottom + 20, width: ZSCREENWIDTH - 40, height: 100)
        amountV.layer.cornerRadius = 4
        amountV.clipsToBounds = true
        amountV.layer.borderWidth = 1
        amountV.layer.borderColor = Color_F0F1F5.cgColor
        scrollView.addSubview(amountV)
        
        feeV.frame = CGRect(x: 20, y: amountV.bottom + 20, width: ZSCREENWIDTH - 40, height: 90)
        feeV.layer.cornerRadius = 4
        feeV.clipsToBounds = true
        feeV.layer.borderWidth = 1
        feeV.layer.borderColor = Color_F0F1F5.cgColor
        let feeGesture = UITapGestureRecognizer.init(target: self, action: #selector(feeGestureClick))
        feeV.addGestureRecognizer(feeGesture)
        scrollView.addSubview(feeV)
        
        toL.frame = CGRect(x: 20, y: 15, width: toV.width - 40, height: 20)
        toV.addSubview(toL)
        
        addressTF.frame = CGRect(x: 20, y: toL.bottom, width: toV.width - 40, height: 40)
        addressTF.addTarget(self, action: #selector(addressLimit(textField:)), for: .editingChanged)
        toV.addSubview(addressTF)
        
        amountTipL.frame = CGRect(x: 20, y: 15, width: (toV.width - 40)/3, height: 20)
        amountV.addSubview(amountTipL)
        
        availableL.frame = CGRect(x: amountTipL.right, y: 15, width: (toV.width - 40)/3*2, height: 20)
        availableL.textAlignment = .right
        amountV.addSubview(availableL)
        
        amountTF.frame = CGRect(x: 20, y: amountTipL.bottom, width: (toV.width - 40), height: 30)
        amountTF.addTarget(self, action: #selector(amountLimit(textField:)), for: .editingChanged)
        amountTF.keyboardType = .decimalPad
        amountV.addSubview(amountTF)
        
        totalPriceL.frame = CGRect(x: 20, y: amountTF.bottom, width: (toV.width - 40), height: 20)
        amountV.addSubview(totalPriceL)
        
        
        feeTipL.frame = CGRect(x: 20, y: 15, width: (toV.width - 40)/3, height: 20)
        feeV.addSubview(feeTipL)
        
        feeL.frame = CGRect(x: 20, y: feeTipL.bottom, width: (toV.width - 40), height: 20)
        feeV.addSubview(feeL)
        
        feeDetailL.frame = CGRect(x: 20, y: feeL.bottom, width: (toV.width - 40), height: 20)
        feeV.addSubview(feeDetailL)
        
        arrowIV.frame = CGRect(x: feeV.width - 21, y: (feeV.height - 12)/2, width: 6, height: 12)
        feeV.addSubview(arrowIV)
        
        transferBtn.frame = CGRect(x: 15, y: amountV.bottom + 140, width: ZSCREENWIDTH - 30, height: 44)
        transferBtn.layer.cornerRadius = 22
        transferBtn.clipsToBounds = true
        transferBtn.addTarget(self, action: #selector(transferBtnClick), for: .touchUpInside)
        scrollView.addSubview(transferBtn)
        
        if transferBtn.bottom + 20 > baseMainV.height - ZSCREENBOTTOM {
            scrollView.contentSize = CGSize(width: scrollView.width,height: transferBtn.bottom + 200)
        } else {
            scrollView.contentSize = CGSize(width: scrollView.width,height: baseMainV.height - ZSCREENBOTTOM)
        }
        
        feeV.isHidden = true
        availableL.text = LocalString("asserts_available") + ":" + (walletCoin?.balance ?? "")
    }
    
    func registerNotification() {
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification , object: nil)
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillChange(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func configData() {
        if fee != nil {
            let gasPrice = BigUInt(fee?["gasPrice"] ?? "0") ?? 0
            curPrice = gasPrice
            let gasLimit = BigUInt(fee?["gasLimit"] ?? "0") ?? 0
            curLimit = gasLimit
            let gas = gasPrice * gasLimit
            let curGas = Double(gas)/1e18
            let gw = Double(gasPrice)/1e9
            if (walletCoin?.contract?.uppercased() == "KCC") {
                feeL.text = clearZero(String(format: "%.7F",curGas)) + " KCS"
            } else {
                feeL.text = clearZero(String(format: "%.7F",curGas)) + " " + (walletCoin?.contract ?? "")
            }
            
            feeDetailL.text = "GasPrice(" + clearZero(String(format: "%.7F",gw)) + "GWEI)*GasLimit(\(fee?["gasLimit"] ?? "0"))"
        }
        
    }
    
    func showFee() {
        isShowFee = true
        feeV.isHidden = false
    }
    
    func hiddenFee() {
        isShowFee = false
        feeV.isHidden = true
    }
    
    func getGasPriceAndLimit(address: String, toAmount: String) {
        if (walletCoin?.type == "COIN" && toAmount == "0") {
            hiddenFee()
            return
        }
        
        if (isShowFee == false) {
            if (walletCoin?.type == "COIN") {
                let hexParams = JSCoreParams()
                    .put(key: "value", value: toAmount)?
                    .put(key: "decimals", value: walletCoin?.decimals ?? "") ?? JSCoreParams()
                Walletverse.toHex(params: hexParams) { (returnData, error) in
                    if let hex = returnData {
                        let encodeERC20ABIParams = EncodeERC20ABIParams(chainId: self.walletCoin?.chainId ?? "", contractMethod: "transfer", contractAddress: self.walletCoin?.contractAddress, params: [self.addressTF.text ?? "", hex as? String ?? ""], abi: nil)
                        Walletverse.encodeERC20ABI(params: encodeERC20ABIParams) { (returnData, error) in
                            if let inputData = returnData {
                                self.inputData = inputData as? String
                                let coinFee = CoinFee(chainId: self.walletCoin?.chainId ?? "",from: self.walletCoin?.address ?? "", to: self.walletCoin?.type == "CHAIN" ? address : self.walletCoin?.contractAddress ?? "", value: "0", decimals: self.walletCoin?.decimals ?? "", data: self.inputData)
                                Walletverse.fee(params: coinFee) { (returnData) in
                                    if let fee = returnData {
                                        self.fee = [String: String]()
                                        self.fee?["gasPrice"] = fee.gasPrice
                                        self.fee?["gasLimit"] = fee.gasLimit
                                        self.configData()
                                        self.showFee()
                                    } else {
                                        self.hiddenFee()
                                    }
                                }
                                
                                
//                                let feeParams = JSCoreParams()
//                                    .put(key: "chainId", value: self.walletCoin?.chainId ?? "")?
//                                    .put(key: "from", value: self.walletCoin?.address ?? "")?
//                                    .put(key: "to", value: self.walletCoin?.type == "CHAIN" ? address : self.walletCoin?.contractAddress ?? "")?
//                                    .put(key: "value", value:"0")?
//                                    .put(key: "decimals", value:self.walletCoin?.decimals ?? "")?
//                                    .put(key: "data", value: inputData) ?? JSCoreParams()
//                                Walletverse.fee(params: feeParams) { (returnData, error) in
//                                    if let fee = returnData {
//                                        self.fee = fee as? [String: String]
//                                        self.configData()
//                                        self.showFee()
//                                    } else {
//                                        self.hiddenFee()
//                                    }
//                                }
                            } else {
                                self.hiddenFee()
                            }
                        }
                    } else {
                        self.hiddenFee()
                    }
                }
            } else {
                let coinFee = CoinFee(chainId: self.walletCoin?.chainId ?? "",from: self.walletCoin?.address ?? "", to: self.walletCoin?.type == "CHAIN" ? address : self.walletCoin?.contractAddress ?? "", value: toAmount, decimals: self.walletCoin?.decimals ?? "", data: "")
                Walletverse.fee(params: coinFee) { (returnData) in
                    if let fee = returnData {
                        self.fee = [String: String]()
                        self.fee?["gasPrice"] = fee.gasPrice
                        self.fee?["gasLimit"] = fee.gasLimit
                        self.configData()
                        self.showFee()
                    } else {
                        self.hiddenFee()
                    }
                }
                
                
                
//                let feeParams = JSCoreParams()
//                    .put(key: "chainId", value: self.walletCoin?.chainId ?? "")?
//                    .put(key: "from", value: self.walletCoin?.address ?? "")?
//                    .put(key: "to", value: self.walletCoin?.type == "CHAIN" ? address : self.walletCoin?.contractAddress ?? "")?
//                    .put(key: "value", value:toAmount)?
//                    .put(key: "decimals", value:self.walletCoin?.decimals ?? "")?
//                    .put(key: "data", value: "") ?? JSCoreParams()
//                Walletverse.fee(params: feeParams) { (returnData, error) in
//                    if let fee = returnData {
//                        self.fee = fee as? [String: String]
//                        self.configData()
//                        self.showFee()
//                    } else {
//                        self.hiddenFee()
//                    }
//                }
            }
        }
    }
    
    @objc func tapClick() {
        view.endEditing(true)
    }
    
    @objc func scanBtnClick() {
        let vc = TransferScanViewController()
        vc.scanResultDelegate = self
        vc.setStyle()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addressLimit(textField:UITextField) {
        if let address = addressTF.text {
            let addressParams = ValidateAddressParams(chainId: walletCoin?.chainId ?? "", address: address)
            Walletverse.validateAddress(params: addressParams) { (result) in
                if (result) {
                    if let amount = self.amountTF.text {
                        if (Double(amount) ?? 0 > 0) {
                            self.getGasPriceAndLimit(address: address, toAmount: amount)
                        } else {
                            self.getGasPriceAndLimit(address: address, toAmount: "0")
                        }
                    }
                } else {
                    self.hiddenFee()
                }
            }
        }
    }
    
    @objc func amountLimit(textField:UITextField) {
        if let address = addressTF.text {
            let addressParams = ValidateAddressParams(chainId: walletCoin?.chainId ?? "", address: address)
            Walletverse.validateAddress(params: addressParams) { (result) in
                if (result) {
                    if let amount = self.amountTF.text {
                        if (Double(amount) ?? 0 > 0) {
                            self.getGasPriceAndLimit(address: address, toAmount: amount)
                        } else {
                            self.getGasPriceAndLimit(address: address, toAmount: "0")
                        }
                    }
                } else {
                    self.hiddenFee()
                }
            }
        }
    }
    
    @objc func feeGestureClick() {
        tapClick()
        if fee != nil {
            let controller = FeeViewController()
            controller.identityModel = identityModel
            controller.walletCoin = walletCoin
            controller.fee = fee
            controller.curPrice = curPrice
            controller.curLimit = curLimit
            controller.currentIndex = currentIndex
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func transferBtnClick() {
        tapClick()
        if (addressTF.text ?? "").isEmpty {
            CommonToastView.showToastAction(message: LocalString("asserts_address_tip"))
            return
        }
        if (amountTF.text ?? "").isEmpty {
            CommonToastView.showToastAction(message: LocalString("asserts_amount_tip"))
            return
        }
        if fee == nil {
            CommonToastView.showToastAction(message: LocalString("asserts_fee_tip"))
            return
        }
        
        let view = TransferView()
        view.delegate = self
        view.setData(amount: (amountTF.text ?? "0") + (walletCoin?.symbol ?? ""), to: addressTF.text ?? "", from: walletCoin?.address ?? "", gas: feeL.text, gasDetail: feeDetailL.text)
        view.show()
    }
    
    func verifyPassword(pwdString : String?) {
        let password = UserDefaultUtil.getValue(key: ZUSERDEFAULT_WALLETPASSWORD) as? String
        if stringCompare(password, (pwdString ?? "")) {
            signSendAction(password: pwdString ?? "")
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
    
    func signSendAction(password: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let hexParams = JSCoreParams()
            .put(key: "value", value: self.amountTF.text?.trimmingCharacters( in : .whitespaces) ?? "0")?
            .put(key: "decimals", value: walletCoin?.decimals ?? "") ?? JSCoreParams()
        Walletverse.toHex(params: hexParams) { (returnData, error) in
            if let hex = returnData {
                let encodeERC20ABIParams = EncodeERC20ABIParams(chainId: self.walletCoin?.chainId ?? "", contractMethod: "transfer", contractAddress: self.walletCoin?.contractAddress, params: [self.addressTF.text ?? "", hex as? String ?? ""], abi: nil)
                Walletverse.encodeERC20ABI(params: encodeERC20ABIParams) { (returnData, error) in
                    if let inputData = returnData {
                        self.inputData = inputData as? String
                        let coinFee = CoinFee(chainId: self.walletCoin?.chainId ?? "",from: self.walletCoin?.address ?? "", to: self.walletCoin?.type == "CHAIN" ? self.addressTF.text?.trimmingCharacters( in : .whitespaces) ?? "" : self.walletCoin?.contractAddress ?? "", value: self.amountTF.text?.trimmingCharacters( in : .whitespaces) ?? "0", decimals: self.walletCoin?.decimals ?? "", data: self.inputData)
                        Walletverse.fee(params: coinFee) { (returnData) in
                            if let fee = returnData {
                                self.fee = [String: String]()
                                self.fee?["gasPrice"] = fee.gasPrice
                                self.fee?["gasLimit"] = fee.gasLimit

                                let signAndTransactionParams = SignAndTransactionParams(chainId: self.walletCoin?.chainId ?? "", privateKey: self.walletCoin?.privateKey ?? "", from: self.walletCoin?.address ?? "", to: self.addressTF.text?.trimmingCharacters( in : .whitespaces) ?? "", value: self.amountTF.text?.trimmingCharacters( in : .whitespaces) ?? "0", decimals: Int(self.walletCoin?.decimals ?? "18"), gasPrice: "\(self.curPrice ?? BigUInt(0))", gasLimit: "\(self.curLimit ?? BigUInt(0))", inputData: self.inputData, contractAddress: self.walletCoin?.contractAddress ?? "", walletPin: password)
                                Walletverse.signAndTransaction(params: signAndTransactionParams) { (result) in
                                    if let hash = result {
                                        CommonToastView.showToastAction(message: "Transfer Successfully")
                                        self.navigationController?.popViewController(animated: true)
                                    } else {
                                        MBProgressHUD.hide(for: self.view, animated: false)
                                    }
                                }
                            }
                        }

                        
//                        let feeParams = JSCoreParams()
//                            .put(key: "chainId", value: self.walletCoin?.chainId ?? "")?
//                            .put(key: "from", value: self.walletCoin?.address ?? "")?
//                            .put(key: "to", value: self.walletCoin?.type == "CHAIN" ? self.addressTF.text?.trimmingCharacters( in : .whitespaces) ?? "" : self.walletCoin?.contractAddress ?? "")?
//                            .put(key: "value", value: self.amountTF.text?.trimmingCharacters( in : .whitespaces) ?? "0")?
//                            .put(key: "decimals", value:self.walletCoin?.decimals ?? "")?
//                            .put(key: "data", value: inputData) ?? JSCoreParams()
//                        Walletverse.fee(params: feeParams) { (returnData, error) in
//                            if let fee = returnData {
//                                self.fee = fee as? [String: String]
//
//                                let signAndTransactionParams = SignAndTransactionParams(chainId: self.walletCoin?.chainId ?? "", privateKey: self.walletCoin?.privateKey ?? "", from: self.walletCoin?.address ?? "", to: self.addressTF.text?.trimmingCharacters( in : .whitespaces) ?? "", value: self.amountTF.text?.trimmingCharacters( in : .whitespaces) ?? "0", decimals: Int(self.walletCoin?.decimals ?? "18"), gasPrice: "\(self.curPrice ?? BigUInt(0))", gasLimit: "\(self.curLimit ?? BigUInt(0))", inputData: self.inputData, contractAddress: self.walletCoin?.contractAddress ?? "", walletPin: password)
//                                Walletverse.signAndTransaction(params: signAndTransactionParams) { (result) in
//                                    if let hash = result {
//                                        CommonToastView.showToastAction(message: "Transfer Successfully")
//                                        self.navigationController?.popViewController(animated: true)
//                                    } else {
//                                        MBProgressHUD.hide(for: self.view, animated: false)
//                                    }
//                                }
//                            }
//                        }
                    }
                }
            }
        }
    }
    
    @objc func keyBoardWillShow(_ notification : Notification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else{return}
        var duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        if duration == nil { duration = 0.25 }
        let keyboardTopYPosition = keyboardRect.height
        keyboardHeight = keyboardTopYPosition

        scrollView.size = CGSize(width: baseMainV.width, height: self.baseMainV.height - self.keyboardHeight - ZSCREENBOTTOM)
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.size = CGSize(width: self.baseMainV.width, height: self.baseMainV.height - self.keyboardHeight - ZSCREENBOTTOM)
        })
    }
    
    @objc func keyBoardWillHide(_ notification : Notification) {
        self.scrollView.size = CGSize(width: self.baseMainV.width, height: self.baseMainV.height - ZSCREENBOTTOM)
    }
    
    @objc func keyBoardWillChange(_ notification : Notification) {}
    
    deinit {
        ZNOTIFICATION.removeObserver(self)
    }
}

extension TransferViewController : FeeViewControllerDelegate {
    func selectFeeDelegate(price: BigUInt?, limit: BigUInt?, index: Int) {
        curPrice = price
        curLimit = limit
        currentIndex = index
        
//        let gasLimit = BigUInt(fee?["gasLimit"] ?? "0") ?? 0
        let gas = (curPrice ?? 0) * (curLimit ?? 0)
        let curGas = Double(gas)/1e18
        let gw = Double(curPrice!)/1e9
        if (walletCoin?.contract?.uppercased() == "KCC") {
            feeL.text = clearZero(String(format: "%.7F",curGas)) + " KCS"
        } else {
            feeL.text = clearZero(String(format: "%.7F",curGas)) + " " + (walletCoin?.contract ?? "")
        }
        
        feeDetailL.text = "GasPrice(\(String(format: "%.7F",gw)) GWEI)*GasLimit(\(Double(curLimit ?? 0)))"
    }
}

extension TransferViewController : ZGScanViewControllerDelegate {
    func scanFinished(scanResult: ZGScanResult, error: String?) {
        NSLog("scanResult:\(scanResult)")
        if let strScanned = scanResult.strScanned {
            addressTF.text = strScanned
        }
    }
}

extension TransferViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("kong" + string )
        if textField == amountTF {
            if string == "." {
                if (textField.text?.count ?? 0 == 0) {
                    textField.text = "0."
                    return false
                } else {
                    if textField.text?.contains(find: ".") ?? false {
                        return false
                    } else {
                        return true
                    }
                }
            } else {
                return true
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}

extension TransferViewController : TransferViewDelegate {
    func vertifyPay() {
        let view = InputPasswordView()
        view.delegate = self
        view.show()
    }
}

extension TransferViewController : InputPasswordViewDelegate {
    func inputPasswordDelegate(pwd: String) {
        verifyPassword(pwdString : pwd)
    }
}
