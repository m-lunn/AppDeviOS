//
//  Settlement.swift
//  Roomies
//
//  Created by Michael on 12/5/2025.
//

import Foundation

struct Settlement: Identifiable, Codable, Equatable {
    var id = UUID()
    let from: String
    let to: String
    let amount: Double
    var date: Date = Date()
}
