//
//  AddExpenseView.swift
//  Roomies
//
//  Created by Trevor Mai on 5/5/2025.
//
import SwiftUI

struct AddExpenseView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var amount: String = ""
    @State private var selectedPayer: Roommate?
    @State private var selectedSplits: [Roommate: Double] = [:]
    @State private var amountValid = false
    @State private var hasSelectedPayer = false
    @State private var showPercentError = false

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var expenseListManager: ExpenseListManager
    @ObservedObject var roommateListManager: RoommateListManager

    var body: some View {
        ZStack {
            RoomieColors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Add Expense")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(RoomieColors.text)

                    // Title
                    TextField("Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Description
                    TextField("Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Amount
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle()).onChange(of: amount) {
                            if Double(amount) ?? 0
                                <= 0 {
                                amountValid = false
                            } else {
                                amountValid = true
                            }
                        }
                    
                    if !amountValid && !amount.isEmpty {
                        Text("Invalid amount")
                            .foregroundColor(Color.red)
                    }

                    // Payer picker
                    VStack(alignment: .leading) {
                        Text("Who paid?")
                            .foregroundColor(RoomieColors.text)
                        HStack {
                            if !hasSelectedPayer {
                                Text("Please select:").foregroundStyle(RoomieColors.text)
                            }
                            Picker("Payer", selection: $selectedPayer) {
                                ForEach(roommateListManager.roommates) { roommate in
                                    Text(roommate.name)
                                        .tag(Optional(roommate))
                                }
                            }.onChange(of: selectedPayer) {
                                hasSelectedPayer = true
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(RoomieColors.elevatedBackground)
                        .cornerRadius(10)
                    }

                    // Splits
                    VStack(alignment: .leading) {
                        Text("Split between:")
                            .foregroundColor(RoomieColors.text)
                        ForEach(roommateListManager.roommates) { roommate in
                            HStack {
                                Text(roommate.name)
                                    .foregroundColor(RoomieColors.text)
                                Spacer()
                                TextField("Percentage", value: Binding(
                                    get: { selectedSplits[roommate] ?? getDefaultPercent() },
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

                    // Save button
                    
                    if showPercentError {
                        Text("Percents don't equal 100!")
                            .foregroundColor(Color.red)
                    }
                    
                    Button(action: saveExpense) {
                        Text("Save Expense")
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
    }

    private func saveExpense() {
        // Ensure the user has selected a payer and the amount is valid
        guard let payer = selectedPayer,
              let amountValue = Double(amount),
              amountValue > 0 else {
            return
        }

        // Ensure split percentages add up to 100%
        let totalPercentage = selectedSplits.values.reduce(0, +)
        if totalPercentage != 100 {
            // Show an error message if splits do not add up to 100%
            print("Doesnt equal 100")
            showPercentError = true
            return
        }
        
        showPercentError = false

        // Build splits array
        var splitsArray: [Split] = []
        for (roommate, percentage) in selectedSplits {
            if percentage > 0 {
                splitsArray.append(Split(roommate: roommate, percentage: percentage))
            }
        }

        // Create the new Expense object
        let newExpense = Expense(
            title: title,
            description: description.isEmpty ? nil : description,
            amount: amountValue,
            payer: payer,
            date: Date(),
            splits: splitsArray
        )

        // Add the new expense to the Expense List Manager
        expenseListManager.expenses.append(newExpense)

        // Dismiss the current view after saving the expense
        presentationMode.wrappedValue.dismiss()
    }
    
    private func getDefaultPercent() -> Double {
        // if you have an amount of roommates that gives you a repeating number
        // i.e. 3 -> 33.3333, it wont add up to 100
        let roommates = roommateListManager.roommates
        let roommateCount = roommates.count
        if (roommateCount < 1) {
            return 100
        }
        let defaultPercent = Double(100/roommateCount)
        for roommate in roommates {
            selectedSplits[roommate] = defaultPercent
        }
        return defaultPercent
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(
            expenseListManager: ExpenseListManager(),
            roommateListManager: RoommateListManager()
        )
    }
}
