//
//  Extension.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-07.
//



extension Double {
    var threeDigits: Double {
        return (self * 1000).rounded(.toNearestOrEven) / 1000
    }
    
    var twoDigits: Double {
        return (self * 100).rounded(.toNearestOrEven) / 100
    }
    
    var oneDigit: Double {
        return (self * 10).rounded(.toNearestOrEven) / 10
    }
}
