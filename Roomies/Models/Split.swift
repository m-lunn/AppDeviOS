//
//  Split.swift
//  IOS_A3
//
//  Created by Michael on 2/5/2025.
//

import Foundation

struct Split : Identifiable, Codable {
    var id = UUID()
    var roommate : Roommate
    var percentage : Double
}
