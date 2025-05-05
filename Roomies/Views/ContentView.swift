//
//  ContentView.swift
//  IOS_A3
//
//  Created by Emily Hogno on 2/5/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // This will display the HomeScreen
        HomeScreen(expenseListManager: ExpenseListManager(), roommateListManager: RoommateListManager())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
