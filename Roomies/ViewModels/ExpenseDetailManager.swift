//
//  ExpenseManager.swift
//  IOS_A3
//
//  Created by Michael on 2/5/2025.
//

import Foundation

class ExpenseDetailManager : ObservableObject {
    
    @Published var expense: Expense
    
    private let expenseListManager: ExpenseListManager
    
    init(expense: Expense, expenseListManager : ExpenseListManager) {
        self.expense = expense
        self.expenseListManager = expenseListManager
    }
    
    func updateTitle(_ title: String) {
        expense.title = title
    }

    func updateAmount(_ amount: Double) {
        expense.amount = amount
    }

    func updateDate(_ date: Date) {
        expense.date = date
    }

    func updatePayer(_ payer: Roommate) {
        expense.payer = payer
    }
    
    func updateDescription(_ description : String) {
        expense.description = description
    }
    
    func updateSplit(for roommate : Roommate, percentage : Double) {
        if let index = expense.splits.firstIndex(where: { $0.roommate.id == roommate.id }) {
            expense.splits[index].percentage = percentage
        }
    }
    
    func splitsAreValid() -> Bool {
        let sumOfPercentages = expense.splits.map { $0.percentage }.reduce(0, +)
        return sumOfPercentages == 100
    }
    
    func save() {
        expenseListManager.saveExpenses()
    }
        
}
