//
//  EditExpenseView.swift
//  Roomies
//
//  Created by Michael on 10/5/2025.
//

import SwiftUI

import SwiftUI

struct EditExpenseView: View {
    @EnvironmentObject var expenseListManager: ExpenseListManager
    @EnvironmentObject var roommateListManager: RoommateListManager
    
    @ObservedObject var expenseDetailManager: ExpenseDetailManager

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var amount: String = ""
    @State private var selectedPayer: Roommate?
    @State private var selectedSplits: [Roommate: Double] = [:]
    @State private var showPercentError = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            RoomieColors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Edit Expense")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(RoomieColors.text)

                    TextField("Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    VStack(alignment: .leading) {
                        Text("Who paid?")
                            .foregroundColor(RoomieColors.text)

                        Picker("Payer", selection: $selectedPayer) {
                            ForEach(roommateListManager.roommates) { roommate in
                                Text(roommate.name).tag(Optional(roommate))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(RoomieColors.elevatedBackground)
                        .cornerRadius(10)
                    }

                    VStack(alignment: .leading) {
                        Text("Split between:")
                            .foregroundColor(RoomieColors.text)
                        ForEach(roommateListManager.roommates) { roommate in
                            HStack {
                                Text(roommate.name)
                                    .foregroundColor(RoomieColors.text)
                                Spacer()
                                TextField("Percentage", value: Binding(
                                    get: { selectedSplits[roommate] ?? 0 },
                                    set: { selectedSplits[roommate] = $0 }
                                ), formatter: NumberFormatter())
                                    .keyboardType(.decimalPad)
                                    .frame(width: 60)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Text("%")
                                    .foregroundColor(RoomieColors.text)
                            }
                        }
                    }

                    if showPercentError {
                        Text("Percents don't equal 100!")
                            .foregroundColor(.red)
                    }

                    Button(action: saveChanges) {
                        Text("Save Changes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoomieColors.primaryAccent)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(RoomieColors.elevatedBackground)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            }
        }
        .onAppear {
            populateFields()
        }
    }

    private func populateFields() {
        let expense = expenseDetailManager.expense
        self.title = expense.title
        self.description = expense.description ?? ""
        self.amount = String(format: "%.2f", expense.amount)
        self.selectedPayer = expense.payer
        self.selectedSplits = Dictionary(uniqueKeysWithValues: expense.splits.map { ($0.roommate, $0.percentage) })
    }

    private func saveChanges() {
        guard let payer = selectedPayer,
              let amountValue = Double(amount),
              amountValue > 0 else {
            return
        }

        let totalPercentage = selectedSplits.values.reduce(0, +)
        guard totalPercentage == 100 else {
            showPercentError = true
            return
        }

        showPercentError = false

        let updatedSplits = selectedSplits
            .filter { $0.value > 0 }
            .map { Split(roommate: $0.key, percentage: $0.value) }

        // Apply changes via the manager
        expenseDetailManager.updateTitle(title)
        expenseDetailManager.updateDescription(description)
        expenseDetailManager.updateAmount(amountValue)
        expenseDetailManager.updatePayer(payer)
        expenseDetailManager.updateDate(Date()) // Optionally keep existing date
        for split in updatedSplits {
            expenseDetailManager.updateSplit(for: split.roommate, percentage: split.percentage)
        }

        expenseDetailManager.save()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let roommateListManager = RoommateListManager()
    roommateListManager.mockInit()

    let expenseListManager = ExpenseListManager()
    expenseListManager.mockInit()

    let expenseDetailManager = ExpenseDetailManager(
        expense: expenseListManager.expenses.first!,
        expenseListManager: expenseListManager
    )

    return NavigationStack {
        EditExpenseView(expenseDetailManager: expenseDetailManager)
            .environmentObject(roommateListManager)
            .environmentObject(expenseListManager)
    }
}
