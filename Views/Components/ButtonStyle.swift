//
//  ButtonStyle.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 22/2/26.
//
import SwiftUI

extension View {

    func menuButtonStyle(color: Color) -> some View {
        self
            .font(.custom("PressStart2P-Regular", size: 20))
            .foregroundColor(.white)
            .frame(width: 280, height: 75)
            .background(color)
            .cornerRadius(15)
            .shadow(color: color.opacity(0.6), radius: 5, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
            )
    }

    func secondaryButtonStyle(color: Color) -> some View {
        self
            .font(.custom("PressStart2P-Regular", size: 20))
            .foregroundColor(color)
            .frame(width: 280, height: 75)
            .background(Color.black.opacity(0.5))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(color, lineWidth: 3)
            )
    }

    func tutorialButtonStyle(color: Color) -> some View {
        self
            .font(.custom("PressStart2P-Regular", size: 20))
            .foregroundColor(.tutorialButtonText)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(15)
            .shadow(color: .primaryButton.opacity(0.6), radius: 5, x: 0, y: 5)
    }
}
