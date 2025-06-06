//
//  ExpenseManager.swift
//  IOS_A3
//
//  Created by Michael on 2/5/2025.
//

import Foundation

class ExpenseListManager : ObservableObject {
    
    @Published var expenses: [Expense] = []
    @Published var settlements: [Settlement] = []
    
    private let expensesKey = "expenses"
    private let settlementsKey = "settlements"
    
    init() {
        loadExpenses()
        loadSettlements()
    }
    
    func mockInit() {
        expenses = MockData.expenses
    }
    
    func loadExpenses() {
        if let data = UserDefaults.standard.data(forKey: expensesKey),
           let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            expenses = decoded
        } else {
            expenses = []
        }
    }
    
    func saveExpenses() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            expenses = expenses
            UserDefaults.standard.set(encoded, forKey: expensesKey)
        }
    }
    
    func loadSettlements() {
        if let data = UserDefaults.standard.data(forKey: settlementsKey),
           let decoded = try? JSONDecoder().decode([Settlement].self, from: data) {
            settlements = decoded
        } else {
            settlements = []
        }
    }
    
    func saveSettlements() {
        if let encoded = try? JSONEncoder().encode(settlements) {
            settlements = settlements
            UserDefaults.standard.set(encoded, forKey: settlementsKey)
        }
    }
    
    func createSettlement(from: String, to: String, amount: Double) {
        let settlement = Settlement(from: from, to: to, amount: amount)
        settlements.append(settlement)
        saveSettlements()
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

    /// Balances calcualte
    func calculateBalances(roommates: [Roommate]) -> [BalanceInfo] {
        var paidDict: [UUID: Double] = [:]
        var owedDict: [UUID: Double] = [:]
        var balances: [BalanceInfo] = []

        /// Calculates the amount payed and owed by all roommates
        for expense in expenses {
            paidDict[expense.payer.id, default: 0.0] += expense.amount
            for split in expense.splits {
                let owed = expense.amount * (split.percentage / 100)
                owedDict[split.roommate.id, default: 0.0] += owed
            }
        }

        /// Adjust balances for amounts that have already been marked as paid
        for settlement in settlements {
            guard
                let fromID = roommates.first(where: { $0.name == settlement.from })?.id,
                let toID = roommates.first(where: { $0.name == settlement.to })?.id
            else {
                continue
            }
            paidDict[fromID, default: 0.0] += settlement.amount
            owedDict[toID, default: 0.0] += settlement.amount
        }

        // Calculates net balances per roommate
        var netBalance: [UUID: Double] = [:]
        let allIDs = Set(paidDict.keys).union(owedDict.keys)
        for id in allIDs {
            let paid = paidDict[id] ?? 0
            let owed = owedDict[id] ?? 0
            netBalance[id] = paid - owed
        }

        // Splits debt among roommates
        var creditors = netBalance.filter { $0.value > 0 }
        var debtors = netBalance.filter { $0.value < 0 }

        while let debtor = debtors.first(where: { $0.value < 0 }),
              let creditor = creditors.first(where: { $0.value > 0 }) {

            let payAmount = min(creditor.value, -debtor.value)
            
            if let from = roommates.first(where: { $0.id == debtor.key }),
               let to = roommates.first(where: { $0.id == creditor.key }) {
                balances.append(BalanceInfo(
                    from: from.name,
                    to: to.name,
                    amount: round(payAmount * 100) / 100
                ))
            }

            creditors[creditor.key]! -= payAmount
            debtors[debtor.key]! += payAmount

            if abs(creditors[creditor.key]!) < 0.01 { creditors.removeValue(forKey: creditor.key) }
            if abs(debtors[debtor.key]!) < 0.01 { debtors.removeValue(forKey: debtor.key) }
        }

        return balances
    }
}
