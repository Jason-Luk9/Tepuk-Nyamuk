//
//  GameBackground.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 25/2/26.
//
import SwiftUI

struct GameBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0F172A"), Color(hex: "020617")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Canvas { context, size in
                let lineSpacing: CGFloat = 4
                for y in stride(from: 0, through: size.height, by: lineSpacing)
                {
                    context.fill(
                        Path(CGRect(x: 0, y: y, width: size.width, height: 1)),
                        with: .color(.black.opacity(0.15))
                    )
                }
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}
