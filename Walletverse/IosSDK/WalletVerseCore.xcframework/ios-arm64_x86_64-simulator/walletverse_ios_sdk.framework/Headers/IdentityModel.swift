//
//  IdentityModel.swift
//  walletverse_ios_sdk
//
//  Created by Kylin on 2022/9/23.
//  Copyright © 2022 Coin. All rights reserved.
//

public class IdentityModel: Record, NSCoding {
    
    public var id : Int64?
    public var wid : String?
    public var name : String?
    public var tokenType : String?
    public var token : String?
    
    override init() {
        super.init()
    }
    
    init(id: Int64? = nil,wid: String?,name: String?,tokenType: String?,token: String?) {
        super.init()
        self.id = id
        self.wid = wid
        self.name = name
        self.tokenType = tokenType
        self.token = token
    }
    
    public required init(row: Row) {
        super.init(row: row)
        id = row[Columns.id]
        wid = row[Columns.wid]
        name = row[Columns.name]
        tokenType = row[Columns.tokenType]
        token = row[Columns.token]
    }
    
    public override func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.wid] = wid
        container[Columns.name] = name
        container[Columns.tokenType] = tokenType
        container[Columns.token] = token
    }
    
    public override func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    public override class var databaseTableName: String {
        return "cube_identities"
    }
    
    enum Columns: String, ColumnExpression {
        case id, wid, name, tokenType, token
    }
    
    public required init(coder decoder: NSCoder) {
        super.init()
        self.id = decoder.decodeObject(forKey: "id") as? Int64
        self.wid = decoder.decodeObject(forKey: "wid") as? String ?? ""
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.tokenType = decoder.decodeObject(forKey: "tokenType") as? String ?? ""
        self.token = decoder.decodeObject(forKey: "token") as? String ?? ""
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey:"id")
        coder.encode(wid, forKey:"sort")
        coder.encode(name, forKey:"name")
        coder.encode(tokenType, forKey:"tokenType")
        coder.encode(token, forKey:"token")
    }
}
