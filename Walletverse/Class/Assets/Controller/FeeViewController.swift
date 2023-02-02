//
//  FeeViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/10.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import BigInt
import walletverse_ios_sdk

protocol FeeViewControllerDelegate  {
    func selectFeeDelegate(price: BigUInt?, limit: BigUInt?, index: Int)
}

class FeeViewController: BaseViewController {
    
    var delegate: FeeViewControllerDelegate?
    
    var identityModel: IdentityModel?
    var walletCoin: WalletCoinModel?
    
    var fee : [String: String]?
    var curPrice: BigUInt?
    var curLimit: BigUInt?
    var basePrice: Double = 0
    var baseLimit: Double = 0
    
    var currentIndex: Int = 3
    
    var keyboardHeight:CGFloat = 0.0
    
    var isFirst = true
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        return scrollView
    }()
    
    
    lazy var feeTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_fee"), font: FontSystem(size: 14), color: Color_1C1E27)
    }()
    
    lazy var feeL : UILabel = {
        return CustomView.labelCustom(text: "0.00", font: FontSystemBold(size: 14), color: Color_5C74FF)
    }()
    
    lazy var feeDetailL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 12), color: Color_7D7F86)
    }()
    
    
    var fastestV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    lazy var fastestTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_fastest"), font: FontSystemBold(size: 14), color: Color_1C1E27)
    }()
    
    lazy var fastestL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    lazy var fastestTimeL : UILabel = {
        return CustomView.labelCustom(text: "< 0.5min", font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    lazy var fastestBtn : UIButton = {
        return CustomView.buttonCustom(normalImage: UIImage(named: "MineSelectImageNo"), selectedImage: UIImage(named: "MineSelectImage"))
    }()
    
    
    var fastV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    lazy var fastTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_fast"), font: FontSystemBold(size: 14), color: Color_1C1E27)
    }()
    
    lazy var fastL : UILabel = {
        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    lazy var fastTimeL : UILabel = {
        return CustomView.labelCustom(text: "< 2min", font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    lazy var fastBtn : UIButton = {
        return CustomView.buttonCustom(normalImage: UIImage(named: "MineSelectImageNo"), selectedImage: UIImage(named: "MineSelectImage"))
    }()
    
    
    var generalV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    lazy var generalTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_general"), font: FontSystemBold(size: 14), color: Color_1C1E27)
    }()
    
    lazy var generalL : UILabel = {
        return CustomView.labelCustom(text: "101.5 GWEI", font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    lazy var generalTimeL : UILabel = {
        return CustomView.labelCustom(text: "< 5min", font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    lazy var generalBtn : UIButton = {
        return CustomView.buttonCustom(normalImage: UIImage(named: "MineSelectImageNo"), selectedImage: UIImage(named: "MineSelectImage"))
    }()
    
    var advancedV : UIView = {
        return CustomView.viewCustom(color: Color_FFFFFF)
    }()
    
    lazy var advancedTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_advanced"), font: FontSystemBold(size: 14), color: Color_1C1E27)
    }()
    
    lazy var advancedTF : UITextField = {
        return CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_1C1E27, delegate: self, placeholder: "",tintColor:Color_7D7F86)
    }()
    
    lazy var advancedUnitL : UILabel = {
        return CustomView.labelCustom(text: "GWEI", font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
//    lazy var limitL : UILabel = {
//        return CustomView.labelCustom(text: "", font: FontSystem(size: 14), color: Color_1C1E27)
//    }()
    
    lazy var limitTF : UITextField = {
        return CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_1C1E27, delegate: self, placeholder: "",tintColor:Color_7D7F86)
    }()
    
    lazy var limitTipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("asserts_limit"), font: FontSystem(size: 14), color: Color_7D7F86)
    }()
    
    lazy var advancedBtn : UIButton = {
        return CustomView.buttonCustom(normalImage: UIImage(named: "MineSelectImageNo"), selectedImage: UIImage(named: "MineSelectImage"))
    }()
    
    lazy var confirmBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("confirm"), font: FontSystemBold(size: 14), color: Color_FFFFFF, cornerRadius: 4, backColor: Color_0072DB)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBaseNaviLeft()
        baseNaviTitle.text = LocalString("asserts_fee")
        
        registerNotification()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: baseMainV.width, height: baseMainV.height - ZSCREENBOTTOM)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        scrollView.addGestureRecognizer(tapGesture)
        baseMainV.addSubview(scrollView)
        
        feeTipL.frame = CGRect(x: 20, y: 15, width: (baseMainV.width - 40)/3, height: 20)
        scrollView.addSubview(feeTipL)
        
        feeL.frame = CGRect(x: feeTipL.right, y: 15, width: (baseMainV.width - 40)/3*2, height: 20)
        feeL.textAlignment = .right
        scrollView.addSubview(feeL)
        
        feeDetailL.frame = CGRect(x: 20, y: feeTipL.bottom, width: (baseMainV.width - 40), height: 20)
        scrollView.addSubview(feeDetailL)
        
        fastestV.frame = CGRect(x: 20, y: feeDetailL.bottom + 15, width: ZSCREENWIDTH - 40, height: 60)
        fastestV.layer.cornerRadius = 4
        fastestV.clipsToBounds = true
        fastestV.layer.borderWidth = 1
        fastestV.layer.borderColor = Color_F0F1F5.cgColor
        scrollView.addSubview(fastestV)
        
        fastestTipL.frame = CGRect(x: 15, y: 10, width: (fastestV.width - 30 - 40)/2, height: 20)
        fastestV.addSubview(fastestTipL)
        
        fastestL.frame = CGRect(x: 15, y: fastestTipL.bottom, width: (fastestV.width - 30 - 40) - 80, height: 20)
        fastestV.addSubview(fastestL)
        
        fastestTimeL.frame = CGRect(x: fastestL.right, y: 10, width: 80, height: 40)
        fastestTimeL.textAlignment = .right
        fastestV.addSubview(fastestTimeL)
        
        fastestBtn.frame = CGRect(x: fastestTimeL.right + 10, y: (fastestV.height - 30)/2, width: 30, height: 30)
        fastestBtn.addTarget(self, action: #selector(fastestBtnClick), for: .touchUpInside)
        fastestV.addSubview(fastestBtn)
        
        fastV.frame = CGRect(x: 20, y: fastestV.bottom + 15, width: ZSCREENWIDTH - 40, height: 60)
        fastV.layer.cornerRadius = 4
        fastV.clipsToBounds = true
        fastV.layer.borderWidth = 1
        fastV.layer.borderColor = Color_F0F1F5.cgColor
        scrollView.addSubview(fastV)
        
        fastTipL.frame = CGRect(x: 15, y: 10, width: (fastV.width - 30 - 40)/2, height: 20)
        fastV.addSubview(fastTipL)
        
        fastL.frame = CGRect(x: 15, y: fastTipL.bottom, width: (fastV.width - 30 - 40) - 80, height: 20)
        fastV.addSubview(fastL)
        
        fastTimeL.frame = CGRect(x: fastL.right, y: 10, width: 80, height: 40)
        fastTimeL.textAlignment = .right
        fastV.addSubview(fastTimeL)
        
        fastBtn.frame = CGRect(x: fastTimeL.right + 10, y: (fastV.height - 30)/2, width: 30, height: 30)
        fastBtn.addTarget(self, action: #selector(fastBtnClick), for: .touchUpInside)
        fastV.addSubview(fastBtn)
        
        
        generalV.frame = CGRect(x: 20, y: fastV.bottom + 15, width: ZSCREENWIDTH - 40, height: 60)
        generalV.layer.cornerRadius = 4
        generalV.clipsToBounds = true
        generalV.layer.borderWidth = 1
        generalV.layer.borderColor = Color_F0F1F5.cgColor
        scrollView.addSubview(generalV)
        
        generalTipL.frame = CGRect(x: 15, y: 10, width: (generalV.width - 30 - 40)/2, height: 20)
        generalV.addSubview(generalTipL)
        
        generalL.frame = CGRect(x: 15, y: generalTipL.bottom, width: (generalV.width - 30 - 40) - 80, height: 20)
        generalV.addSubview(generalL)
        
        generalTimeL.frame = CGRect(x: generalL.right, y: 10, width: 80, height: 40)
        generalTimeL.textAlignment = .right
        generalV.addSubview(generalTimeL)
        
        generalBtn.frame = CGRect(x: generalTimeL.right + 10, y: (generalV.height - 30)/2, width: 30, height: 30)
        generalBtn.addTarget(self, action: #selector(generalBtnClick), for: .touchUpInside)
        generalV.addSubview(generalBtn)
        
        advancedV.frame = CGRect(x: 20, y: generalV.bottom + 15, width: ZSCREENWIDTH - 40, height: 100)
        advancedV.layer.cornerRadius = 4
        advancedV.clipsToBounds = true
        advancedV.layer.borderWidth = 1
        advancedV.layer.borderColor = Color_F0F1F5.cgColor
        scrollView.addSubview(advancedV)
        
        // 50 100
        advancedTipL.frame = CGRect(x: 15, y: 10, width: (generalV.width - 30 - 40)/2, height: 20)
        advancedV.addSubview(advancedTipL)
        
        advancedBtn.frame = CGRect(x: advancedV.width - 40, y: 10, width: 30, height: 30)
        advancedBtn.addTarget(self, action: #selector(advancedBtnClick), for: .touchUpInside)
        advancedV.addSubview(advancedBtn)
        
        advancedTF.frame = CGRect(x: 15, y: advancedTipL.bottom + 10, width: (advancedV.width - 30) - 80, height: 20)
        advancedTF.addTarget(self, action: #selector(advancedLimit(textField:)), for: .editingChanged)
        advancedTF.isEnabled = false
        advancedTF.keyboardType = .decimalPad
        advancedTF.clearButtonMode = .never
        advancedV.addSubview(advancedTF)
        
        advancedUnitL.frame = CGRect(x: advancedTF.right, y: advancedTipL.bottom + 10, width: 80, height: 20)
        advancedUnitL.textAlignment = .right
        advancedV.addSubview(advancedUnitL)
        
//        limitL.frame = CGRect(x: 15, y: advancedTF.bottom + 10, width: (advancedV.width - 30)/2, height: 20)
//        advancedV.addSubview(limitL)
//
//        limitTipL.frame = CGRect(x: limitL.right, y: advancedTF.bottom + 10, width: (advancedV.width - 30)/2, height: 20)
//        limitTipL.textAlignment = .right
//        advancedV.addSubview(limitTipL)
        
        limitTF.frame = CGRect(x: 15, y: advancedTF.bottom + 10, width: (advancedV.width - 30) - 80, height: 20)
        limitTF.addTarget(self, action: #selector(limitLimit(textField:)), for: .editingChanged)
        limitTF.isEnabled = false
        limitTF.keyboardType = .decimalPad
        limitTF.clearButtonMode = .never
        advancedV.addSubview(limitTF)
        
        limitTipL.frame = CGRect(x: advancedTF.right, y: advancedTF.bottom + 10, width: 80, height: 20)
        limitTipL.textAlignment = .right
        advancedV.addSubview(limitTipL)
        
        confirmBtn.frame = CGRect(x: 15, y: advancedV.bottom + 30, width: ZSCREENWIDTH - 30, height: 48)
        confirmBtn.layer.cornerRadius = 24
        confirmBtn.clipsToBounds = true
        confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        scrollView.addSubview(confirmBtn)
        
        if confirmBtn.bottom + 20 > baseMainV.height - ZSCREENBOTTOM {
            scrollView.contentSize = CGSize(width: scrollView.width,height: confirmBtn.bottom + 200)
        } else {
            scrollView.contentSize = CGSize(width: scrollView.width,height: baseMainV.height - ZSCREENBOTTOM)
        }
        
        updateData()
        if currentIndex == 4 {
            advancedTF.isEnabled = true
            limitTF.isEnabled = true
        }
    }
    
    func registerNotification() {
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification , object: nil)
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillChange(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func configData() {
        if fee != nil {
            let gasPrice = BigUInt(fee?["gasPrice"] ?? "0") ?? 0
            let gasLimit = BigUInt(fee?["gasLimit"] ?? "0") ?? 0
            let gas = gasPrice * gasLimit
            let curGas = Double(gas)/1e18
            let gw = Double(gasPrice)/1e9
            basePrice = gw
            baseLimit = Double(gasLimit)
            if (walletCoin?.contract?.uppercased() == "KCC") {
                feeL.text = clearZero(String(format: "%.7F",curGas)) + " KCS"
            } else {
                feeL.text = clearZero(String(format: "%.7F",curGas)) + " " + (walletCoin?.contract ?? "")
            }
            
            feeDetailL.text = "GasPrice(\(clearZero(String(format: "%.7F",gw))) GWEI)*GasLimit(\(fee?["gasLimit"] ?? "0"))"
            
            fastestL.text = clearZero(String(format: "%.7F",gw * 1.5)) + " GWEI"
            fastL.text = clearZero(String(format: "%.7F",gw * 1.2)) + " GWEI"
            generalL.text = clearZero(String(format: "%.7F",gw)) + " GWEI"
            
            if currentIndex == 4 {
                advancedTF.text = clearZero(String(format: "%.7F",Double(curPrice ?? 0)/1e9))
                limitTF.text = clearZero(String(format: "%.7F",Double(curLimit ?? 0)))
            } else {
                advancedTF.text = clearZero(String(format: "%.7F",gw))
                limitTF.text = clearZero(fee?["gasLimit"] ?? "0")
            }
        }
        if currentIndex == 4 {
            advancedTF.isEnabled = true
            limitTF.isEnabled = true
        }
    }
    
    func updateData() {
        if currentIndex == 4 {
            advancedTF.isEnabled = true
            limitTF.isEnabled = true
        }
        if currentIndex == 1 {
            fastestBtn.isSelected = true
            fastBtn.isSelected = false
            generalBtn.isSelected = false
            advancedBtn.isSelected = false
            
            let gasPrice = BigUInt(fee?["gasPrice"] ?? "0") ?? 0
            let gasLimit = BigUInt(fee?["gasLimit"] ?? "0") ?? 0
            curPrice = BigUInt(Double(gasPrice) * 1.5)
            curLimit = gasLimit
            let gas = gasPrice * gasLimit
            let curGas = Double(gas)/1e18
            let gw = Double(gasPrice)/1e9
            if (walletCoin?.contract?.uppercased() == "KCC") {
                feeL.text = clearZero(String(format: "%.7F",curGas * 1.5)) + " KCS"
            } else {
                feeL.text = clearZero(String(format: "%.7F",curGas * 1.5)) + " " + (walletCoin?.contract ?? "")
            }
            
            feeDetailL.text = "GasPrice(" + clearZero(String(format: "%.7F",gw * 1.5)) + " GWEI)*GasLimit(\(fee?["gasLimit"] ?? "0"))"
            
            advancedTF.text = clearZero(String(format: "%.7F",gw))
            limitTF.text = clearZero(fee?["gasLimit"] ?? "0")
        } else if currentIndex == 2 {
            fastestBtn.isSelected = false
            fastBtn.isSelected = true
            generalBtn.isSelected = false
            advancedBtn.isSelected = false
            
            let gasPrice = BigUInt(fee?["gasPrice"] ?? "0") ?? 0
            let gasLimit = BigUInt(fee?["gasLimit"] ?? "0") ?? 0
            curPrice = BigUInt(Double(gasPrice) * 1.2)
            curLimit = gasLimit
            let gas = gasPrice * gasLimit
            let curGas = Double(gas)/1e18
            let gw = Double(gasPrice)/1e9
            if (walletCoin?.contract?.uppercased() == "KCC") {
                feeL.text = clearZero(String(format: "%.7F",curGas * 1.2)) + " KCS"
            } else {
                feeL.text = clearZero(String(format: "%.7F",curGas * 1.2)) + " " + (walletCoin?.contract ?? "")
            }
            
            feeDetailL.text = "GasPrice(" + clearZero(String(format: "%.7F",gw * 1.2)) + " GWEI)*GasLimit(\(fee?["gasLimit"] ?? "0"))"
            
            advancedTF.text = clearZero(String(format: "%.7F",gw))
            limitTF.text = clearZero(fee?["gasLimit"] ?? "0")
        } else if currentIndex == 3 {
            fastestBtn.isSelected = false
            fastBtn.isSelected = false
            generalBtn.isSelected = true
            advancedBtn.isSelected = false
            
            let gasPrice = BigUInt(fee?["gasPrice"] ?? "0") ?? 0
            let gasLimit = BigUInt(fee?["gasLimit"] ?? "0") ?? 0
            curPrice = gasPrice
            curLimit = gasLimit
            let gas = gasPrice * gasLimit
            let curGas = Double(gas)/1e18
            let gw = Double(gasPrice)/1e9
            if (walletCoin?.contract?.uppercased() == "KCC") {
                feeL.text = clearZero(String(format: "%.7F",curGas)) + " KCS"
            } else {
                feeL.text = clearZero(String(format: "%.7F",curGas)) + " " + (walletCoin?.contract ?? "")
            }
            
            feeDetailL.text = "GasPrice(" + clearZero(String(format: "%.7F",gw)) + " GWEI)*GasLimit(\(fee?["gasLimit"] ?? "0"))"
            
            advancedTF.text = clearZero(String(format: "%.7F",gw))
            limitTF.text = clearZero(fee?["gasLimit"] ?? "0")
        } else if currentIndex == 4 {
            fastestBtn.isSelected = false
            fastBtn.isSelected = false
            generalBtn.isSelected = false
            advancedBtn.isSelected = true
            
            if isFirst {
                let gasPrice = curPrice ?? 0
                let gasLimit = curLimit ?? 0
                let gas = gasPrice * gasLimit
                let curGas = Double(gas)/1e18
                let gw = Double(gasPrice)/1e9
                if (walletCoin?.contract?.uppercased() == "KCC") {
                    feeL.text = clearZero(String(format: "%.7F",curGas)) + " KCS"
                } else {
                    feeL.text = clearZero(String(format: "%.7F",curGas)) + " " + (walletCoin?.contract ?? "")
                }
                
                feeDetailL.text = "GasPrice(" + clearZero(String(format: "%.7F",gw)) + " GWEI)*GasLimit(\(clearZero(String(format: "%.7F",Double(gasLimit)))))"
                
                advancedTF.text = clearZero(String(format: "%.7F",gw))
                limitTF.text = clearZero(String(format: "%.7F",Double(gasLimit)))
            } else {
                let gasPrice = BigUInt(fee?["gasPrice"] ?? "0") ?? 0
                let gasLimit = BigUInt(fee?["gasLimit"] ?? "0") ?? 0
                curPrice = gasPrice
                curLimit = gasLimit
                let gas = (curPrice ?? 0) * (curLimit ?? 0)
                let curGas = Double(gas)/1e18
                if (walletCoin?.contract?.uppercased() == "KCC") {
                    feeL.text = clearZero(String(format: "%.7F",curGas)) + " KCS"
                } else {
                    feeL.text = clearZero(String(format: "%.7F",curGas)) + " " + (walletCoin?.contract ?? "")
                }
                
                feeDetailL.text = "GasPrice(" + clearZero(String(format: "%.7F",Double(curPrice ?? 0)/1e9)) + " GWEI)*GasLimit(\(clearZero(String(format: "%.7F",Double(curLimit ?? 0)))))"
                
                advancedTF.text = clearZero(String(format: "%.7F",Double(curPrice ?? 0)/1e9))
                limitTF.text = clearZero(String(format: "%.7F",Double(curLimit ?? 0)))
            }
        }
    }
    
    @objc func tapClick() {
        view.endEditing(true)
    }
    
    @objc func fastestBtnClick() {
        tapClick()
        isFirst = false
        currentIndex = 1
        advancedTF.isEnabled = false
        limitTF.isEnabled = false
        updateData()
    }
    
    @objc func fastBtnClick() {
        tapClick()
        isFirst = false
        currentIndex = 2
        advancedTF.isEnabled = false
        limitTF.isEnabled = false
        updateData()
    }
    
    @objc func generalBtnClick() {
        tapClick()
        isFirst = false
        currentIndex = 3
        advancedTF.isEnabled = false
        limitTF.isEnabled = false
        updateData()
    }
    
    @objc func advancedLimit(textField:UITextField) {
        if let advanced = advancedTF.text, let limit = limitTF.text {
            let gasPrice = BigUInt((Double(advanced) ?? 0) * 1e9)
            let gasLimit = BigUInt((Double(limit) ?? 0))
            curPrice = gasPrice
            curLimit = gasLimit
            let gas = (curPrice ?? 0) * (curLimit ?? 0)
            let curGas = Double(gas)/1e18
            if (walletCoin?.contract?.uppercased() == "KCC") {
                feeL.text = clearZero(String(format: "%.7F",curGas)) + " KCS"
            } else {
                feeL.text = clearZero(String(format: "%.7F",curGas)) + " " + (walletCoin?.contract ?? "")
            }
            
            feeDetailL.text = "GasPrice(" + clearZero(String(format: "%.7F",Double(curPrice ?? 0)/1e9)) + " GWEI)*GasLimit(\(clearZero(String(format: "%.7F",Double(curLimit ?? 0)))))"
        }
    }
    
    @objc func limitLimit(textField:UITextField) {
        if let advanced = advancedTF.text, let limit = limitTF.text {
            let gasPrice = BigUInt((Double(advanced) ?? 0) * 1e9)
            let gasLimit = BigUInt((Double(limit) ?? 0))
            curPrice = gasPrice
            curLimit = gasLimit
            let gas = (curPrice ?? 0) * (curLimit ?? 0)
            let curGas = Double(gas)/1e18
            if (walletCoin?.contract?.uppercased() == "KCC") {
                feeL.text = clearZero(String(format: "%.7F",curGas)) + " KCS"
            } else {
                feeL.text = clearZero(String(format: "%.7F",curGas)) + " " + (walletCoin?.contract ?? "")
            }
            
            
            feeDetailL.text = "GasPrice(" + clearZero(String(format: "%.7F",Double(curPrice ?? 0)/1e9)) + " GWEI)*GasLimit(\(clearZero(String(format: "%.7F",Double(curLimit ?? 0)))))"
        }
    }
    
    @objc func advancedBtnClick() {
        tapClick()
        isFirst = false
        currentIndex = 4
        advancedTF.isEnabled = true
        limitTF.isEnabled = true
        updateData()
    }
    
    @objc func confirmBtnClick() {
        tapClick()
        navigationController?.popViewController(animated: true)
        delegate?.selectFeeDelegate(price: curPrice, limit: curLimit, index: currentIndex)
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

extension FeeViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("kong" + string )
        if textField == advancedTF {
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
        } else if textField == limitTF {
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
        if textField == advancedTF {
            let gw = Double(textField.text ?? "0") ?? 0
            if gw < basePrice {
                textField.text = clearZero(String(format: "%.7F",basePrice))

                let gasPrice = BigUInt(fee?["gasPrice"] ?? "0") ?? 0
                let gasLimit = BigUInt(fee?["gasLimit"] ?? "0") ?? 0
                curPrice = gasPrice
                let gas = gasPrice * gasLimit
                let curGas = Double(gas)/1e18
                let gw = Double(gasPrice)/1e9
                if (walletCoin?.contract?.uppercased() == "KCC") {
                    feeL.text = clearZero(String(format: "%.7F",curGas)) + " KCS"
                } else {
                    feeL.text = clearZero(String(format: "%.7F",curGas)) + " " + (walletCoin?.contract ?? "")
                }
                
                feeDetailL.text = "GasPrice(" + clearZero(String(format: "%.7F",gw)) + " GWEI)*GasLimit(\(clearZero(String(format: "%.7F",Double(curLimit ?? 0)))))"
                
                advancedTF.text = clearZero(String(format: "%.7F",gw))
            }
        } else if textField == limitTF {
            let gw = Double(textField.text ?? "0") ?? 0
            if gw < baseLimit {
                textField.text = clearZero(String(format: "%.7F",baseLimit))

                let gasPrice = curPrice
                let gasLimit = BigUInt(fee?["gasLimit"] ?? "0") ?? 0
                curLimit = gasLimit
                let gas = (gasPrice ?? 0) * gasLimit
                let curGas = Double(gas)/1e18
                if (walletCoin?.contract?.uppercased() == "KCC") {
                    feeL.text = clearZero(String(format: "%.7F",curGas)) + " KCS"
                } else {
                    feeL.text = clearZero(String(format: "%.7F",curGas)) + " " + (walletCoin?.contract ?? "")
                }
                
                feeDetailL.text = "GasPrice(" + clearZero(String(format: "%.7F",Double(gasPrice ?? 0)/1e9)) + " GWEI)*GasLimit(\(fee?["gasLimit"] ?? "0"))"
                
                limitTF.text = clearZero(fee?["gasLimit"] ?? "0")
            }
        }
    }
}
