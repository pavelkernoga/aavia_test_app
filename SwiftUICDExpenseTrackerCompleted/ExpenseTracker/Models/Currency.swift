//
//  Currency.swift
//  ExpenseTracker
//
//  Created by pavel on 9.06.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

enum CurrencyExchange: String, CaseIterable, Identifiable {
    case usd
    case eur
    
    var id: CurrencyExchange { self }
}

struct ResponseData: Decodable {
    var amount: Double
    var rate: Double
    
    init(amount: Double, rate: Double) {
            self.amount = amount
            self.rate = rate
        }
}
