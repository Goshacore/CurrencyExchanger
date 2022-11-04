//
//  ApiType.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-04.
//

import Foundation



enum ApiType {
    
    case getLatest(value: AllCurrencies.AllCases)
    
    var baseURL: String {
        return  "https://api.apilayer.com/"
    }
    
    var headers: [String : String] {
        switch self {
        case .getLatest:
            return ["apikey" : "YtMdYZvLJZMJFD61zP8GaULmufcRAr30"]
       
        }
    }
    
    var path: String {
        switch self {
        case .getLatest: return "exchangerates_data/latest"
    
        }
        
    }
    
    
    var requestesArray : [URLRequest] {
        
        let urlString = baseURL + path

        var arrayURLRequesr: [URLRequest] = []

        switch self {
        case .getLatest(let Currency):
        
           
            for sellCurrency in Currency {
                
                let sellCurrencyString: String = "\(sellCurrency)"
                let receiveCurrencyStringArray = sellCurrency.receiveCurrency.map{"\($0)"}
                let receiveCurrencyString = receiveCurrencyStringArray.joined(separator: ",")
              
                if   var urlComponents = URLComponents(string: urlString) {
                urlComponents.queryItems = [
                URLQueryItem(name: "symbols", value: receiveCurrencyString),
                URLQueryItem(name: "base", value: sellCurrencyString)
             ]
                
                var request = URLRequest(url: (urlComponents.url)!)
                request.allHTTPHeaderFields = headers
                request.httpMethod = "GET"
                    
                arrayURLRequesr.append(request)
                } else {print("ERROR")}
            }
            return arrayURLRequesr
  
            
        }
        
        
        
    }
    
}
