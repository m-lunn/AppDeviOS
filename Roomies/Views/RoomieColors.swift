//
//  RoomieColours.swift
//  IOS_A3
//
//  Created by Michael on 2/5/2025.
//

import Foundation
import SwiftUI

struct RoomieColors {
    
    /// Main accent color for buttons etc.
    static let primaryAccent = Color(red: 239/255, green: 102/255, blue: 18/255)
    
    /// Smaller elements
    static let secondaryAccent = Color.mint
    
    /// Positive balance
    static let positive = Color.green
    
    /// Negative balance
    static let negative = Color.red
    
    /// Background
    static let background = Color(red : 18/255,  green : 18/255, blue : 18/255)
    
    /// For cards/elevated elements on the background
    static let elevatedBackground = Color(red : 30/255,  green : 30/255, blue : 30/255)
    
    /// Subtle border/divider color
    static let divider = Color(.systemGray4)
    
    /// Primary text color
    static let text = Color(.systemGray6)
}
#Preview {
        ZStack {
            RoomieColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Text")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(RoomieColors.text)
                
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                        .fill(RoomieColors.elevatedBackground)
                    VStack (spacing: 20){
                        Text("More text")
                            .font(.title2)
                            .foregroundColor(RoomieColors.text)
                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                            .fill(RoomieColors.primaryAccent)
                            .frame(width: 300, height: 80)
                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                            .fill(RoomieColors.secondaryAccent)
                            .frame(width: 300, height: 20)
                        Text("Positive balance")
                            .foregroundColor(RoomieColors.positive)
                        Text("Negative balance")
                            .foregroundColor(RoomieColors.negative)
                        Divider()
                            .overlay(RoomieColors.divider)
                    }

                }
            }
            .padding()
        }
}
