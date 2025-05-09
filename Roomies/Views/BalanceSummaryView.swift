import SwiftUI

struct BalanceSummaryView: View {
    @ObservedObject var expenseListManager: ExpenseListManager
    @ObservedObject var roommateListManager: RoommateListManager

    var body: some View {
        ZStack {
            RoomieColors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Text("Settlement Summary")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(RoomieColors.text)

                    if expenseListManager.expenses.isEmpty || roommateListManager.roommates.isEmpty {
                        Text("No data to display")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        VStack(spacing: 15) {
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
                                .padding()
                                .background(RoomieColors.elevatedBackground)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                            }
                        }
                        .padding(.horizontal)
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
}
