//
//  BackupMnemonicSecureView.swift
//  Walletverse
//
//  Created by Ky on 2022/10/8.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

class BackupMnemonicSecureView: BaseView {
    
    var countHeight : CGFloat = 0
    
    override func configUI() {
    }
    
    func configSubviewUI() {
        let oneL = CustomView.labelCustom(text: LocalString("assets_backup_mnemonic_one"), font: FontSystem(size: 12), color: Color_717782)
        oneL.numberOfLines = 0
        let oneLHeight = oneL.text?.getLableHeigh(font: oneL.font, width: width - 56)
        oneL.frame = CGRect(x: 36, y: 15, width: width - 56, height: oneLHeight ?? 0)
        addSubview(oneL)
        
        let onePoint = CustomView.viewCustom(color: Color_717782)
        onePoint.frame = CGRect(x: 20, y: oneL.y + 6, width: 6, height: 6)
        onePoint.layer.cornerRadius = 3
        onePoint.clipsToBounds = true
        addSubview(onePoint)
        
        let twoL = CustomView.labelCustom(text: LocalString("assets_backup_mnemonic_two"), font: FontSystem(size: 12), color: Color_717782)
        twoL.numberOfLines = 0
        let twoLHeight = twoL.text?.getLableHeigh(font: twoL.font, width: width - 56)
        twoL.frame = CGRect(x: 36, y: oneL.bottom + 5, width: width - 56, height: twoLHeight ?? 0)
        addSubview(twoL)
        
        let twoPoint = CustomView.viewCustom(color: Color_717782)
        twoPoint.frame = CGRect(x: 20, y: twoL.y + 6, width: 6, height: 6)
        twoPoint.layer.cornerRadius = 3
        twoPoint.clipsToBounds = true
        addSubview(twoPoint)
        
        let threeL = CustomView.labelCustom(text: LocalString("assets_backup_mnemonic_three"), font: FontSystem(size: 12), color: Color_717782)
        threeL.numberOfLines = 0
        let threeLHeight = threeL.text?.getLableHeigh(font: threeL.font, width: width - 56)
        threeL.frame = CGRect(x: 36, y: twoL.bottom + 5, width: width - 56, height: threeLHeight ?? 0)
        addSubview(threeL)
        
        let threePoint = CustomView.viewCustom(color: Color_717782)
        threePoint.frame = CGRect(x: 20, y: threeL.y + 6, width: 6, height: 6)
        threePoint.layer.cornerRadius = 3
        threePoint.clipsToBounds = true
        addSubview(threePoint)
        
        let fourL = CustomView.labelCustom(text: LocalString("assets_backup_mnemonic_four"), font: FontSystem(size: 12), color: Color_717782)
        fourL.numberOfLines = 0
        let fourLHeight = fourL.text?.getLableHeigh(font: fourL.font, width: width - 56)
        fourL.frame = CGRect(x: 36, y: threeL.bottom + 5, width: width - 56, height: fourLHeight ?? 0)
        addSubview(fourL)
        
        let fourPoint = CustomView.viewCustom(color: Color_717782)
        fourPoint.frame = CGRect(x: 20, y: fourL.y + 6, width: 6, height: 6)
        fourPoint.layer.cornerRadius = 3
        fourPoint.clipsToBounds = true
        addSubview(fourPoint)
        
        countHeight = fourL.bottom + 15
    }

}
