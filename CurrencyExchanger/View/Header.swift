//
//  Header.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-07.
//

import SwiftUI

struct Header: View {
    @EnvironmentObject var viewModelCurrency: ViewModelCurrency
    @Binding var proxy : CGRect
    @Binding var transactionsOpen: Bool
    var body: some View {
   
        HStack{
            Image(systemName: "list.dash")
                .offset(x: 10)
                .foregroundColor(Color.white)
                .onTapGesture {
                    withAnimation{
                        transactionsOpen.toggle()
                    }
                }
            
            Spacer()
            Text("Currency converter")
                .foregroundColor(Color.white)
                .font(.title3)
            Spacer()
        }
        .frame(width: proxy.width, height: proxy.origin.y + 15 )
        .background(Color.blue)
        
        
    }
}


