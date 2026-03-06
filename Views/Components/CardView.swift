//
//  CardView.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 18/2/26.
//
import SwiftUI

struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            if UIImage(
                named: "card_\(card.displayString)_\(card.suit.rawValue)"
            ) != nil {
                Image("card_\(card.displayString)_\(card.suit.rawValue)")
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 180, height: 260)
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .frame(width: 180, height: 260)
                    .shadow(radius: 8)

                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.15), lineWidth: 1.5)
                    .frame(width: 180, height: 260)

                VStack(spacing: 4) {
                    Text(card.displayString)
                        .font(.system(size: 72, weight: .bold, design: .serif))
                    Text(card.suitSymbol)
                        .font(.system(size: 40))
                }
                .foregroundColor(card.isRed ? .red : .black)
            }
        }
    }
}
