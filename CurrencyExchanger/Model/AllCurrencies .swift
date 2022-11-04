//
//  AllCurrencies .swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-04.
//

import Foundation

enum  AllCurrencies : Int,  CaseIterable{
  
    case USD
    case EUR
    case GBP
    case NNN
  
      // You can set the exchange currency for each base currency
     var receiveCurrency : [AllCurrencies] {
          
      switch self {
      default:
          var a = AllCurrencies.allCases
          a.remove(at: rawValue)
          print("QQQQQQQQQ\(rawValue)")
          return  AllCurrencies.allCases
          }
      }
      
}
