//
//  Home.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-02.
//

import SwiftUI

struct Home: View {
    
   @StateObject var viewModelCurrency = ViewModelCurrency(apiService: ApiServices())
  //  @EnvironmentObject var viewModelCurrency = ViewModelCurrency(apiService: ApiServices())
    
   
    
    
    @FocusState private var keyboardFocused: Bool
 //   @State var itemName = ""
    @State var scale = 1.0
    var body: some View {
        GeometryReader { proxy in
       
            VStack{
                HStack{
                    Text("Currency converter")
                        .foregroundColor(Color.white)
                        .font(.title3)
                }
                .frame(width: proxy.size.width, height: proxy.frame(in: .global).origin.y + 15 * scale)
                .background(Color.blue)
      
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("MY BALANCES")
                        .foregroundColor(.secondary)
                        .font(.headline)
                        .padding(.horizontal, 15)
                        .padding(.top, 30 * scale)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            Group{
                                
                                ForEach(viewModelCurrency.allCurrencies, id: \.self) {currency in
                                    
                                    HStack{
                                    Text("1000.00")
                                        Text("\(currency.rawValue)")
                                    }
                                        .padding(.leading, 15)
                                        .padding(.trailing, 50)
                                    
                                }
                      .padding(.trailing, 50)
                            }
                            .lineLimit(1)
                            .font(.headline)
                            .foregroundColor(.black)
                            
                        }
                        
                    }.padding(.vertical, 35 * scale)
                    
                    
                }
                
                
                VStack(alignment: .leading, spacing: 20) {
                    //      VStack(alignment: .center, spacing: 20) {
                        HStack{
                    Text("CURRENCY EXCHANGE")
                        .foregroundColor(.secondary)
                        .font(.headline)
                        .padding(.leading, 5)
                            
                            Spacer()
                            
                            Text("\(viewModelCurrency.currentPrice, specifier: "%.5f")")
                            
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
                        VStack(alignment: .trailing,  spacing: 5 * scale) {
                            HStack {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.red)
                                Text("Sell")
                                    .padding(.leading, 5)
                                //  .font(.subheadline)
                              Spacer()
                                //             Text("100.00")
                                //                .padding(.trailing, 10)
                                
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
                                .frame(width: proxy.size.width - 25 - 50 - 5 - 15)
                                .padding(.trailing, 15)
                        }
                        VStack(alignment: .trailing,  spacing: 5 * scale) {
                            HStack {
                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.green)
                                Text("Receive")
                                    .padding(.leading, 5)
                                //  .font(.subheadline)
                                Spacer()
                              
                                    
                                    Text("+ \(viewModelCurrency.result, specifier: "%.5f")")
                              
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
                                .frame(width: proxy.size.width - 25 - 50 - 5 - 15)
                                .padding(.trailing, 15)
                        }
                        
                        
                        
                    }
                    .lineLimit(1)
                    .font(.headline)
                    .foregroundColor(.black)
                    
                    
                }
                .padding(.leading, 15)
                //    .padding(.trailing, 25)
                
               Spacer()
                
               
                
                Button(action: {
                    /*
                    Task {
                     try   await   currencyViewModel.apiService.getPosts()
                    }
                    */
                    viewModelCurrency.currencySynchronization()
                    
                    
                }){
                    
                    Text("SUBMIT")
                        .font(.body)
                        .frame(width: proxy.size.width - 50)
                        .padding(.top, 15 * scale)
                        .padding(.bottom, 15 * scale)
                        .foregroundColor(.white)
                        .background(.blue)
                        .clipShape(Capsule())
                        .padding(.bottom, 15 * scale)
                    
                }
                .task{
                    
               await    viewModelCurrency.getPosts()
                }
                
                
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear{
                print(proxy.frame(in: .global))
            }
            .onChange(of: proxy.frame(in: .global)){ frame in
                print(frame)
                
                
            }
            .environmentObject(viewModelCurrency)
    
            
        }
        
        
    }
}
