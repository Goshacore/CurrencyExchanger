//
//  ButtonView.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-07.
//

import SwiftUI

struct ButtonView: View {
    @EnvironmentObject var viewModelCurrency: ViewModelCurrency
    
    @Binding var proxy : CGRect
  
    
    var body: some View {
      
        Spacer()
        
        /*
         Button(action: {
             viewModelCurrency.deleteAll()
         }){
             Text("удалить")
         }
    */
         
  
         
         Button(action: {

             viewModelCurrency.currencyСonverter()

         }){
             
             Text("SUBMIT")
                 .font(.body)
                 .frame(width: proxy.width - 50)
                 .padding(.top, 15 )
                 .padding(.bottom, 15 )
                 .foregroundColor(.white)
                 .background(.blue)
                 .clipShape(Capsule())
                 .padding(.bottom, 15)
             
         }
         .task{
        await    viewModelCurrency.currencySynchronization()
         }
         .onDisappear{
             viewModelCurrency.timerInvalidate()
         }
        
         .alert("Currency converted", isPresented:  $viewModelCurrency.openAlert) {
               // Login to the bank
             } message: {
                 Text("You have converted \(viewModelCurrency.sum) \(viewModelCurrency.baseLabel) to \(viewModelCurrency.result) \(viewModelCurrency.buyLabel). Commission Fee - \(viewModelCurrency.comissin) \(viewModelCurrency.baseLabel)")
         }
    }
}


