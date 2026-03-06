//
//  CountdownView.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 24/2/26.
//
import SwiftUI

struct CountdownView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var startGame = false

    var body: some View {
        ZStack {
            GameBackground()

            VStack(spacing: 20) {
                Text("GET READY!")
                    .font(.custom("PressStart2P-Regular", size: 35))
                    .foregroundColor(.primaryText)

                if vm.countdownNumber > 0 {
                    Text("\(vm.countdownNumber)")
                        .font(.custom("PressStart2P-Regular", size: 100))
                        .foregroundColor(.primaryText)
                        .transition(.scale)
                        .id(vm.countdownNumber)
                        .animation(
                            .spring(response: 0.3, dampingFraction: 0.5),
                            value: vm.countdownNumber
                        )
                        .padding(.top, 20)
                }
            }
        }
        .onAppear {
            vm.startCountdown()
        }
        .onChange(of: vm.phase) { oldPhase, newPhase in
            if newPhase == .playing {
                startGame = true
            }
        }
        .navigationDestination(isPresented: $startGame) {
            GameView(vm: vm)
        }
        .navigationBarBackButtonHidden(true)
    }
}
