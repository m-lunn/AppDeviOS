//
//  ManageRoomatesView.swift
//  Roomies
//
//  Created by Trevor Mai on 5/5/2025.
//

import SwiftUI

struct ManageRoommatesView: View {
    @ObservedObject var roommateListManager: RoommateListManager

    var body: some View {
        VStack {
            Text("Manage Roommates")
                .font(.title)
                .foregroundColor(RoomieColors.text)
            // Placeholder content (you can expand later)
            Text("This is where you'll manage your roommates.")
                .foregroundColor(RoomieColors.text)
                .padding()
        }
        .background(RoomieColors.elevatedBackground)
        .cornerRadius(20)
        .padding()
    }
}

struct ManageRoommatesView_Previews: PreviewProvider {
    static var previews: some View {
        ManageRoommatesView(roommateListManager: RoommateListManager())
    }
}
