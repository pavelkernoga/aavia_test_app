//
//  Months.swift
//  ExpenseTracker
//
//  Created by pavel on 8.06.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

enum Months: String, CaseIterable {
    case january = "January"
    case february = "February"
    case march = "March"
    case april = "April"
    case may = "May"
    case june = "June"
    case july = "July"
    case august = "August"
    case september = "September"
    case october = "October"
    case november = "November"
    case december = "December"
}

extension Months: Identifiable {
    var id: String { rawValue }
}

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: self)
    }
}
