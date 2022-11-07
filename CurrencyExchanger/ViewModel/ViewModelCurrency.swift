//
//  ViewModelCurrency.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-06.
//

import Foundation
import RealmSwift
import Combine



@MainActor
class ViewModelCurrency: ObservableObject {
    
    //MARK: properties interacting with the interface
    
    @Published  var state: State = .na
 
    @Published var synchronizationTime = 60
    var timer = Timer()
    
    @Published var baseСurrenciesArray = [String]()
    @Published var buyCurrencyArray = [String]()
    
    @Published var currentPrice = 0.0
    
    @Published var baseLabel = "N/A"
    @Published var buyLabel = "N/A"
    
    @Published var sum = ""
    @Published var result: Double = 0.0
    
    @Published var allCurrencies = AllCurrencies.allCases
    
    @Published var downloadError = DownloadError.decoderError
        
    @Published var appError: AppError? = nil
    
    @Published var openAlert : Bool = false
    //Bonus
    let bonus: Double = 1000
    
    let bonusCurrency = "USD"
    
    //Comisin
    @Published var comissin: Double = 0.0
    
    
    //MARK: network properties
    var posts = [CurrencyDataModel]()
     let apiService: ApiServices

    //MARK: Realm Data Base property
  @Published var balanceItems = List<BalanceItem>()
 @Published var transactionItems = List<TransactionItem>()
 @Published var selectedGroup: GroupItem? = nil
   var token: NotificationToken? = nil
    var token2: NotificationToken? = nil
    var realm: Realm?
    
     
    init(apiService: ApiServices){
        //MARK: ApiService initialization
        self.apiService = apiService
        //MARK: Realm initialization
        let realm = try? Realm()
        self.realm = realm
        
        if let group = realm?.objects(GroupItem.self).first {
            self.selectedGroup = group
            self.balanceItems = group.balanceItem
            self.transactionItems = group.transactionItem
            
            //MARK: create balance based on available currencies
            
        
        }else {
            
            try? realm?.write({
                let group = GroupItem()
                realm?.add(group)
                self.selectedGroup = group
  
            })
    
        }
        

        
        token = selectedGroup?.balanceItem.observe({ [unowned self] (changes) in
                switch changes {
                case .error(_): break
                case .initial(let items):
                    self.balanceItems = items
                case .update(_, deletions: _, insertions: _, modifications: _):
                    self.objectWillChange.send()
                }
            })
        
        token2 = selectedGroup?.transactionItem.observe({ [unowned self] (changes) in
                switch changes {
                case .error(_): break
                case .initial(let items):
                    self.transactionItems = items
                case .update(_, deletions: _, insertions: _, modifications: _):
                    self.objectWillChange.send()
                }
            })
       
        
        
    }
  

    deinit {
       
        token?.invalidate()
        token2?.invalidate()
    }
    
    
    
    func currencySynchronization() {
        
        Task {
              await self.getPosts()
          }
      
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
       
      
        self.state = .loading
        do {
            let posts = try await apiService.getPosts() as! [CurrencyDataModel]
            self.state = .success(date: posts)
            self.posts = posts
             updateInterface(currencyDataModeles: posts)
  
  
        } catch {
            self.appError = AppError(errorString:"Error 2 :(  you can't trade zero!")
            self.appError = AppError(errorString: error.localizedDescription)
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
    
    func сurrencyСonverter(){
        result = (Double(sum) ?? 0).twoDigits * self.currentPrice
 
    }

    
    struct AppError : Identifiable , Error{
        
        let id = UUID().uuidString
        let errorString: String
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
    
    func updateInterface(currencyDataModeles: [CurrencyDataModel] ) {
        self.baseСurrenciesArray = baseСurrencies(currencyDataModeles: currencyDataModeles)
 
        self.baseLabel = labelValueUppdate(currentLabelValue: self.baseLabel, currencyArray: baseСurrenciesArray)
  
        self.buyCurrencyArray = buyCurrency(baseCurrency: baseLabel, currencyDataModeles: currencyDataModeles)
   
        self.buyLabel = labelValueUppdate(currentLabelValue: self.buyLabel, currencyArray: self.buyCurrencyArray)
  
     self .currentPrice =   self.getCurrentPrice(baseCurrency: self.baseLabel, buyCurrency: self.buyLabel, currencyDataModeles: currencyDataModeles)
        сurrencyСonverter()
        if  posts.compactMap({$0.base}).count == 0 {
            self.appError = AppError(errorString:"Error 1 :(")
        }
      initializeBalance()
        
    }
    
  private  func labelValueUppdate(currentLabelValue: String, currencyArray: [String]) -> String{
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
  
