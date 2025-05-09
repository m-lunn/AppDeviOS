
import SwiftUI

struct BalanceSummaryView: View {
    @ObservedObject var expenseListManager: ExpenseListManager
    @ObservedObject var roommateListManager: RoommateListManager
    
    var body: some View {
        VStack {
            if expenseListManager.expenses.isEmpty || roommateListManager.roommates.isEmpty {
                Text("No data to display")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(expenseListManager.calculateBalances(roommates: roommateListManager.roommates)) { balance in
                        HStack {
                            Text("\(balance.from)")
                                .fontWeight(.bold)
                            Text("owes")
                            Text("\(balance.to)")
                                .fontWeight(.bold)
                            Spacer()
                            Text("$\(String(format: "%.2f", balance.amount))")
                                .foregroundColor(.red)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationTitle("Settlement Summary")
        .background(RoomieColors.background.ignoresSafeArea())
    }
}
