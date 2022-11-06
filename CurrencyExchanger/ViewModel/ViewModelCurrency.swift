//
//  ViewModelCurrency.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-06.
//

import Foundation

@MainActor
class ViewModelCurrency: ObservableObject {
    
  
    @Published  var state: State = .na
    @Published var hasError: Bool = false
    
  
    @Published var synchronizationTime = 60
    var timer = Timer()
    
    @Published var baseСurrenciesArray = [String]()
    @Published var buyCurrencyArray = [String]()
    
    @Published var baseLabel = "N/A"
    @Published var buyLabel = "N/A"
    
    
    @Published var allCurrencies = AllCurrencies.allCases
    
    var posts = [CurrencyDataModel]()
    
     let apiService: ApiServices

    
    init(apiService: ApiServices){
        self.apiService = apiService
    }
    
    
    func currencySynchronization() {
        let timeInterval = synchronizationTime
        timer =   Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
      self.synchronizationTime -= 1
       if self.synchronizationTime < 0 {
           Task {
                 await self.getPosts()
             }
           
        self.synchronizationTime = timeInterval
              
          }
        }
    }
    
    func timerInvalidate() {
        timer.invalidate()
        synchronizationTime = 60
        
    }

    func getPosts() async{
        hasError = false
        self.state = .loading
        do {
            let posts = try await apiService.getPosts() as! [CurrencyDataModel]
            self.state = .success(date: posts)
            self.posts = posts
            
            
            /*
            baseСurrenciesArray = baseСurrencies(buyCurrency: buyLabel, currencyDataModeles: posts)
            buyCurrencyArray = buyCurrency(baseCurrency: baseLabel, currencyDataModeles: posts)
            baseLabel = labelValueUppdate(currentLabelValue: baseLabel, currencyArray: baseСurrenciesArray)
            */
        } catch {
            hasError = true
            self.state = .failed(error: error)
            
        }
        
        
        
    }
}


extension ViewModelCurrency {
    
    enum State {
        
        case na
        case loading
        case success(date: [Codable])
        case failed(error: Error)
        
    }
    
   
 
    
    
    
}
