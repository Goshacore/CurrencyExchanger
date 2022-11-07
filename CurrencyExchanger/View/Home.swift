//
//  Home.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-02.
//

import SwiftUI

struct Home: View {
    @State var proxy = CGRect()
   @StateObject var viewModelCurrency = ViewModelCurrency(apiService: ApiServices())
  //  @EnvironmentObject var viewModelCurrency = ViewModelCurrency(apiService: ApiServices())
    
   @State var transactionsOpen = false
  
    var body: some View {
        GeometryReader { proxy in
       
      
            ZStack{
            VStack{
                
                Header(proxy: $proxy, transactionsOpen: $transactionsOpen)
                ScrollView(.vertical,  showsIndicators: false){
                myBalance(proxy: $proxy)
                    CurrencyExchange(proxy: $proxy)
                ButtonView(proxy: $proxy)
                }
            }
   
            .frame(width: proxy.size.width, height: proxy.size.height)
               
                if transactionsOpen {
                Transactions(proxy: self.$proxy, transactionsOpen: $transactionsOpen)
                }
            }
      //========================
            
            .onAppear{
                print(proxy.frame(in: .global))
                self.proxy = proxy.frame(in: .global)
                
            }
            .onChange(of: proxy.frame(in: .global)){ frame in
                print(frame)
                
                self.proxy = proxy.frame(in: .global)
           
            }
            .environmentObject(viewModelCurrency)
  
         }

        .alert(item: $viewModelCurrency.appError) { appAlert in
            Alert(title: Text("Error"), message: Text( "\(appAlert.errorString)")  )
        }
        .onDisappear{
            viewModelCurrency.timerInvalidate()
            
            
        }
        
    }
}
