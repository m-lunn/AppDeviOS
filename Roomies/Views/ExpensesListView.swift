//
//  ExpensesListView.swift
//  Roomies
//
//  Created by Michael on 10/5/2025.
//

import SwiftUI

struct ExpensesListView: View {
    
    @EnvironmentObject var expenseListManager: ExpenseListManager
    @EnvironmentObject var roommateListManager: RoommateListManager
    
    var body: some View {
        ZStack {
            RoomieColors.background
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Text("Expenses")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                    
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(expenseListManager.expenses) { expense in
                            ExpenseRowView(expense: expense)
                                .environmentObject(expenseListManager)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    let expenseListManager = ExpenseListManager()
    expenseListManager.mockInit()
    return NavigationStack {
        ExpensesListView()
            .environmentObject(expenseListManager)
    }
}
