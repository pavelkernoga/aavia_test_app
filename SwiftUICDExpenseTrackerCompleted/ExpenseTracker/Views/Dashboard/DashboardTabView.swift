//
//  DashboardTabView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct DashboardTabView: View {
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @State var totalExpenses: Double?
    @State var categoriesSum: [CategorySum]?
    @State private var currencyExchange = CurrencyExchange.usd
    var model: ResponseData?
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                if totalExpenses != nil {
                    Text("Total expenses")
                        .font(.headline)
                    if totalExpenses != nil {
                        Text(totalExpenses!.formattedCurrencyText)
                            .font(.largeTitle)
                    }
                }
            }
            
            if categoriesSum != nil {
                if totalExpenses != nil && totalExpenses! > 0 {
                    PieChartView(
                        data: categoriesSum!.map { ($0.sum, $0.category.color) },
                        style: Styles.pieChartStyleOne,
                        form: CGSize(width: 300, height: 240),
                        dropShadow: false
                    )
                    
                    Text("Exchange currency")
                    Picker("Exchange currency", selection: $currencyExchange, content: {
                        ForEach(CurrencyExchange.allCases, content: { type in
                            Image(systemName: type == .usd ? "dollarsign.circle" : "eurosign.square")
                        })
                    })
                        .onChange(of: currencyExchange, perform: { tag in
                            if tag == .eur {
                                fetchTotalSums()
                            }
                            if tag == .usd {
                                if let previousSum = UserDefaults.standard.value(forKey: UserDefaults.totalSum) as? Double {
                                    totalExpenses = previousSum
                                }
                            }
                        })
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.all)
                    
                    Text("Selected currency: \(currencyExchange.rawValue.capitalized)")
                }
                
                Divider()

                List {
                    Text("Breakdown").font(.headline)
                    ForEach(self.categoriesSum!) {
                        CategoryRowView(category: $0.category, sum: $0.sum)
                    }
                    .listRowBackground(Colors.ListRowCustomColor)
                }
            }
            
            if totalExpenses == nil && categoriesSum == nil {
                ZStack {
                    Colors.BackgroundCustomColor.edgesIgnoringSafeArea(.all)
                    
                    Group {
                        ZStack {
                            Image("no_expenses_image")
                                .resizable()
                                .aspectRatio(contentMode: .fill).edgesIgnoringSafeArea(.top)
                            Text("No expenses data\nPlease add your expenses from the logs tab")
                                .multilineTextAlignment(.center)
                                .font(.headline)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .onAppear(perform: fetchTotalSums)
    }
    
    func fetchTotalSums() {
        ExpenseLog.fetchAllCategoriesTotalAmountSum(context: self.context) { (results) in
            guard !results.isEmpty else { return }
            
            let totalSum = results.map { $0.sum }.reduce(0, +)
            
            if currencyExchange == CurrencyExchange.eur {
                RequestManager.shared.makePostCall(value: totalSum, fromCurrency: "USD", toCurrency: "EUR", completion: { response in
                    self.totalExpenses = response?.amount
                })
            }
            
            self.totalExpenses = totalSum
            UserDefaults.standard.setValue(totalExpenses, forKey: UserDefaults.totalSum)
            self.categoriesSum = results.map({ (result) -> CategorySum in
                return CategorySum(sum: result.sum, category: result.category)
            })
        }
    }
}


struct CategorySum: Identifiable, Equatable {
    let sum: Double
    let category: Category
    
    var id: String { "\(category)\(sum)" }
}


struct DashboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabView()
    }
}
