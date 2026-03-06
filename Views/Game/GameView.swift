//
//  GameView.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 15/2/26.
//
import SwiftUI

struct GameView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GameBackground()

            if vm.phase == .countdown {
                CountdownView(vm: vm)
            } else if vm.phase == .playing {
                PlayView(vm: vm)
            } else if vm.phase == .result {
                ResultView(vm: vm)
            }
        }
        .onDisappear { vm.cleanup() }
        .navigationBarBackButtonHidden(true)
    }
}
