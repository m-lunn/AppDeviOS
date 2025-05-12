import SwiftUI

struct BalanceSummaryView: View {
    @EnvironmentObject var expenseListManager: ExpenseListManager
    @EnvironmentObject var roommateListManager: RoommateListManager
    
    var body: some View {
        ZStack {
            RoomieColors.background
                .ignoresSafeArea()

            ScrollView {
                Text("Balance Summary")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(RoomieColors.text)
                VStack(spacing: 20) {
                    if expenseListManager.calculateBalances(roommates: roommateListManager.roommates).isEmpty {
                        Text("No balances to display. All settled up.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        VStack() {
                            ForEach(expenseListManager.calculateBalances(roommates: roommateListManager.roommates)) { balance in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(balance.from) owes")
                                            .foregroundColor(RoomieColors.text)
                                        Text(balance.to)
                                            .font(.headline)
                                            .foregroundColor(RoomieColors.text)
                                    }
                                    Spacer()
                                    Text("$\(String(format: "%.2f", balance.amount))")
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(RoomieColors.elevatedBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(RoomieColors.divider, lineWidth: 1)
                                )
                                Button(action: {
                                    expenseListManager.createSettlement(from: balance.from, to: balance.to, amount: balance.amount)
                                }) {
                                    Text("Mark As Paid")
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .background(RoomieColors.positive)
                                        .cornerRadius(8)
                                }
                                Spacer()
                                    .frame(height: 20)
                            }
                        }

                    }
                    Spacer()
                    NavigationLink(destination: PaidSettlementsView()) {
                        Text("View Paid Settlements")
                            .font(.headline)
                            .foregroundColor(RoomieColors.secondaryAccent)
                            .padding()
                            .background(RoomieColors.elevatedBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(RoomieColors.divider, lineWidth: 1)
                            )
                    }
                }
                .padding()
                .background(RoomieColors.background)
            }
        }
    }
}

#Preview {
    let roommateListManager = RoommateListManager()
    roommateListManager.mockInit()

    let expenseListManager = ExpenseListManager()
    expenseListManager.mockInit()

    return NavigationStack {
        BalanceSummaryView()
            .environmentObject(roommateListManager)
            .environmentObject(expenseListManager)
            .navigationBarBackButtonHidden(false)
    }
}


