//
//  PlayView.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 24/2/26.
//
import SwiftUI

struct PlayView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GameBackground()

            VStack {
                VStack(spacing: 5) {
                    Text("CPU")
                        .font(.custom("PressStart2P-Regular", size: 16))
                        .foregroundColor(.white)

                    ZStack {
                        if !vm.computerHand.isEmpty {
                            Image("card_back_computer")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120)
                                .shadow(color: .red.opacity(0.5), radius: 10)

                            Text("\(vm.computerHand.count)")
                                .font(
                                    .system(
                                        size: 30,
                                        weight: .black,
                                        design: .rounded
                                    )
                                )
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 2)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                .frame(width: 120, height: 170)
                        }

                        if let gain = vm.cpuGain {
                            Text("+\(gain)")
                                .font(.custom("PressStart2P-Regular", size: 24))
                                .foregroundColor(.green)
                                .shadow(color: .black, radius: 3)
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .bottom)
                                            .combined(with: .opacity),
                                        removal: .opacity
                                    )
                                )
                                .offset(x: 70, y: -20)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(
                                        deadline: .now() + 1.0
                                    ) {
                                        withAnimation { vm.cpuGain = nil }
                                    }
                                }
                        }
                    }
                }
                .padding(.top, 40)

                Spacer()

                VStack(spacing: 20) {
                    Text(vm.countLabel.uppercased())
                        .font(.custom("PressStart2P-Regular", size: 40))
                        .foregroundColor(.labelCountColor)

                    ZStack {
                        if vm.centerPile.isEmpty {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(
                                        style: StrokeStyle(
                                            lineWidth: 3,
                                            dash: [10]
                                        )
                                    )
                                    .foregroundColor(.gray.opacity(0.5))
                                    .frame(width: 180, height: 260)

                                Text("TAP YOUR DECK\nTO START")
                                    .font(
                                        .custom(
                                            "PressStart2P-Regular",
                                            size: 12
                                        )
                                    )
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                        } else {
                            let displayCards = Array(vm.centerPile.suffix(8))

                            ForEach(displayCards) { card in
                                CardView(card: card)
                                    .shadow(
                                        color: .black.opacity(0.3),
                                        radius: 3,
                                        x: 2,
                                        y: 2
                                    )
                                    .rotationEffect(
                                        .degrees(
                                            Double(abs(card.id.hashValue) % 30)
                                                - 15
                                        )
                                    )
                                    .offset(
                                        x: CGFloat(abs(card.id.hashValue) % 16)
                                            - 8,
                                        y: CGFloat(
                                            abs(card.id.hashValue / 10) % 16
                                        ) - 8
                                    )
                            }
                        }

                        if vm.slapAnimating {
                            Image(
                                vm.lastSlapSource == .player
                                    ? "player-hand" : "computer-hand"
                            )
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 150)
                            .shadow(color: .black, radius: 10)
                            .rotationEffect(
                                .degrees(vm.lastSlapSource == .player ? 0 : 180)
                            )
                            .offset(y: vm.lastSlapSource == .player ? 60 : -60)
                            .transition(
                                .move(
                                    edge: vm.lastSlapSource == .player
                                        ? .bottom : .top
                                ).combined(with: .opacity)
                            )
                        }
                    }
                    .animation(
                        .spring(response: 0.3, dampingFraction: 0.6),
                        value: vm.slapAnimating
                    )

                    Button(action: { vm.playerSlapped() }) {
                        HStack(spacing: 15) {
                            Image(systemName: "hand.raised.fill").font(.title)
                            Text("SLAP!").font(
                                .custom("PressStart2P-Regular", size: 24)
                            )
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 40)
                        .background(Color.red)
                        .cornerRadius(15)
                        .shadow(
                            color: .red.opacity(0.6),
                            radius: 10,
                            x: 0,
                            y: 5
                        )
                    }
                    .padding(.top, 10)
                }

                Spacer()

                VStack(spacing: 5) {
                    ZStack {
                        if !vm.playerHand.isEmpty {
                            Image("card_back_player")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140)
                                .shadow(color: .blue.opacity(0.5), radius: 10)

                            Text("\(vm.playerHand.count)")
                                .font(
                                    .system(
                                        size: 35,
                                        weight: .black,
                                        design: .rounded
                                    )
                                )
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 2)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                .frame(width: 140, height: 200)
                        }

                        if let gain = vm.playerGain {
                            Text("+\(gain)")
                                .font(.custom("PressStart2P-Regular", size: 24))
                                .foregroundColor(.green)
                                .shadow(color: .black, radius: 3)
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .bottom)
                                            .combined(with: .opacity),
                                        removal: .opacity
                                    )
                                )
                                .offset(x: 80, y: -20)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(
                                        deadline: .now() + 1.0
                                    ) {
                                        withAnimation { vm.playerGain = nil }
                                    }
                                }
                        }
                    }
                    .onTapGesture { vm.playerFlipped() }

                    Text("YOU")
                        .font(.custom("PressStart2P-Regular", size: 20))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 50)
            }

            VStack {
                HStack {
                    Spacer()
                    Button(action: { vm.pauseGame() }) {
                        Image(systemName: "pause.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(10)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 50)
                }
                Spacer()
            }

            if vm.showCorrectFeedback {
                Text(vm.feedbackMessage)
                    .font(.custom("PressStart2P-Regular", size: 30))
                    .foregroundColor(.green)
                    .shadow(color: .black, radius: 5)
            }

            if vm.showWrongFeedback {
                Text(vm.feedbackMessage)
                    .font(.custom("PressStart2P-Regular", size: 30))
                    .foregroundColor(.red)
                    .shadow(color: .black, radius: 5)
            }

            if vm.isPaused {
                ZStack {
                    Color.black.opacity(0.75).ignoresSafeArea()

                    VStack(spacing: 30) {
                        Text("PAUSED")
                            .font(.custom("PressStart2P-Regular", size: 36))
                            .foregroundColor(.white)

                        Button(action: { vm.resumeGame() }) {
                            Text("RESUME").menuButtonStyle(color: .resumeGame)
                        }

                        Button(action: {
                            vm.cleanup()
                            vm.isPaused = false
                            vm.phase = .countdown
                        }) {
                            Text("RESTART").menuButtonStyle(color: .restartGame)
                        }

                        Button(action: {
                            vm.cleanup()
                            vm.goHomeView = true
                        }) {
                            Text("MAIN MENU").menuButtonStyle(color: .mainMenu)
                        }
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: vm.isPaused)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
