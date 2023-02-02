//
//  SelectChainView.swift
//  Walletverse
//
//  Created by Ky on 2022/10/11.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import BigInt
import walletverse_ios_sdk

protocol SelectChainViewDelegate  {
    func selectChainModel(coinModel: CoinModel?)
}

class SelectChainView: BaseView {
    var delegate: SelectChainViewDelegate?
    var coinArray: [CoinModel]?
        
    var backV : UIView!
        
    lazy var mainV : UIView = {
        let mainV = UIView()
        mainV.backgroundColor = ColorHex(0xffffff)
        return mainV
    }()
        
    lazy var closeBtn : UIButton = {
        return CustomView.buttonCustom(image: UIImage(named: "AssetsCloseGray"))
    }()
        
    lazy var titleL : UILabel = {
        return CustomView.labelCustom(text: LocalString("dialog_confirm_pay"), font: FontSystemBold(size: 16), color: Color_1C1E27, textAlignment:.center)
    }()
    
    private let layout = UICollectionViewFlowLayout.init()
    private lazy var collectionView : UICollectionView = {
        layout.itemSize = CGSize.init(width: ZSCREENWIDTH/4, height: ZSCREENWIDTH/4)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 50, width: ZSCREENWIDTH, height:ZSCREENWIDTH), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.isPagingEnabled = true
        collectionView.register(cellType: SelectChainCollectionCell.self)
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        return collectionView
    }()
        
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENHEIGHT)
        backV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ZSCREENWIDTH, height: ZSCREENHEIGHT))
        backV.backgroundColor = ColorHex(0x000000, alpha: 0.6)
        self.addSubview(backV)
        
        configSubviews()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configSubviews() {
        mainV.frame = CGRect.init(x: 0, y: ZSCREENHEIGHT - ZSCREENBOTTOM - ZSCREENWIDTH - 50, width: ZSCREENWIDTH, height: ZSCREENWIDTH + 50 + ZSCREENBOTTOM)
        addSubview(mainV)
            
        closeBtn.frame = CGRect(x: 15, y: 15, width: 20, height: 20)
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        mainV.addSubview(closeBtn)
            
        titleL.frame = CGRect(x: 50, y: 0, width: ZSCREENWIDTH - 100, height: 50)
        mainV.addSubview(titleL)
        
        mainV.addSubview(collectionView)
    }
    
    func setData(coinArray : [CoinModel]?) {
        self.coinArray = coinArray
        collectionView.reloadData()
    }
        
    @objc func closeBtnClick() {
        dismiss()
    }
        
    func show() {
        ZWINDOW?.addSubview(self)
    }
        
    func dismiss() {
        self.removeFromSuperview()
        mainV.endEditing(true)
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

extension SelectChainView : UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ZSCREENWIDTH/4, height: ZSCREENWIDTH/4)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SelectChainCollectionCell.self)
        guard let coin = coinArray?[indexPath.row] else {
            return cell
        }
        cell.iconIV.kf.setImage(urlString: coin.iconUrl, placeholder: UIImage(named: "IconPlaceholder"))
        cell.nameL.text = coin.chainName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let coin = coinArray?[indexPath.row] else {
            return
        }
        self.delegate?.selectChainModel(coinModel: coin)
        dismiss()
    }
}
