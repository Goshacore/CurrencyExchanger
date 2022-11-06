//
//  AllCurrencies .swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-04.
//

import Foundation

enum  AllCurrencies : String,  CaseIterable{
  
    case USD
    case EUR
    case GBP
    case AUD
  
      //MARK: You can set the exchange currency for each base currency
     var receiveCurrency : [String] {
          
      switch self {
      default:
          // By default returns all available currencies
          var allCurrenciesWithoutCurrent = AllCurrencies.allCases.map({ $0.rawValue })
          let  index =  allCurrenciesWithoutCurrent.firstIndex(where: {$0 == rawValue})
          allCurrenciesWithoutCurrent.remove(at: index ?? 0)
          return   allCurrenciesWithoutCurrent
          
      }
      }
      
}
