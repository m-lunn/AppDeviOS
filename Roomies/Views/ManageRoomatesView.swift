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
    @State private var workingRoommates: [Roommate] = []
    @State private var editingRoommate: Roommate?
    @State private var editedName: String = ""
    @State private var showEditAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    @State private var showUnsavedAlert: Bool = false
    @State private var isDirty: Bool = false
   
    var body: some View {
        ZStack {
            RoomieColors.background
                .ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                            if isDirty {
                                showUnsavedAlert = true
                            } else {
                                dismiss()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(RoomieColors.text)
                        }
                    Spacer()
                    Text("Manage Roommates")
                        .font(.title2)
                        .bold()
                        .foregroundColor(RoomieColors.text)
                    
                    Spacer()
                    
                    Button("Done") {
                        roommateListManager.roommates = workingRoommates
                        roommateListManager.saveRoommates()
                        isDirty = false
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(RoomieColors.primaryAccent)
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                // Roommates list
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(workingRoommates) { roommate in
                            VStack(spacing: 10) {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(RoomieColors.primaryAccent)

                                Text(roommate.name)
                                    .font(.headline)
                                    .foregroundColor(RoomieColors.text)
                                    .multilineTextAlignment(.center)

                                HStack(spacing: 16) {
                                    // Edit
                                    Button(action: {
                                        editingRoommate = roommate
                                        editedName = roommate.name
                                        showEditAlert = true
                                    }) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.gray)
                                    }

                                    // Delete
                                    Button(action: {
                                        deleteRoommate(roommate)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoomieColors.elevatedBackground)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal)
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
            .onAppear {
                self.workingRoommates = roommateListManager.roommates
            }
            .padding()
        }
        .alert("Edit Name", isPresented: $showEditAlert, actions: {
            TextField("Name", text: $editedName)
            Button("Save", action: updateRoommate)
            Button("Cancel", role: .cancel, action: {})
        })
        .alert("Unsaved changes will be lost. Are you sure you want to leave?", isPresented: $showUnsavedAlert) {
            Button("Leave Anyway", role: .destructive) {
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
        .navigationBarBackButtonHidden(true)
    }

    private func addRoommate() {
        // Make sure the name is not empty
        guard !newRoommateName.isEmpty else { return }

        // Add the new roommate to the list
        let newRoommate = Roommate(id: UUID(), name: newRoommateName)
        workingRoommates.append(newRoommate)
        // Clear the input field
        newRoommateName = ""
        isDirty = true
    }

    private func deleteRoommate(_ roommate: Roommate) {
        workingRoommates.removeAll { $0.id == roommate.id }
        isDirty = true
    }

    private func updateRoommate() {
        guard let target = editingRoommate,
              let index = workingRoommates.firstIndex(where: { $0.id == target.id }) else { return }
        workingRoommates[index].name = editedName
        isDirty = true
    }
}

struct ManageRoommatesView_Previews: PreviewProvider {
    static var previews: some View {
        ManageRoommatesView(roommateListManager: RoommateListManager())
    }
}
