//
//  HomeScreen.swift
//  Roomies
//
//  Created by Trevor Mai on 5/5/2025.
//
import SwiftUI

struct HomeScreen: View {
    @ObservedObject var expenseListManager: ExpenseListManager
    @ObservedObject var roommateListManager: RoommateListManager

    var body: some View {
        NavigationStack {
            ZStack {
                // Base dark background fills full screen
                RoomieColors.background
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    VStack(spacing: 20) {
                        Image("Logo transparent")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .padding(.top, 30)

                        VStack(spacing: 15) {
                            NavigationLink(destination: AddExpenseView()) {
                                Text("➕ Add Expense")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(RoomieColors.primaryAccent)
                                    .cornerRadius(10)
                            }

                            NavigationLink(destination: ManageRoommatesView()) {
                                Text("👥 Manage Roommates")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(RoomieColors.primaryAccent)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)

                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(expenseListManager.expenses) { expense in
                                    ExpenseRow(expense: expense)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 30)
                    }
                    .padding()
                    .background(RoomieColors.elevatedBackground)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding()
                }
            }
        }
    }
}

// ExpenseRow and BalanceRow remain unchanged

struct ExpenseRow: View {
    var expense: Expense

    var body: some View {
        HStack {
            Text(expense.title)
                .font(.headline)
                .foregroundColor(RoomieColors.text)
            Spacer()
            Text("$\(String(format: "%.2f", expense.amount))")
                .foregroundColor(RoomieColors.text)
        }
        .padding()
        .background(RoomieColors.elevatedBackground)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct BalanceRow: View {
    var roommate: Roommate
    var expenseListManager: ExpenseListManager

    private func calculateBalance(for roommate: Roommate) -> Double {
        let totalPaid = expenseListManager.expenses
            .filter { $0.payer.id == roommate.id }
            .map { $0.amount }
            .reduce(0, +)

        var totalOwed = 0.0
        for expense in expenseListManager.expenses {
            for split in expense.splits {
                if split.roommate.id == roommate.id {
                    totalOwed += expense.amount * (split.percentage / 100)
                }
            }
        }
        return totalPaid - totalOwed
    }

    var body: some View {
        HStack {
            Text(roommate.name)
                .font(.headline)
                .foregroundColor(RoomieColors.text)
            Spacer()
            Text("$\(String(format: "%.2f", calculateBalance(for: roommate)))")
                .foregroundColor(RoomieColors.text)
        }
        .padding()
        .background(RoomieColors.elevatedBackground)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(expenseListManager: ExpenseListManager(), roommateListManager: RoommateListManager())
    }
}
