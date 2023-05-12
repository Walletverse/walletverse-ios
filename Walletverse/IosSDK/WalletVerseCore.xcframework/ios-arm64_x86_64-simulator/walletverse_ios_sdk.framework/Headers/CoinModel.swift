//
//  CoinModel.swift
//  walletverse_ios_sdk
//
//  Created by Kylin on 2022/9/23.
//  Copyright © 2022 Coin. All rights reserved.
//

public class CoinModel: Record, NSCoding {
    
    public var id : Int64?
    public var chainId : String?
    public var symbol : String?
    public var name : String?
    public var chainName : String?
    public var contract : String?
    public var contractAddress : String?
    public var iconUrl : String?
    public var scanUrl : String?
    public var rpcUrl : String?
    public var decimals : String?
    public var type : String?
    public var vm : String?
    public var extra : String?
    
    override init() {
        super.init()
    }
    
    init(id: Int64? = nil,chainId: String?,symbol: String?,name: String?,chainName: String?,contract: String?,contractAddress: String?,iconUrl: String?,scanUrl: String?,rpcUrl: String?,decimals: String?,type: String?,vm: String?,extra: String?) {
        super.init()
        self.id = id
        self.chainId = chainId
        self.symbol = symbol
        self.name = name
        self.chainName = chainName
        self.contract = contract
        self.contractAddress = contractAddress
        self.iconUrl = iconUrl
        self.scanUrl = scanUrl
        self.rpcUrl = rpcUrl
        self.decimals = decimals
        self.type = type
        self.vm = vm
        self.extra = extra
    }
    
    required init(row: Row) {
        super.init(row: row)
        id = row[Columns.id]
        chainId = row[Columns.chainId]
        symbol = row[Columns.symbol]
        name = row[Columns.name]
        chainName = row[Columns.chainName]
        contract = row[Columns.contract]
        contractAddress = row[Columns.contractAddress]
        iconUrl = row[Columns.iconUrl]
        scanUrl = row[Columns.scanUrl]
        rpcUrl = row[Columns.rpcUrl]
        decimals = row[Columns.decimals]
        type = row[Columns.type]
        vm = row[Columns.vm]
        extra = row[Columns.extra]
    }
    
    public override func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.chainId] = chainId
        container[Columns.symbol] = symbol
        container[Columns.name] = name
        container[Columns.chainName] = chainName
        
        container[Columns.contract] = contract
        container[Columns.contractAddress] = contractAddress
        container[Columns.iconUrl] = iconUrl
        container[Columns.scanUrl] = scanUrl
        container[Columns.rpcUrl] = rpcUrl
        container[Columns.decimals] = decimals
        container[Columns.type] = type
        container[Columns.vm] = vm
        container[Columns.extra] = extra
    }
    
    public override func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    public override class var databaseTableName: String {
        return "cube_coins"
    }
    
    enum Columns: String, ColumnExpression {
        case id, chainId, symbol, name, chainName, contract, contractAddress, iconUrl, scanUrl, rpcUrl, decimals, type, vm, extra
    }
    
    public required init(coder decoder: NSCoder) {
        super.init()
        self.id = decoder.decodeObject(forKey: "id") as? Int64
        self.chainId = decoder.decodeObject(forKey: "chainId") as? String ?? ""
        self.symbol = decoder.decodeObject(forKey: "symbol") as? String ?? ""
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.chainName = decoder.decodeObject(forKey: "chainName") as? String ?? ""
        
        self.contract = decoder.decodeObject(forKey: "contract") as? String ?? ""
        self.contractAddress = decoder.decodeObject(forKey: "contractAddress") as? String ?? ""
        self.iconUrl = decoder.decodeObject(forKey: "iconUrl") as? String ?? ""
        self.scanUrl = decoder.decodeObject(forKey: "scanUrl") as? String ?? ""
        self.rpcUrl = decoder.decodeObject(forKey: "rpcUrl") as? String ?? ""
        self.decimals = decoder.decodeObject(forKey: "decimals") as? String ?? ""
        self.type = decoder.decodeObject(forKey: "type") as? String ?? ""
        self.vm = decoder.decodeObject(forKey: "vm") as? String ?? ""
        self.extra = decoder.decodeObject(forKey: "extra") as? String ?? ""
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey:"id")
        coder.encode(chainId, forKey:"chainId")
        coder.encode(symbol, forKey:"symbol")
        coder.encode(name, forKey:"name")
        coder.encode(chainName, forKey:"chainName")
        
        coder.encode(contract, forKey:"contract")
        coder.encode(contractAddress, forKey:"contractAddress")
        coder.encode(iconUrl, forKey:"iconUrl")
        coder.encode(scanUrl, forKey:"scanUrl")
        coder.encode(rpcUrl, forKey:"rpcUrl")
        coder.encode(decimals, forKey:"decimals")
        coder.encode(type, forKey:"type")
        coder.encode(vm, forKey:"vm")
        coder.encode(extra, forKey:"extra")
    }
    
    public func fromWalletCoin(walletCoin: WalletCoinModel) {
        self.chainId = walletCoin.chainId
        self.symbol = walletCoin.symbol
        self.name = walletCoin.name
        self.chainName = walletCoin.chainName
        self.contract = walletCoin.contract
        self.contractAddress = walletCoin.contractAddress
        self.iconUrl = walletCoin.iconUrl
        self.scanUrl = walletCoin.scanUrl
        self.rpcUrl = walletCoin.rpcUrl
        self.decimals = walletCoin.decimals
        self.type = walletCoin.type
        self.vm = walletCoin.vm
        self.extra = walletCoin.extra
    }
}
