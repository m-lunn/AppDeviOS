//
//  ExpenseRowView.swift
//  Roomies
//
//  Created by Michael on 10/5/2025.
//

import SwiftUI

struct ExpenseRowView: View {
    
    @EnvironmentObject var expenseListManager: ExpenseListManager
    
    let expense: Expense

    var body: some View {
        let expenseDetailManager = ExpenseDetailManager(expense: expense, expenseListManager: expenseListManager)
        
        NavigationLink(destination: EditExpenseView(expenseDetailManager: expenseDetailManager)) {
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.headline)
                    .foregroundColor(RoomieColors.primaryAccent)

                Text("Paid by \(expense.payer.name) - $\(expense.amount, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(RoomieColors.secondaryAccent)

                Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(RoomieColors.elevatedBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(RoomieColors.divider, lineWidth: 1)
            )
        }
    }
}
