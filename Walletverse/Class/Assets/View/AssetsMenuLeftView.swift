//
//  AssetsMenuLeftView.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

protocol AssetsMenuLeftViewDelegate  {
    func addWalletDelegate()
    func selectWalletDelegate(identityModel: IdentityModel?)
    func manageWalletDelegate(identityModel: IdentityModel?)
}

class AssetsMenuLeftView: BaseView, AssetsMenuTableCellDelegate {
    var delegate: AssetsMenuLeftViewDelegate?
    
    var identityArray : [IdentityModel]?
    var currentIdentity : IdentityModel?
    
    var backV : UIView = UIView()
        
    var mainV : UIView = {
        let mainV = UIView()
        mainV.backgroundColor = Color_FFFFFF
        return mainV
    }()
        
    var walletTV : UILabel = {
        return CustomView.labelCustom(text: LocalString("assets_host_mywallet"), font: FontSystem(size: 19), color: Color_091C40, textAlignment: .left)
    }()
    
    var createBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("asserts_wallet_add"), font: FontSystemBold(size: 16), color: Color_FFFFFF, cornerRadius: 6, backColor: Color_5C74FF)
    }()
        
    private lazy var mainTableV : UITableView = {
        let tableV = UITableView()
        tableV.backgroundColor = Color_FFFFFF
        tableV.dataSource = self
        tableV.delegate = self
        tableV.alwaysBounceVertical = true
        tableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableV.scrollIndicatorInsets = tableV.contentInset
        tableV.separatorStyle = .none
        tableV.register(cellType: AssetsMenuTableCell.self)
        return tableV
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        Walletverse.queryIdentities { (identityArray) in
            if identityArray?.count ?? 0 > 0 {
                self.identityArray = identityArray
            }
        }
        
        self.frame = CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENHEIGHT)
        backV.frame = CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENHEIGHT)
        backV.backgroundColor = Color_000000_06
        backV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapRecognizerAction(tapGesture:))))
        self.addSubview(backV)
            
        configSubviews()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configSubviews() {
        
        mainV.frame = CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH - 100, height: ZSCREENHEIGHT)
        addSubview(mainV)
            
        walletTV.frame = CGRect(x: 15, y: ZSCREENNAVIBAR - 44, width: (mainV.width - 45)/2, height: 44)
        mainV.addSubview(walletTV)
            
        mainTableV.frame = CGRect(x: 0, y: walletTV.bottom, width: mainV.width, height: mainV.height - walletTV.bottom - 86 - ZSCREENBOTTOM)
        mainV.addSubview(mainTableV)
        
        createBtn.frame = CGRect(x: 20, y: mainTableV.bottom + 16, width: (mainV.width - 40), height: 50)
        createBtn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        mainV.addSubview(createBtn)
    }
        
    @objc func tapRecognizerAction(tapGesture : UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc func addBtnClick() {
        delegate?.addWalletDelegate()
        dismiss()
    }

    func show() {
        ZWINDOW?.addSubview(self)
    }
        
    func dismiss() {
        self.removeFromSuperview()
    }
        
    static func animationAlert(view : UIView) {
        let popAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        popAnimation.duration = 0.6
        popAnimation.values = [NSValue.init(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1.0)),NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),NSValue.init(caTransform3D: CATransform3DIdentity)];
        popAnimation.keyTimes = [0.0, 0.5, 0.75, 1.0];
        popAnimation.timingFunctions = [CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),CAMediaTimingFunction.init(name:CAMediaTimingFunctionName.easeInEaseOut)]
        view.layer.add(popAnimation, forKey: nil)
    }
}

extension AssetsMenuLeftView : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return identityArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AssetsMenuTableCell.self)
        if let identity = identityArray?[indexPath.row] {
            if stringCompare(identity.wid, currentIdentity?.wid) {
                cell.setTokenModel(identity: identity, isSelect: true)
            } else {
                cell.setTokenModel(identity: identity, isSelect: false)
            }
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identity = identityArray?[indexPath.row]
        if identity?.wid == currentIdentity?.wid {
            dismiss()
        } else {
            delegate?.selectWalletDelegate(identityModel: identity)
            dismiss()
        }
    }
    
    func manageWalletDelegate(identityModel: IdentityModel?) {
        delegate?.manageWalletDelegate(identityModel: identityModel)
        dismiss()
    }
    
}
