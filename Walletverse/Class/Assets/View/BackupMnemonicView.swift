//
//  BackupMnemonicView.swift
//  Walletverse
//
//  Created by Ky on 2022/10/8.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

protocol BackupMnemonicViewDelegate  {
    func showBtnDelegate()
}

class BackupMnemonicView: BaseView {
    
    var mnemonicArray : NSArray?
    var delegate: BackupMnemonicViewDelegate?
    
    lazy var mainV : UIView = {
        return CustomView.viewCustom(color: ColorHex(0xffffff))
    }()
    
    lazy var tipL : UILabel = {
        return CustomView.labelCustom(text: LocalString("assets_backup_mnemonic_tip"), font: FontSystemBold(size: 15), color: Color_0072DB, textAlignment: .center)
    }()
    
    lazy var showBtn : UIButton = {
        return CustomView.buttonCustom(text: LocalString("assets_backup_mnemonic_show"), font: FontSystemBold(size: 16), color: Color_FFFFFF, cornerRadius: 0, backImage: UIImage(named: "AssetsClickShow"), selectImage: UIImage(named: "AssetsClickShow"))
    }()
    
    private let layout = UICollectionViewFlowLayout.init()
    private lazy var collectionView : UICollectionView = {
        layout.itemSize = CGSize.init(width: width/3, height: height/4)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: width, height:height), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.isPagingEnabled = true
        collectionView.isHidden = true
        collectionView.register(cellType: MnemonicCollectionCell.self)
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        return collectionView
    }()
    
    override func configUI() {
        
    }
    
    func configSubviewUI() {
        mainV.frame = CGRect(x: 0, y: 0, width: width, height: height)
        mainV.layer.cornerRadius = 4
        mainV.clipsToBounds = true
        addSubview(mainV)
        
        tipL.frame = CGRect(x: 10, y: 25, width: width - 20, height: 40)
        tipL.numberOfLines = 2
        mainV.addSubview(tipL)
        
        showBtn.frame = CGRect(x: (mainV.width - 138)/2, y: tipL.bottom + 35, width: 138, height: 138)
        showBtn.titleLabel?.numberOfLines = 3
        showBtn.titleLabel?.textAlignment = .center
        showBtn.addTarget(self, action: #selector(showBtnClick), for: .touchUpInside)
        mainV.addSubview(showBtn)
        
        addSubview(collectionView)
    }
    
    @objc func showBtnClick() {
        mainV.isHidden = true
        collectionView.isHidden = false
        if mnemonicArray?.count ?? 0 > 0 {
            collectionView.reloadData()
        }
        self.delegate?.showBtnDelegate()
    }

}

extension BackupMnemonicView : UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mnemonicArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width/3, height: height/4)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MnemonicCollectionCell.self)
        guard let text = mnemonicArray?[indexPath.row] as? String else {
            cell.mnemonicL.text = ""
            cell.mnemonicL.frame = CGRect(x: 0, y: 0, width: width/3, height: height/4)
            return cell
        }
        cell.mnemonicL.text = text
        cell.mnemonicL.frame = CGRect(x: 0, y: 0, width: width/3, height: height/4)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
