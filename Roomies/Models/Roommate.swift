//
//  Roomie.swift
//  IOS_A3
//
//  Created by Michael on 2/5/2025.
//

import Foundation

struct Roommate : Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
}
