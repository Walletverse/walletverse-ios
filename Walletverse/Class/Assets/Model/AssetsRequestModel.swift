//
//  AssetsRequestModel.swift
//  Marcopolo
//
//  Created by 彰雪林 on 2020/4/13.
//  Copyright © 2020 marcopolo. All rights reserved.
//

import HandyJSON

class AssetsRequestModel: HandyJSON {
    
    var address : String?
    var chain : String?
    var ethFunction : AssetsRequestEthFunction?
    
    required init() {

    }
}

class AssetsRequestEthFunction: HandyJSON {
    
    var inputParameters : Array<AssetsRequestInputParameters>?
    var name : String?
    var outputParameters : Array<AssetsRequestOutputParameters>?
    
    required init() {

    }
}

class AssetsRequestInputParameters: HandyJSON {
    
    var type : String?
    var value : String?
    
    required init() {

    }
}

class AssetsRequestOutputParameters: HandyJSON {
    
    var type : String?
    
    required init() {

    }
}

