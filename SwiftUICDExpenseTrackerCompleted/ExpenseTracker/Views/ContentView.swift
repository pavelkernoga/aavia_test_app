//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        if #available(iOS 14.0, *) {
            UITabBar.appearance().backgroundColor = UIColor(Colors.TabBarCustomColor)
            UITableView.appearance().backgroundColor = UIColor(Colors.ListBackroundCustomColor)
            UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]
        } else {
            UITabBar.appearance().backgroundColor = UIColor(red: 219, green: 212, blue: 248, alpha: 1)
            UITableView.appearance().backgroundColor = UIColor(red: 190, green: 222, blue: 232, alpha: 1)
        }
     }
    
    var body: some View {
        TabView {
            DashboardTabView()
                .tabItem {
                    VStack {
                        Text("Dashboard")
                        Image(systemName: "chart.pie")
                    }
            }
            .tag(0)
            
            LogsTabView()
                .tabItem {
                    VStack {
                        Text("Logs")
                        Image(systemName: "tray")
                    }
            }
            .tag(1)
        }
        .accentColor(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
