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
    case AUD
//  case BBB
  
      //MARK: You can set the exchange currency for each base currency
     var receiveCurrency : [AllCurrencies] {
          
      switch self {
      default:
          // By default returns all available currencies
          var allCurrenciesWithoutCurrent = AllCurrencies.allCases
          allCurrenciesWithoutCurrent.remove(at: rawValue)
          return   allCurrenciesWithoutCurrent
          
      }
      }
      
}
