//
//  VertifyMnemonicView.swift
//  Walletverse
//
//  Created by Ky on 2022/10/8.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

class VertifyMnemonicView: BaseView {
    
    var mnemonicArray : NSArray? = NSArray()
    var itemCount : Int = 0
    
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
        collectionView.register(MnemonicCollectionCell.self, forCellWithReuseIdentifier: "MnemonicCollectionCell")
        
        return collectionView
    }()
    
    override func configUI() {
        
    }
    
    func configSubviewUI() {
        addSubview(collectionView)
    }
    
    func setMnemonicArray(mnemonicArray : NSArray?) {
        if let array = mnemonicArray {
            self.mnemonicArray = array
        }
    }
    
    func setItemCount(count: Int) {
        itemCount = count
        if itemCount > 0 && mnemonicArray?.count ?? 0 >= itemCount  {
            collectionView.reloadData()
        }
    }

}

extension VertifyMnemonicView : UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width/3, height: height/4)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MnemonicCollectionCell.self)
        cell.mnemonicL.frame = CGRect(x: 0, y: 0, width: width/3, height: height/4)
        guard let text = mnemonicArray?[indexPath.row] as? String else {
            cell.mnemonicL.text = ""
            cell.mnemonicL.frame = CGRect(x: 0, y: 0, width: width/3, height: height/4)
            return cell
        }
        cell.mnemonicL.text = text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
