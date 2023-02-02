//
//  DappJsonModel.swift
//  Walletverse
//
//  Created by Ky on 2022/10/9.
//  Copyright © 2022 marcopolo. All rights reserved.
//

import UIKit
import HandyJSON

public class DappJsonModel : HandyJSON {
    var from : String?
    var to: String?
    var value : String?
    var data : String?
    var gasPrice : String?
    
    var __type : String?
    
    required public init() {

    }
}
