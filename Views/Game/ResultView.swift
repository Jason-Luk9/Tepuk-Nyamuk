//
//  ResultView.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 24/2/26.
//
import SwiftUI

struct ResultView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GameBackground()
            VStack(spacing: 40) {
                Text("GAME OVER")
                    .font(.custom("PressStart2P-Regular", size: 50))
                    .foregroundColor(.yellow)

                Text(vm.winner == "player" ? "YOU WIN!" : "CPU WINS!")
                    .font(.custom("PressStart2P-Regular", size: 30))
                    .foregroundColor(vm.winner == "player" ? .green : .red)

                VStack(spacing: 20) {
                    Button(action: {
                        vm.cleanup()
                        vm.phase = .countdown
                    }) {
                        Text("PLAY AGAIN")
                            .menuButtonStyle(color: .primaryButton)
                    }

                    Button(action: {
                        vm.cleanup()
                        vm.goHomeView = true

                    }) {
                        Text("MAIN MENU")
                            .secondaryButtonStyle(color: .secondaryButton)
                    }
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}
