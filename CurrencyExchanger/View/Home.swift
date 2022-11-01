//
//  Home.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-02.
//

import SwiftUI

struct Home: View {
    
    @FocusState private var keyboardFocused: Bool
    @State var itemName = ""
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
                                Text("1000.00 EUR")
                                    .padding(.leading, 15)                   .padding(.trailing, 50)
                                Text("0.00 USD")
                                    .padding(.leading, 15)                       .padding(.trailing, 50)
                                Text("0.00 BGN")
                                    .padding(.leading, 15)                       .padding(.trailing, 50)
                                Text("0.00 NNN")
                                    .padding(.leading, 15)                       .padding(.trailing, 50)
                            }
                            .lineLimit(1)
                            .font(.headline)
                            .foregroundColor(.black)
                            
                        }
                        
                    }.padding(.vertical, 35 * scale)
                    
                    
                }
                
                
                VStack(alignment: .leading, spacing: 20) {
                    //      VStack(alignment: .center, spacing: 20) {
                    //    HStack{
                    Text("CURRENCY EXCHANGE")
                        .foregroundColor(.secondary)
                        .font(.headline)
                        .padding(.leading, 5)
                    //     }
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
                                
                                TextField("100", text: $itemName)
                                    .frame(width: 70)
                                    .keyboardType(.decimalPad )
                                    .focused($keyboardFocused)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            keyboardFocused = true
                                        }
                                    }
                                
                              
                                Menu {
                                               Button(action: {
                                                  
                                               }) {
                                                   Text("USD")
                                               }
                                    Button(action: {
                                       
                                    }) {
                                        Text("BGN")
                                    }
                                           } label: {
                                               HStack(spacing: 3){
                                                   Text("EUR")
                                                   Image(systemName: "control")
                                                       .rotationEffect(.radians(.pi))
                                               }
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
                                Text("+ 110.30")
                                    .foregroundColor(.green)
                                    .padding(.trailing, 10)
                                
                                HStack(spacing: 3){
                                    Text("USD")
                                    Image(systemName: "control")
                                        .rotationEffect(.radians(.pi))
                                }
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
                
                Button(action: {}){
                    
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
                
                
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear{
                print(proxy.frame(in: .global))
            }
            .onChange(of: proxy.frame(in: .global)){ frame in
                print(frame)
                
                
            }
            
        }
        
        
    }
}
