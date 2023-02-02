//
//  MineSetViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import walletverse_ios_sdk

class MineSetViewController: BaseViewController {
    
    var passwordS : String?
    
    private lazy var mainTableV : UITableView = {
        let tableV = UITableView()
        tableV.backgroundColor = Color_FFFFFF
        tableV.layer.cornerRadius = 4
        tableV.clipsToBounds = true
        tableV.dataSource = self
        tableV.delegate = self
        tableV.alwaysBounceVertical = true
        tableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableV.scrollIndicatorInsets = tableV.contentInset
        tableV.separatorStyle = .none
        tableV.register(cellType: MineSetTableCell.self)
        return tableV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBaseNaviLeft()
        baseNaviTitle.text = LocalString("mine_set")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainTableV.reloadData()
    }
    
    override func configUI() {
        mainTableV.frame = CGRect.init(x: 15, y: 15, width: ZSCREENWIDTH - 30, height: 186)
        mainTableV.layer.cornerRadius = 8
        mainTableV.clipsToBounds = true
        mainTableV.backgroundColor = Color_F5F6FA
        baseMainV.addSubview(mainTableV)
    }
    
    override func configData() {
        
    }
}

extension MineSetViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MineSetTableCell.self)
        switch indexPath.row {
        case 0:
            cell.nameL.text = LocalString("mine_language")
            cell.contentL.text = LocalUtil.shareInstance.getCurrentLanguageName()
            cell.arrowIV.isHidden = false
            break
        case 1:
            cell.nameL.text = LocalString("mine_price")
            cell.contentL.text = CurrencyUtil().getCurrentCurrency()
            cell.arrowIV.isHidden = false
            break
        case 2:
            cell.nameL.text = LocalString("mine_unit")
            cell.contentL.text = UnitUtil().getCurrentUnit()
            cell.arrowIV.isHidden = false
            break
        
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            for language in LocalUtil.shareInstance.languageArray {
                let idAction = UIAlertAction(title: language["key"] ?? "English", style: .default, handler: {
                    action in
                    LocalUtil.shareInstance.setCurrentLanguage(language["value"] ?? "en")
                    Walletverse.changeLanguage(language: LocalUtil.shareInstance.getCurrentLanguageEnum())
                    ZDELEGATE?.applicationSetRootViewController(controller: MainViewController())
                })
                alertSheet.addAction(idAction)
            }
            let cancelAction = UIAlertAction(title: LocalString("cancel"), style: .cancel, handler: {
                action in
                
            })
            alertSheet.addAction(cancelAction)
            present(alertSheet, animated: true, completion: nil)
            break
        case 1:
            let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            for currency in CurrencyUtil().currencyArray {
                let idAction = UIAlertAction(title: currency["value"] ?? "USD", style: .default, handler: {
                    action in
                    CurrencyUtil().setCurrentCurrency(currency["value"])
                    Walletverse.changeCurrency(currency: CurrencyUtil().getCurrentCurrencyEnum())
                    self.mainTableV.reloadData()
                })
                alertSheet.addAction(idAction)
            }
            let cancelAction = UIAlertAction(title: LocalString("cancel"), style: .cancel, handler: {
                action in
                
            })
            alertSheet.addAction(cancelAction)
            present(alertSheet, animated: true, completion: nil)
            break
        case 2:
            let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            for unit in UnitUtil().unitArray {
                let idAction = UIAlertAction(title: unit, style: .default, handler: {
                    action in
                    UnitUtil().setCurrentUnit(unit)
                    Walletverse.changeUnit(unit: UnitUtil().getCurrentUnitEnum())
                    self.mainTableV.reloadData()
                })
                alertSheet.addAction(idAction)
            }
            let cancelAction = UIAlertAction(title: LocalString("cancel"), style: .cancel, handler: {
                action in
                
            })
            alertSheet.addAction(cancelAction)
            present(alertSheet, animated: true, completion: nil)
            break
        
        default:
            break
        }
    }
    
}
