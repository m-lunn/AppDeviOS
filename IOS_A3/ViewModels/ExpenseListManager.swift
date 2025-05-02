//
//  ExpenseManager.swift
//  IOS_A3
//
//  Created by Michael on 2/5/2025.
//

import Foundation

class ExpenseManager : ObservableObject {
    
    @Published var expenses: [Expense] = []
    
    private let storageKey = "expenses"
    
    init() {
        loadExpenses()
    }
    
    func loadExpenses() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            expenses = decoded
        } else {
            expenses = []
        }
    }
    
    func saveExpenses() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func addExpense(_ expense : Expense) {
        expenses.append(expense)
        saveExpenses()
    }
    
    func removeExpense(_ expense : Expense) {
        expenses.removeAll { $0.id == expense.id }
        saveExpenses()
    }
    
    func editExpense(_ updatedExpense : Expense) {
        if let index = expenses.firstIndex(where: { $0.id == updatedExpense.id }) {
            expenses[index] = updatedExpense
            saveExpenses()
        }
    }
}
