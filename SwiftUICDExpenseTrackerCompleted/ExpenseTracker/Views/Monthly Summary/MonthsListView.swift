//
//  MonthlySymmeryListView.swift
//  ExpenseTracker
//
//  Created by pavel on 8.06.22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct MonthsListView: View {
    
    private let months  = Months.allCases
    @State private var revealDetails = false
    @State private var expanded: Set<String> = []

    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @FetchRequest(
        entity: ExpenseLog.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)
        ]
    )
    private var result: FetchedResults<ExpenseLog>
    
    init(sortDescriptor: NSSortDescriptor) {
        let fetchRequest = NSFetchRequest<ExpenseLog>(entityName: ExpenseLog.entity().name ?? "ExpenseLog")
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        _result = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        Form {
            Text("Select month to see logs")
                .font(.custom("Georgia-Bold", size: 20))
                .foregroundColor(Colors.color2Accent)
                .padding()
            VStack {
                ForEach(Months.allCases) { month in
                    DisclosureGroup(month.rawValue) {
                        VStack(spacing: 16) {
                            if let logs = getResult(result: result, month: month) {
                                ForEach(logs) { log in
                                    HStack {
                                        CategoryImageView(category: log.categoryEnum)
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(log.nameText).font(.headline)
                                            Text(log.dateText).font(.subheadline)
                                            Text(log.noteText).font(.subheadline)
                                        }
                                        Spacer()
                                        Text(log.amountText).font(.headline)
                                            .padding(.vertical, 4)
                                    }
                                    .frame(height: 50)
                                    .padding()
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                                .stroke(Colors.color1Accent, lineWidth: 1))
                                }
                            }
                        }
                    }
                    Divider()
                }
            }
        }
    }
    
    func getResult(result: FetchedResults<ExpenseLog>, month: Months) -> [ExpenseLog]? {
        let value = result.filter { $0.date?.month == month.rawValue }
        return value
    }
    
}

struct MonthsListView_Previews: PreviewProvider {
    static var previews: some View {
        let sortDescriptor = ExpenseLogSort(sortType: .date, sortOrder: .descending).sortDescriptor
        MonthsListView(sortDescriptor: sortDescriptor)
    }
}
