//
//  MockData.swift
//  Roomies
//
//  Created by Michael on 10/5/2025.
//

import Foundation

struct MockData {
    
    static let alice = Roommate(name: "Alice")
    static let bob = Roommate(name: "Bob")
    static let charlie = Roommate(name: "Charlie")
    
    static let roommates: [Roommate] = [alice, bob, charlie]
    
    static let expenses: [Expense] = [
        Expense(
            title: "Groceries",
            amount: 90.0,
            payer: alice,
            date: Date(),
            splits: [
                Split(roommate: alice, percentage: 33.3),
                Split(roommate: bob, percentage: 33.3),
                Split(roommate: charlie, percentage: 33.4)
            ]
        ),
        Expense(
            title: "Electric Bill",
            amount: 120.0,
            payer: bob,
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            splits: [
                Split(roommate: alice, percentage: 50),
                Split(roommate: bob, percentage: 25),
                Split(roommate: charlie, percentage: 25)
            ]
        ),
        Expense(
            title: "Pizza Night",
            amount: 45.0,
            payer: charlie,
            date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            splits: [
                Split(roommate: alice, percentage: 40),
                Split(roommate: bob, percentage: 40),
                Split(roommate: charlie, percentage: 20)
            ]
        )
    ]
}
