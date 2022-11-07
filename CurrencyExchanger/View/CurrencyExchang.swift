//
//  currencyExchang.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-07.
//

import SwiftUI


struct CurrencyExchange: View {
    
    @EnvironmentObject var viewModelCurrency: ViewModelCurrency
    @FocusState private var keyboardFocused: Bool
    @Binding var proxy : CGRect
    
    
    var body: some View {

        VStack(alignment: .leading, spacing: 20) {
            //      VStack(alignment: .center, spacing: 20) {
                HStack{
            Text("CURRENCY EXCHANGE")
                .foregroundColor(.secondary)
                .font(.headline)
                .padding(.leading, 5)
                    
                    Spacer()
                    
                    Text("\(viewModelCurrency.currentPrice, specifier: "%.2f")")
                    
                    Spacer()
                    
                    Text("\(viewModelCurrency.synchronizationTime)")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.trailing, 15)
                        .onTapGesture{
                            
                            viewModelCurrency.timer.invalidate()
                            
                        }
                    
                                           }
            Group{
                VStack(alignment: .trailing,  spacing: 5 ) {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        Text("Sell")
                            .padding(.leading, 5)
                     
                      Spacer()
                 
                        
                        TextField("Sum" ,text: $viewModelCurrency.sum)
                           .padding(.leading, 15)
                        .frame(width: 70)
                         
                            .keyboardType(.decimalPad )
                            .focused($keyboardFocused)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    keyboardFocused = true
                                }
                            }
                            .onTapGesture{
                                keyboardFocused = true
                            }
                            .onChange(of: viewModelCurrency.sum){ value in
                                
                                viewModelCurrency.сurrencyСonverter()
                                
                            }
                        
                        
                        Menu {
                            
                            ForEach(viewModelCurrency.baseСurrenciesArray, id: \.self) { currency in
                                
                                Button(action: {
                                    self.viewModelCurrency.baseLabel = currency
                                    self.viewModelCurrency.updatebuyCurrencyArray()
                                    
                         
                                    
                                    
                                }) {
                                    Text(currency)
                                }
                                
                            }
                                   } label: {
                                       HStack(spacing: 3){
                                           Text("\(viewModelCurrency.baseLabel)")
                                           Image(systemName: "control")
                                               .rotationEffect(.radians(.pi))
                                       }
                                       .frame(width: 60)
                                   }
                                   .menuStyle(BorderlessButtonMenuStyle())
                        
     
                        
                        
                        .padding(.trailing, 15)
            
                        
                        
                    }
                    Divider()
                        .frame(width: proxy.width - 25 - 50 - 5 - 15)
                        .padding(.trailing, 15)
                }
                VStack(alignment: .trailing,  spacing: 5 ) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                        Text("Receive")
                            .padding(.leading, 5)
                        //  .font(.subheadline)
                        Spacer()
                      
                            
                            Text("+ \(viewModelCurrency.result, specifier: "%.2f")")
                      
                            .foregroundColor(.green)
                          //  .frame(width: 70)
                          .padding(.trailing, 15)
                        
                        Menu {
                            
                            ForEach(viewModelCurrency.buyCurrencyArray, id: \.self) { currency in
                                
                                Button(action: {
                                   
                                    viewModelCurrency.buyLabel = currency
                                    viewModelCurrency.updatebaseCurrenciesArray()
                                    
                                    
                                    
                                }) {
                                    Text(currency)
                                }
                                
                            }
                                   } label: {
                                       HStack(spacing: 3){
                                           Text("\(viewModelCurrency.buyLabel)")
                                           Image(systemName: "control")
                                               .rotationEffect(.radians(.pi))
                                       }
                                       .frame(width: 60)
                                   }
                                   .menuStyle(BorderlessButtonMenuStyle())
                        
                        
                        .padding(.trailing, 15)
                    }
                    
                    Divider()
                        .frame(width: proxy.width - 95)
                        .padding(.trailing, 15)
                }
                
                
                
            }
            .lineLimit(1)
            .font(.headline)
            .foregroundColor(.black)
            
            
        }
        .padding(.leading, 15)
    }
}
