//
//  TutorialView.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 18/2/26.
//
import SwiftUI

struct TutorialView: View {
    @AppStorage("isFirstTimeUser") private var isFirstTimeUser = true
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GameBackground()

            VStack(spacing: 20) {
                Text("HOW TO PLAY")
                    .font(.custom("PressStart2P-Regular", size: 26))
                    .foregroundColor(.primaryText)
                    .padding(.top, 50)
                    .padding(.bottom, 10)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        TutorialTextStyle(
                            text: "You and the CPU each get 26 cards."
                        )
                        TutorialTextStyle(
                            text: "Each turn, a card is flipped onto the pile."
                        )
                        TutorialTextStyle(
                            text:
                                "The game counts from Ace to King, then loops back to Ace!"
                        )
                        TutorialTextStyle(
                            text: "If the spoken count MATCHES the card..."
                        )
                        TutorialTextStyle(text: "SLAP IT before the CPU does!")
                        TutorialTextStyle(
                            text:
                                "Correct slap = center pile cards goes to the CPU!"
                        )
                        TutorialTextStyle(
                            text:
                                "Wrong slap or too slow = center pile cards added to your hand!"
                        )
                        TutorialTextStyle(text: "Empty your pile first to WIN!")
                    }
                    .padding(25)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                }
                .padding(.horizontal, 20)

                Spacer()

                Button(action: {
                    if isFirstTimeUser {
                        isFirstTimeUser = false
                    }
                    dismiss()
                }) {
                    Text("I'M READY!")
                        .tutorialButtonStyle(color: .primaryButton)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)

            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
