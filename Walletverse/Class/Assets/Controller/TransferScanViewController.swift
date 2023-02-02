//
//  TransferScanViewController.swift
//  Walletverse
//
//  Created by Ky on 2022/10/11.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit

class TransferScanViewController: ZGScanViewController {

    func setStyle() {
        var style = ZGScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeLineW = 3
        style.photoframeAngleW = 18
        style.photoframeAngleH = 18
        style.isNeedShowRetangle = false
        style.animationImage = UIImage(named: "qrcode_scan_light_green")
        scanStyle = style
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        baseMainV.isHidden = true
        baseNaviBar.backgroundColor = UIColor.clear
        initBaseNaviLeft()
        baseNaviTitle.text = LocalString("scan_transfer_title")
        setNaviBarType(naviBarType: .NaviBarTypeWhite)
        view.bringSubviewToFront(baseNaviBar)
    }

}
