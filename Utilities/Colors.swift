//
//  Colors.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 22/2/26.
//
import SwiftUI

extension Color {
    // Text
    static let primaryText = Color(hex: "F9FAFB")  // Crisp White
    static let secondaryText = Color(hex: "9CA3AF")  // Arcade Gray
    static let tutorialButtonText = Color(hex: "0F172A")  // Arcade Black

    // Difficulty Levels
    static let difficultyEasy = Color(hex: "22C55E")  // Emerald Green
    static let difficultyMedium = Color(hex: "FF8C00")  // Electric Orange
    static let difficultyHard = Color(hex: "FF003C")  // Arcade Red

    // General Buttons
    static let primaryButton = Color(hex: "22C55E")  // Emerald Green
    static let secondaryButton = Color(hex: "3B82F6")  // Arcade Blue

    // Pause Buttons
    static let resumeGame = Color(hex: "22C55E")  // Emerald Green
    static let restartGame = Color(hex: "FF8C00")  // Electric Orange
    static let mainMenu = Color(hex: "FF003C")  // Arcade Red

    // Special Elements
    static let labelCountColor = Color(hex: "FDE047")  // Bright Yellow

    // Hex Initializer
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        // The idea is to create a mask that extract the rgb of the hex code and shifts it based on the position
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255
        // Shift 16 times because red is in front 0xFF0000
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255
        // Shift 8 times because green is in the middle 0x00FF00
        let b = Double(rgbValue & 0x0000FF) / 255
        // Does not shift because blue is in the last position
        self.init(red: r, green: g, blue: b)
    }
}
