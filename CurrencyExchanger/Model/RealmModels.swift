//
//  RealmModels.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-07.
//


import Foundation
import RealmSwift

final class GroupItem: Object, ObjectKeyIdentifiable {
    
    @objc dynamic var _id = ObjectId.generate()
    
    @objc dynamic var name: String = "new"
    
    override class func primaryKey() -> String? {
        "_id"
    }
    
    var balanceItem = RealmSwift.List<BalanceItem>()
    
    var transactionItem = RealmSwift.List<TransactionItem>()
    
}




final class BalanceItem: Object, ObjectKeyIdentifiable {
    // Identifiable, ObservableObject
    
    
    @objc dynamic var _id = ObjectId.generate()
    
   
    @objc dynamic var currencyName: String = "USD"
    
    @objc dynamic var balance: Double = 0.0
    
    
    // backlink to group
    
    var group = LinkingObjects(fromType: GroupItem.self ,property: "balanceItem")
    
    override class func primaryKey() -> String? {
        "_id"
    }
    
   
    }


final class TransactionItem: Object, ObjectKeyIdentifiable {
    // Identifiable, ObservableObject
    
    
    @objc dynamic var _id = ObjectId.generate()
    
    @objc dynamic var saleСurrency: String = "USD"
    
    @objc dynamic var buyСurrency: String = "EUR"
    
    @objc dynamic var sum1: Double = 0.0
    
    @objc dynamic var sum2: Double = 0.0
    
    @objc dynamic var commissionFee: Double = 0.0
    
    @objc dynamic var transactionDate: Date = Date.now
    
    // backlink to group
    
    var group = LinkingObjects(fromType: GroupItem.self ,property: "transactionItem")
    
    override class func primaryKey() -> String? {
        "_id"
    }
}
