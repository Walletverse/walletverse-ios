//
//  OrginalMnemonicView.swift
//  Walletverse
//
//  Created by Ky on 2022/10/8.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

protocol OrginalMnemonicViewDelegate {
    func didDeselectItemError(indexPath: IndexPath)
    func didDeselectItemFinish(indexPath: IndexPath,currentIndex: Int)
}

class OrginalMnemonicView: BaseView {
    
    var delegate: OrginalMnemonicViewDelegate?
    
    var mnemonicArray : NSArray? = NSArray()
    var sortArray : NSMutableArray? = NSMutableArray()
    var currentIndex : Int = 0;
    private let layout = UICollectionViewFlowLayout.init()
    
    private lazy var collectionView : UICollectionView = {
        layout.itemSize = CGSize.init(width: (width - 20 - 10*2)/3, height: (height - 20 - 10*3)/4)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: width, height:height), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.isPagingEnabled = true
        collectionView.register(OriginalCollectionCell.self, forCellWithReuseIdentifier: "OriginalCollectionCell")
        
        return collectionView
    }()
    
    override func configUI() {
        
    }
    
    func configSubviewUI() {
        addSubview(collectionView)
    }
    
    func setMnemonicArray(mnemonicArray : NSArray?) {
        if let array = mnemonicArray {
            if array.count > 0 {
                self.mnemonicArray = array
                self.sortArray = NSMutableArray(array: array)
                
                for i in 0 ..< (sortArray?.count ?? 0) - 1 {
                    for j in 0 ..< (sortArray?.count ?? 0) - 1 - i {
                        if (sortArray?[j] as! String).compare(sortArray?[j + 1] as! String) == ComparisonResult.orderedDescending {
                            sortArray?.exchangeObject(at: j, withObjectAt: j + 1)
                        }
                    }
                }
                collectionView.reloadData()
            }
        }
    }

}

extension OrginalMnemonicView : UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let array = sortArray {
            return array.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (width - 20 - 10*2)/3, height: (height - 20 - 10*3)/4)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:OriginalCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OriginalCollectionCell", for: indexPath) as! OriginalCollectionCell
        cell.mnemonicL.frame = CGRect(x: 0, y: 0, width: (width - 20 - 10*2)/3, height: (height - 20 - 10*3)/4)
        cell.mnemonicL.layer.cornerRadius = 4
        cell.mnemonicL.clipsToBounds = true
        cell.mnemonicL.layer.borderWidth = 1
        cell.mnemonicL.layer.borderColor = ColorHex(0xDCDCE4).cgColor
        cell.mnemonicL.isUserInteractionEnabled = true
        cell.mnemonicL.text = (sortArray?[indexPath.row] as! String)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell =  collectionView.cellForItem(at: indexPath) as? OriginalCollectionCell {
            let string = mnemonicArray?[currentIndex] as! String
            if (cell.mnemonicL.text ?? "").isEqual(string) {
                currentIndex = currentIndex + 1
                self.delegate?.didDeselectItemFinish(indexPath: indexPath,currentIndex: currentIndex)
                
                cell.mnemonicL.backgroundColor = ColorHex(0x4D51C6)
                cell.mnemonicL.textColor = ColorHex(0xEAEAF1)
            } else {
                self.delegate?.didDeselectItemError(indexPath: indexPath)
            }
        }
    }
}
