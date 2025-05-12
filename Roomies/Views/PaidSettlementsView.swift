//
//  PaidSettlementsView.swift
//  Roomies
//
//  Created by Michael on 12/5/2025.
//

import SwiftUI

struct PaidSettlementsView: View {
    @EnvironmentObject var expenseListManager: ExpenseListManager

    var body: some View {
        ZStack {
            RoomieColors.background
                .ignoresSafeArea()

            ScrollView {
                Text("Paid Settlements")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(RoomieColors.text)

                VStack(spacing: 20) {
                    if expenseListManager.settlements.isEmpty {
                        Text("No settlements recorded.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        VStack(spacing: 15) {
                            ForEach(expenseListManager.settlements.sorted(by: { $0.date > $1.date })) { settlement in
                                VStack(alignment: .leading, spacing: 4){
                                    HStack {
                                        Text("\(settlement.from)")
                                            .font(.headline)
                                            .foregroundColor(RoomieColors.text)
                                        Text("paid")
                                            .font(.headline)
                                            .foregroundColor(RoomieColors.primaryAccent)
                                        Text(settlement.to)
                                            .font(.headline)
                                            .foregroundColor(RoomieColors.text)
                                        

                                        Spacer()

                                        Text("$\(String(format: "%.2f", settlement.amount))")
                                            .fontWeight(.bold)
                                            .foregroundColor(RoomieColors.positive)
                                    }
                                    Text(settlement.date.formatted(date: .abbreviated, time: .omitted))
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
                }
                .padding()
                .background(RoomieColors.background)
            }
        }
    }
}

#Preview {
    let expenseListManager = ExpenseListManager()
    expenseListManager.settlements = [
        Settlement(from: "Alice", to: "Bob", amount: 25.0),
        Settlement(from: "Charlie", to: "Alice", amount: 10.0)
    ]

    return NavigationStack {
        PaidSettlementsView()
            .environmentObject(expenseListManager)
            .navigationBarBackButtonHidden(false)
    }
}
