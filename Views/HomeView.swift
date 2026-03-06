//
//  HomeView.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 21/2/26.
//
import SwiftUI

struct HomeView: View {
    @State private var navigationID = UUID()
    @State private var isAnimating = false
    @StateObject private var vm = GameViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                GameBackground()

                VStack {
                    Text("TEPUK\nNYAMUK")
                        .font(.custom("PressStart2P-Regular", size: 45))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .red, .orange, .yellow, .green, .blue,
                                    .purple, .pink,
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(
                            color: .white.opacity(0.4),
                            radius: 5,
                            x: 0,
                            y: 5
                        )
                        .hueRotation(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            .linear(duration: 3.0).repeatForever(
                                autoreverses: false
                            ),
                            value: isAnimating
                        )
                        .padding(.horizontal)
                        .padding(.top, 40)

                    Spacer()

                    Image("mosquito-dashboard-image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .shadow(
                            color: .black.opacity(0.5),
                            radius: 20,
                            x: 0,
                            y: 10
                        )
                        .offset(y: isAnimating ? -15 : 15)
                        .animation(
                            .easeInOut(duration: 1.2).repeatForever(
                                autoreverses: true
                            ),
                            value: isAnimating
                        )

                    Spacer()

                    VStack(spacing: 25) {
                        NavigationLink(destination: DifficultyView(vm: vm)) {
                            Text("START GAME")
                                .menuButtonStyle(color: .primaryButton)
                        }

                        NavigationLink(destination: SettingsView()) {
                            Text("SETTINGS")
                                .secondaryButtonStyle(color: .secondaryButton)
                        }

                        NavigationLink(destination: TutorialView()) {
                            Text("HOW TO PLAY")
                                .secondaryButtonStyle(color: .secondaryButton)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .onAppear {
                vm.goHomeView = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAnimating = true
                }
                AudioManager.shared.playBGM(
                    filename: "lobby-music",
                    volume: 0.4
                )
            }
            .onDisappear {
                isAnimating = false
            }
        }
        .id(navigationID)
        .onChange(of: vm.goHomeView) { _, goHome in
            if goHome {
                navigationID = UUID()
                vm.goHomeView = false
            }
        }
    }
}
