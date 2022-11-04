//
//  CurrencyModel.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-04.
//

import Foundation

// MARK: - Albums
struct CurrencyDataModel: Codable {
    let rates: [String: Double]?
    let base, date: String?
}
