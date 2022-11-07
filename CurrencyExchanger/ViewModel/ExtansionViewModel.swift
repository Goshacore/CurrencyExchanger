//
//  ExtansionViewModel.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-07.
//

import Foundation
import RealmSwift
import Combine

extension ViewModelCurrency {
  //MARK: returns the number of objects within a time range

    func numberOfObjectsInTimeInterval(timeRange: Int) -> Int{
        let todos = self.realm!.objects(TransactionItem.self) 
        var counter = 0
        for i in todos {
            let now = Date.now.addingTimeInterval(Double(timeRange))
            if now <= i.transactionDate {
                counter += 1
            }
            print(counter)
        print(    now <= i.transactionDate )
        }
         return counter
    }
    
    //MARK: commission algorithm
    func commissionFee(sum: Double) -> Double  {
        if( realm!.objects(TransactionItem.self).count < 5 ){
     
            return 0
        } else    if   numberOfObjectsInTimeInterval(timeRange: -86400) > 14 {
        
       return     sum * 0.012 + 0.3
        } else {
     
         return   sum * 0.007
        }
    }
            
    func currencyСonverter()   {
    //MARK: validation of input parameters
        if ((Double(self.sum) ?? 0) <= 0 || self.result <= 0) {
     
            self.appError = AppError(errorString:"Error 2 :(  you can't trade zero!")
        } else {
            //MARK: getting a currency object from the database
            let baseCurrencyRealmObject =  findBalanceItemByName(currency: baseLabel)
             let buyCurrencyRealmObject = findBalanceItemByName(currency: buyLabel)
            //MARK: for simplicity, moved the properties into a function
            let sum  = (Double(self.sum) ?? 0).twoDigits
            let result = result
            
            //MARK: commission calculation and purchase amount update
            comissin =  commissionFee(sum: sum).twoDigits
            сurrencyСonverter()
             //MARK: calculation of updated balances
             let result1 =  baseCurrencyRealmObject.balance - (Double(self.sum) ?? 0)
             let result2  =  buyCurrencyRealmObject.balance + result
             //MARK: negative balance check
        if result1 <= 0 || result2 <= 0 {
            self.appError = AppError(errorString:"Error 3:( balance cannot be negative")
          self.state = .failed(error: NetworkError.generalError)
        } else {
             //MARK: updating balances in the database
        updateBalanceItem(balanceItem: baseCurrencyRealmObject, newPrice: result1)
        updateBalanceItem(balanceItem: buyCurrencyRealmObject, newPrice: result2)
         //MARK: writing the transaction object to the database
            addTransactionItem(sum1: result1, sum2: result2, commissionFee: comissin)
            openAlert = true
        }
        }
        
       
    }
    
    
    
    //MARK: database functions
    func initializeBalance() {
        
      for currency in AllCurrencies.allCases {

           if let realm = selectedGroup?.realm{
               
              let contains = balanceItems.where {
                     $0.currencyName.contains(currency.rawValue)
                    }
               if contains.count == 0 {
                   try? realm.write {
                      let balanceItem = BalanceItem()
                       balanceItem.currencyName = currency.rawValue
                       selectedGroup?.balanceItem.append(balanceItem)
                 }
            }
          }
   }
        
      giveABonus()
    }
    
    
    
    func giveABonus(){
        if transactionItems.count == 0 {
         let balanceItem =   findBalanceItemByName(currency: bonusCurrency)
            updateBalanceItem(balanceItem: balanceItem, newPrice: self.bonus)
        }
    }
    
    
 private   func addTransactionItem(sum1: Double, sum2: Double, commissionFee: Double ){
        
        if let realm = selectedGroup?.realm {
            try? realm.write {
                let transactionItem = TransactionItem()
                transactionItem.saleСurrency = baseLabel
                transactionItem.buyСurrency = buyLabel
                transactionItem.sum1 = sum1
                transactionItem.sum2 = sum2
                transactionItem.commissionFee = commissionFee
                selectedGroup?.transactionItem.append(transactionItem)
                print(transactionItem)
            
            }
        }
        
    }

    
    
    
 private   func findBalanceItemByName(currency: String) -> BalanceItem {
        
   let  findCurrency = realm!.objects(BalanceItem.self).where {
            $0.currencyName == currency
        }.first ?? BalanceItem()
        return findCurrency
    }
    
    
  private  func updateBalanceItem(balanceItem: BalanceItem, newPrice : Double){
        
        if let realm = selectedGroup?.realm {
            try? realm.write {
                balanceItem.balance = newPrice
    }
        }
         
    }
    
    
    
    
    func deleteAll(){
        let realm = try! Realm()
        try! realm.write {
             
            let balance = realm.objects(BalanceItem.self)
            let transactions = realm.objects(TransactionItem.self)
            realm.delete(balance)
            realm.delete(transactions)
        }
        
    }


}


