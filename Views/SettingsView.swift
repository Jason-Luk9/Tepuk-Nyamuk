//
//  SettingsView.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 18/2/26.
//
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isMusicEnabled") private var isMusicEnabled = true
    @AppStorage("isSfxEnabled") private var isSfxEnabled = true
    @AppStorage("isHapticsEnabled") private var isHapticsEnabled = true

    var body: some View {
        ZStack {
            GameBackground()

            VStack(spacing: 30) {
                Text("SETTINGS")
                    .font(.custom("PressStart2P-Regular", size: 30))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                VStack(spacing: 20) {
                    Toggle("MUSIC", isOn: $isMusicEnabled)
                        .onChange(of: isMusicEnabled) { oldValue, newValue in
                            if !newValue {
                                AudioManager.shared.stopBGM()
                            } else {
                                AudioManager.shared.resumeBGM()
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(15)

                    Toggle("SOUND EFFECTS", isOn: $isSfxEnabled)
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(15)

                    Toggle("VIBRATION", isOn: $isHapticsEnabled)
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(15)
                }
                .font(.custom("PressStart2P-Regular", size: 16))
                .foregroundColor(.white)
                .tint(.green)
                .padding(.horizontal, 30)

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
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
