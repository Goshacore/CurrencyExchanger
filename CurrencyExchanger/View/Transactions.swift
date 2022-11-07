//
//  Transactions.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-07.
//

import SwiftUI

struct Transactions: View {
    
    @EnvironmentObject var viewModelCurrency: ViewModelCurrency
    @Binding var proxy : CGRect
    @Binding var transactionsOpen : Bool
    var body: some View {
        VStack {
        HStack{
            
            Image(systemName: "xmark.circle")
                .offset(x: 10)
                .foregroundColor(Color.white)
                .onTapGesture {
                  
                        transactionsOpen.toggle()
                 
                }
            
            Spacer()
            
            Text("Transactions")
                .foregroundColor(Color.white)
                .font(.title3)
            Spacer()
        }
        .frame(width: proxy.width, height: proxy.origin.y + 15 )
        .background(Color.blue)
        
Spacer()
        if viewModelCurrency.transactionItems.count > 0 {
            
        
            List{
                ForEach(viewModelCurrency.transactionItems, id: \.self) { i in
                  
                    VStack(alignment: .leading){
                        Text("Sale currency: \(i.saleСurrency)")
                        Text("Buy currency: \(i.buyСurrency)")
                        Text("Sum 1: \(i.sum1)")
                        Text("Sum2: \(i.sum2)")
                        Text("ComissinFee: \(i.commissionFee)")
                        Text("Date: \(i.transactionDate)")
                    }
                  
                 
                    
                    
                }
                  
               
            }  .listStyle(DefaultListStyle())
            
            
        }
        
            
            
        }
        .frame(width: proxy.width, height: proxy.height)
        .background(Color.white)
    }
}

 
