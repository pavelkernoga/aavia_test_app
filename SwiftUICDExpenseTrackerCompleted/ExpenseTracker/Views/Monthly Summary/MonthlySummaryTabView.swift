//
//  MonthlySummary.swift
//  ExpenseTracker
//
//  Created by pavel on 8.06.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI

struct MonthlySummaryTabView: View {
    
    @State private var sortType = SortType.date
    @State private var sortOrder = SortOrder.descending
    
    var body: some View {
        MonthsListView(sortDescriptor: ExpenseLogSort(sortType: sortType, sortOrder: sortOrder).sortDescriptor)
    }
}

struct MonthlySummaryTabView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlySummaryTabView()
    }
}
