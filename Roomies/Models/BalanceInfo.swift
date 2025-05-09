import Foundation

struct BalanceInfo: Identifiable {
    let id = UUID()
    let from: String
    let to: String
    let amount: Double
}
