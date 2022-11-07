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
            return ["apikey" : "OwEUzSi2MpZvunZMtz7BD0XvdFg5vz1D"]
       
            
         //   33BGWnP0E31rTxxyCv9jTz2RpEruheKJ
        }
        
        
    }
    
    var path: String {
        switch self {
        case .getLatest: return "exchangerates_data/latest"
    
        }
        
    }
    
    
    var requestesArray : [URLRequest] {
        
        // MARK: Create URL from URL elements
        let urlString = baseURL + path

        // MARK: Create empty URLRequestes array
        var arrayURLRequestes: [URLRequest] = []

        switch self {
        case .getLatest(let Currency):
        
           
            for sellCurrency in Currency {
                
                // MARK: Create a query components and add it in urlComponents
                let sellCurrencyString: String = "\(sellCurrency)"
                let receiveCurrencyStringArray = sellCurrency.receiveCurrency
                let receiveCurrencyString = receiveCurrencyStringArray.joined(separator: ",")
              
                if   var urlComponents = URLComponents(string: urlString) {
                urlComponents.queryItems = [
                URLQueryItem(name: "symbols", value: receiveCurrencyString),
                URLQueryItem(name: "base", value: sellCurrencyString)
             ]
                    // MARK: Create URLReqyest based on the urlComponents
                var request = URLRequest(url: (urlComponents.url)!)
                request.allHTTPHeaderFields = headers
                request.httpMethod = "GET"
                    
                    // MARK: Add URLReqyest in Array
                    arrayURLRequestes.append(request)
                } else {     DownloadError.invalidURL}
            }
            return arrayURLRequestes
  
            
        }
        
        
        
    }
    
}
