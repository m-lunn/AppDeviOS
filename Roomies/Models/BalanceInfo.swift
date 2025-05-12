import Foundation

struct BalanceInfo: Identifiable, Codable, Equatable {
    var id = UUID()
    let from: String
    let to: String
    let amount: Double
}
