//
//  Web2ViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD
import FirebaseCore
import GoogleSignIn
import walletverse_ios_sdk

class Web2ViewController : BaseViewController, ThirdCollectionCellDelegate {
    var keyboardHeight:CGFloat = 0.0
    
    let thirdArray: Array<Dictionary<String,String>> = [["key":"Google" , "value":"icon_auth_google"],
                                                        ["key":"FaceBook" , "value":"icon_auth_facebook"],
                                                        ["key":"Twitter" , "value":"icon_auth_twitter"],
                                                        ["key":"Github" , "value":"icon_auth_github"],
                                                        ["key":"Discord" , "value":"icon_auth_discord"],
                                                        ["key":"Line" , "value":"icon_auth_line"],
                                                        ["key":"KaKao" , "value":"icon_auth_kakao"]
    ]
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    var headerIV : UIImageView = {
        return CustomView.imageViewCustom(image: UIImage(named: "Web2HeaderBack"))
    }()
    
    lazy var thirdL : UILabel = {
        return CustomView.labelCustom(text: LocalString("assert_web2_third"), font: FontSystem(size: 16), color: Color_1C1E27)
    }()
    
    private let layout = UICollectionViewFlowLayout.init()
    private lazy var collectionView : UICollectionView = {
        layout.itemSize = CGSize.init(width: ZSCREENWIDTH/5, height: ZSCREENWIDTH/5)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 2, height:2), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.isPagingEnabled = true
        collectionView.register(cellType: ThirdCollectionCell.self)
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        return collectionView
    }()
    
    lazy var emailL : UILabel = {
        return CustomView.labelCustom(text: LocalString("assert_web2_email"), font: FontSystem(size: 16), color: Color_1C1E27)
    }()
    
    lazy var emailV : UIView = {
        return CustomView.viewCustom(color: Color_F5F6FA)
    }()
    
    lazy var emailTF : UITextField = {
        let emailTF = CustomView.textFieldCustom(text: "", font: FontSystem(size: 15), color: Color_333333, delegate: self, placeholder: "abc@126.com")
        return emailTF
    }()
    
    lazy var continueBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("web2_use_email"), font: FontSystemBold(size: 16), color: Color_FFFFFF, cornerRadius: 4, backColor: Color_0072DB_0)
    }()
    
    lazy var web3Btn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("web2_use_web3"), font: FontSystemBold(size: 16), color: Color_FFFFFF, cornerRadius: 4, backColor: Color_0072DB_1)
    }()
    
    var commonLoadView : CommonLoadView?
    
    override func viewDidLoad() {
        isShowNaviBar = false
        super.viewDidLoad()
        headerIV.frame = CGRect(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENWIDTH/1125*600)
        baseMainV.addSubview(headerIV)
        
        initBaseNaviBar()
        initBaseNaviLeft()
        baseNaviBar.backgroundColor = UIColor.clear
        
        registerNotification()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: baseMainV.width, height: baseMainV.height - ZSCREENBOTTOM)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        scrollView.addGestureRecognizer(tapGesture)
        baseMainV.addSubview(scrollView)
        
        configSubUI()
    }
    
    func registerNotification() {
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification , object: nil)
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        ZNOTIFICATION.addObserver(self, selector: #selector(keyBoardWillChange(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func configSubUI() {
        
        thirdL.frame = CGRect.init(x: 15, y: 75, width: ZSCREENWIDTH - 30, height: 30)
        scrollView.addSubview(thirdL)
        
        collectionView.frame = CGRect.init(x: 0, y: thirdL.bottom + 5, width: ZSCREENWIDTH, height:ZSCREENWIDTH/5*2)
        scrollView.addSubview(collectionView)
        
        emailL.frame = CGRect.init(x: 15, y: collectionView.bottom + 10, width: ZSCREENWIDTH - 30, height: 42)
        scrollView.addSubview(emailL)
        
        emailV.frame = CGRect.init(x: 15, y: emailL.bottom + 5, width: ZSCREENWIDTH - 30, height: 42)
        emailV.clipsToBounds = true
        emailV.layer.cornerRadius = 4
        scrollView.addSubview(emailV)
        
        emailTF.frame = CGRect(x: 15, y: 0, width: emailV.width - 30, height: 42)
        emailTF.keyboardType = .emailAddress
        emailTF.addTarget(self, action: #selector(emailLimit(textField:)), for: .editingChanged)
        emailV.addSubview(emailTF)
        
        
        continueBtn.frame = CGRect.init(x: 16, y: emailV.bottom + 30, width: ZSCREENWIDTH - 32, height: 48)
        continueBtn.clipsToBounds = true
        continueBtn.layer.cornerRadius = 24
        continueBtn.addTarget(self, action: #selector(continueBtnClick), for: .touchUpInside)
        continueBtn.isEnabled = false
        scrollView.addSubview(continueBtn)
        
        web3Btn.frame = CGRect.init(x: 16, y: continueBtn.bottom + 30, width: ZSCREENWIDTH - 32, height: 48)
        web3Btn.clipsToBounds = true
        web3Btn.layer.cornerRadius = 24
        web3Btn.addTarget(self, action: #selector(web3BtnClick), for: .touchUpInside)
        scrollView.addSubview(web3Btn)
        
        if web3Btn.bottom + 20 > baseMainV.height - ZSCREENBOTTOM {
            scrollView.contentSize = CGSize(width: scrollView.width,height: web3Btn.bottom + 200)
        } else {
            scrollView.contentSize = CGSize(width: scrollView.width,height: baseMainV.height - ZSCREENBOTTOM)
        }
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func tapClick() {
        view.endEditing(true)
    }
    
    @objc func emailLimit(textField:UITextField) {
        emailCompare()
    }
    
    func emailCompare() {
        if isEmailRuler(email: emailTF.text ?? "") {
            continueBtn.backgroundColor = Color_0072DB_1
            continueBtn.isEnabled = true
        } else {
            continueBtn.backgroundColor = Color_0072DB_0
            continueBtn.isEnabled = false
        }
    }
    
    @objc func continueBtnClick() {
        tapClick()
        
        Walletverse.getGraphicsCode { (result) in
            if let emailCodeModel = result {
                let emailVerifyView = EmailVerifyView()
                emailVerifyView.delegate = self
                emailVerifyView.setData(emailCodeModel: emailCodeModel, email: self.emailTF.text?.trimmingCharacters( in : .whitespaces))
                emailVerifyView.show()
            }
        }
    }
    
    @objc func web3BtnClick() {
        tapClick()
        
        let controller = Web3ViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func isEmailRuler(email:String) -> Bool {
        return PredicateUtil.vertifyEmail(email)
    }
    
    func signInWeb2(providerKey: String, providerUid: String, providerId: Channel, auth: String) {
        if auth.isEmpty {
            CommonToastView.showToastAction(message: LocalString("asserts_email_verify_error"))
            return
        }
        commonLoadView = CommonLoadView()
        commonLoadView?.show()
        
        let federatedParams = FederatedParams(providerKey: providerKey, providerUid: providerUid, providerId: providerId, auth: auth)
        let result = Walletverse.checkWalletExist(params: federatedParams)
        if result {
            self.commonLoadView?.dismiss()
            CommonToastView.showToastAction(message: LocalString("asserts_already_exist"))
            return
        }
        var userTypeS = ""
        Walletverse.signInWeb2(params: federatedParams) { (result) in
            
            if let federated = result {
                if federated.shards?.count ?? 0 > 0 {
                    self.commonLoadView?.dismiss()
                    
                    userTypeS = "old"
                    
                    let controller = Web2CreateViewController()
                    controller.userType = userTypeS
                    controller.federated = federated
                    controller.federatedParams = federatedParams
                    self.navigationController?.pushViewController(controller, animated: true)
                } else {
                    userTypeS = "new"
                    let jsParams = JSCoreParams()
                        .put(key: "chainId", value: "0x1") ?? JSCoreParams()
                    Walletverse.generateMnemonic(params: jsParams) { (returnData, error) in
                        self.commonLoadView?.dismiss()
                        
                        if let mnemonic = returnData {
                            let controller = Web2CreateViewController()
                            controller.userType = userTypeS
                            controller.mnemonic = mnemonic as? String
                            controller.federatedParams = federatedParams
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                }
            } else {
                self.commonLoadView?.dismiss()
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

extension Web2ViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTF {
            emailTF.textColor = Color_333333
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == emailTF {
            if isEmailRuler(email: textField.text ?? "") {
                emailTF.textColor = Color_333333
            } else {
                emailTF.textColor = Color_0072DB
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTF {
            if isEmailRuler(email: textField.text ?? "") {
                emailTF.textColor = Color_333333
            } else {
                emailTF.textColor = Color_0072DB
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension Web2ViewController : EmailVerifyViewDelegate {
    func confirmAction(auth: String) {
        signInWeb2(providerKey: emailTF.text ?? "", providerUid: emailTF.text ?? "", providerId: Channel.Email, auth: auth)
    }
}

extension Web2ViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thirdArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ZSCREENWIDTH/4, height: ZSCREENWIDTH/4)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ThirdCollectionCell.self)
        let third = thirdArray[indexPath.row]
        cell.iconIV.image = UIImage(named: third["value"] ?? "")
        cell.nameL.text = third["key"]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func selectActionDelegate(key: String) {
        tapClick()
        if key == "Google" {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { (result, error) in
                if let err = error {
                    CommonToastView.showToastAction(message: "\(err)")
                    return
                }
                guard let userId = result?.userID, let email = result?.profile?.email else {
                    return
                }
                self.signInWeb2(providerKey: email, providerUid: email, providerId: Channel.Google, auth: userId)
            }
        }
    }
    
    
}
