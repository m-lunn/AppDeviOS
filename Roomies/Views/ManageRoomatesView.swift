//
//  ManageRoomatesView.swift
//  Roomies
//
//  Created by Trevor Mai on 5/5/2025.
//
import SwiftUI

struct ManageRoommatesView: View {
    @ObservedObject var roommateListManager: RoommateListManager

    @State private var newRoommateName: String = ""
   
    var body: some View {
        ZStack {
            RoomieColors.background
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Manage Roommates")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(RoomieColors.text)

                // Roommates list
                List(roommateListManager.roommates) { roommate in
                    Text(roommate.name)
                        .foregroundColor(.black)
                }
               
                // Add Roommate Section
                HStack {
                    TextField("Enter Roommate's Name", text: $newRoommateName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: addRoommate) {
                        Text("Add")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoomieColors.primaryAccent)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }

    private func addRoommate() {
        // Make sure the name is not empty
        guard !newRoommateName.isEmpty else { return }

        // Add the new roommate to the list
        let newRoommate = Roommate(id: UUID(), name: newRoommateName)
        roommateListManager.roommates.append(newRoommate)

        // Clear the input field
        newRoommateName = ""
    }
}

struct ManageRoommatesView_Previews: PreviewProvider {
    static var previews: some View {
        ManageRoommatesView(roommateListManager: RoommateListManager())
    }
}
