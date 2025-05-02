//
//  Expense.swift
//  IOS_A3
//
//  Created by Michael on 2/5/2025.
//

import Foundation

struct Expense : Identifiable, Codable {
    var id = UUID()
    var title : String
    var description : String?
    var amount : Double
    var payer : Roommate
    var date : Date
    var splits : [Split]
}
