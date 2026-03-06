//
//  DifficultyView.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 24/2/26.
//
import SwiftUI

struct DifficultyView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GameBackground()

            VStack {
                Spacer()

                Text("SELECT DIFFICULTY")
                    .font(.custom("PressStart2P-Regular", size: 55))
                    .multilineTextAlignment(.center)
                    .lineSpacing(15)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color(hex: "9CA3AF")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .white.opacity(0.4), radius: 5, x: 0, y: 5)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)

                VStack(spacing: 25) {
                    NavigationLink(destination: CountdownView(vm: vm)) {
                        Text("EASY")
                            .menuButtonStyle(color: .difficultyEasy)
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            vm.difficulty = .easy
                        }
                    )

                    NavigationLink(destination: CountdownView(vm: vm)) {
                        Text("MEDIUM")
                            .menuButtonStyle(color: .difficultyMedium)
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            vm.difficulty = .medium
                        }
                    )

                    NavigationLink(destination: CountdownView(vm: vm)) {
                        Text("HARD")
                            .menuButtonStyle(color: .difficultyHard)
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            vm.difficulty = .hard
                        }
                    )
                }

                Spacer()

                Button(action: {
                    dismiss()
                }) {
                    Text("BACK")
                        .font(.custom("PressStart2P-Regular", size: 20))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color.mainMenu)
                        .cornerRadius(15)
                        .shadow(
                            color: .mainMenu.opacity(0.6),
                            radius: 5,
                            x: 0,
                            y: 5
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
