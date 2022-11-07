//
//  myBalance.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-07.
//

import SwiftUI
struct myBalance: View {
    @EnvironmentObject var viewModelCurrency: ViewModelCurrency
    @Binding var proxy : CGRect
    
    
    
    
    var body: some View {
        if viewModelCurrency.balanceItems.count > 0 {
        VStack(alignment: .leading, spacing: 0) {
            
            
            Text("MY BALANCES")
                .foregroundColor(.secondary)
                .font(.headline)
                .padding(.horizontal, 15)
                .padding(.top, 30 )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
        
                    Group{
                        
                        ForEach(viewModelCurrency.balanceItems.sorted(byKeyPath: "balance", ascending: false),  id: \.self) {currency in
                            
                     
                            Text("\(currency.balance, specifier: "%.2f") \(currency.currencyName)")
                             
                                .padding(.leading, 15)
                        
                            
                        }
              .padding(.trailing, 50)
                    }
                    .lineLimit(1)
                    .font(.headline)
                    .foregroundColor(.black)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                   
                        }
                        
                        
                    }
                        
                }
            }.padding(.vertical, 35)
            
            
        }
        
        }
        
        
    }
}
