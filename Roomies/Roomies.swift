//
//  IOS_A3App.swift
//  IOS_A3
//
//  Created by Emily Hogno on 2/5/2025.
//

import SwiftUI

@main
struct RoomiesApp: App {
    @StateObject private var expenseListManager = ExpenseListManager()
    @StateObject private var roommateListManager = RoommateListManager()

    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(expenseListManager)
                .environmentObject(roommateListManager)
        }
    }
}
