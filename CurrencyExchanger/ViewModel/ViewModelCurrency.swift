//
//  ViewModelCurrency.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-06.
//

import Foundation

@MainActor
class ViewModelCurrency: ObservableObject {
    
  //  @Published private(set) var state: State = .na
    @Published  var state: State = .na
    @Published var hasError: Bool = false
    
  
    @Published var synchronizationTime = 60
    var timer = Timer()
    
    @Published var baseСurrenciesArray = [String]()
    @Published var buyCurrencyArray = [String]()
    
    @Published var baseLabel = "N/A"
    @Published var buyLabel = "N/A"
    
    @Published var currentPrice = 0.0
    @Published var sum = ""
    @Published var result: Double = 0.0
    
    
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
            updateInterface(currencyDataModeles: posts)
            
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
    
    
    
    
    /*
    func getPosts() async{
        
        self.state = .loading
        self.hasError = false
        do {
            let posts = try await apiService.getPostsFromGroup(URLRequestArray: <#[URLRequest]#>, modelType: CurrencyDataModel.Type)
         //   self.state = .success(date: characters)
            
        } catch {
            self.state = .failed(error: error)
            
        }
    }
    */
    
    
    
}
    



extension ViewModelCurrency {
    
    enum State {
        
        case na
        case loading
        case success(date: [Codable])
        case failed(error: Error)
        
    }
    
    func сurrencyСonverter(){
        result = (Double(sum) ?? 0)  * self.currentPrice
    }

    
    
    
    
    
//MARK: interface interaction functions

    
    
    func updatebuyCurrencyArray(){
        self.buyCurrencyArray = buyCurrency(baseCurrency: self.baseLabel, currencyDataModeles: self.posts)
        self.buyLabel =  labelValueUppdate(currentLabelValue: self.buyLabel, currencyArray: buyCurrencyArray)
        self .currentPrice =   self.getCurrentPrice(baseCurrency: self.baseLabel, buyCurrency: self.buyLabel, currencyDataModeles: posts)
        сurrencyСonverter()
    }
    
    
    
    func updatebaseCurrenciesArray(){
        self.baseСurrenciesArray =  baseСurrencies(currencyDataModeles: self.posts)
        self .currentPrice =   self.getCurrentPrice(baseCurrency: self.baseLabel, buyCurrency: self.buyLabel, currencyDataModeles: posts)
        сurrencyСonverter()
    }
    
    func updateInterface(currencyDataModeles: [CurrencyDataModel] ){
        self.baseСurrenciesArray = baseСurrencies(currencyDataModeles: currencyDataModeles)
  //      print("baseCyrrenciesArray \(self.baseСurrenciesArray)")
        self.baseLabel = labelValueUppdate(currentLabelValue: self.baseLabel, currencyArray: baseСurrenciesArray)
   //     print("baseLabel \(self.baseLabel)")
        self.buyCurrencyArray = buyCurrency(baseCurrency: baseLabel, currencyDataModeles: currencyDataModeles)
   //     print("buyCurrencyArray \(self.buyCurrencyArray)")
        self.buyLabel = labelValueUppdate(currentLabelValue: self.buyLabel, currencyArray: self.buyCurrencyArray)
  //      print("buyLabel \(self.buyLabel)")
     self .currentPrice =   self.getCurrentPrice(baseCurrency: self.baseLabel, buyCurrency: self.buyLabel, currencyDataModeles: currencyDataModeles)
        print("currentPrice\(currentPrice)")
        сurrencyСonverter()
        print("result\(result)")
    }
    
    func labelValueUppdate(currentLabelValue: String, currencyArray: [String]) -> String{
        if currentLabelValue == "N/A" && currencyArray.count > 0 {
            return currencyArray[0]
        } else if !currencyArray.contains(currentLabelValue) && currencyArray.count > 0 { return currencyArray[0]
          } else  { return currentLabelValue }
    }
    
    
    
    //MARK: Data decryption functions

    // MARK: Getting an array of base currencies from the data and sorting alphabetically
    
private    func  baseСurrencies(currencyDataModeles: [CurrencyDataModel]) -> [String]{
        var  baseСurrenciesArray : [String]  = [String]()
            baseСurrenciesArray = currencyDataModeles.compactMap {$0.base}
        if baseСurrenciesArray.count == 0 {baseСurrenciesArray.append("N/A") }
        return  baseСurrenciesArray.sorted{ $0 < $1 }
    }
    
    //MARK: getting a dictionary currency - price, for the base currency

private    func exchangeRates(baseCurrency: String, currencyDataModeles: [CurrencyDataModel]) -> [String : Double] {
        var currencyData : CurrencyDataModel =  CurrencyDataModel(rates: nil, base: nil, date: nil)
            if let index = currencyDataModeles.firstIndex(where: {$0.base == baseCurrency}) {
                currencyData = currencyDataModeles[index] }
            return currencyData.rates ?? [String: Double]()
    }
    
    //MARK: obtaining exchangeable currencies for the base currency

 private   func buyCurrency(baseCurrency: String, currencyDataModeles: [CurrencyDataModel]) -> [String] {
        return  self.exchangeRates (baseCurrency: baseCurrency, currencyDataModeles: currencyDataModeles).map{String($0.key) }
    }
    
    //MARK: getting the current price

 private   func getCurrentPrice(baseCurrency: String, buyCurrency: String, currencyDataModeles: [CurrencyDataModel]) -> Double{
      let exchangeRates = exchangeRates(baseCurrency: baseCurrency, currencyDataModeles: currencyDataModeles)
        return exchangeRates[buyCurrency] ?? 0
    }

    
    
}
