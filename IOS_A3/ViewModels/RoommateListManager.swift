//
//  RoommateManager.swift
//  IOS_A3
//
//  Created by Michael on 2/5/2025.
//

import Foundation

class RoommateListManager : ObservableObject {
    
    @Published var roommates: [Roommate] = []
    
    private let storageKey = "roommates"
    
    init() {
        loadRoommates()
    }
    
    func loadRoommates() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Roommate].self, from: data) {
            roommates = decoded
        } else {
            roommates = []
        }
    }
    
    func saveRoommates() {
        if let encoded = try? JSONEncoder().encode(roommates) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func addRoommate(name: String) {
        roommates.append(Roommate(name: name))
        saveRoommates()
    }
    
    func removeRoommate(_ roommate: Roommate) {
        roommates.removeAll{ $0.id == roommate.id }
        saveRoommates()
    }
    
    func changeRoommateName(_ updatedRoommate: Roommate, name: String) {
        if let index = roommates.firstIndex(where: { $0.id == updatedRoommate.id }) {
            roommates[index].name = name
            saveRoommates()
        }
    }
}
