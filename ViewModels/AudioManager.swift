//
//  AudioManager.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 27/2/26.
//
import AVFoundation
import SwiftUI

class AudioManager {
    static let shared = AudioManager()

    private var bgmPlayer: AVAudioPlayer?

    private var flipPlayer: AVAudioPlayer?
    private var slapPlayer: AVAudioPlayer?

    private var winPlayer: AVAudioPlayer?
    private var losePlayer: AVAudioPlayer?

    init() {
        UserDefaults.standard.register(defaults: [
            "isMusicEnabled": true,
            "isSfxEnabled": true,
            "isHapticsEnabled": true,
        ])

        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category.")
        }

        if let flipURL = Bundle.main.url(
            forResource: "card-flips",
            withExtension: "mp3"
        ) {
            flipPlayer = try? AVAudioPlayer(contentsOf: flipURL)
            flipPlayer?.volume = 0.7
            flipPlayer?.prepareToPlay()
        } else {
            print("Could not find card-flips.mp3")
        }

        if let slapURL = Bundle.main.url(
            forResource: "slap",
            withExtension: "mp3"
        ) {
            slapPlayer = try? AVAudioPlayer(contentsOf: slapURL)
            slapPlayer?.volume = 1.0
            slapPlayer?.prepareToPlay()
        } else {
            print("Could not find slap.mp3")
        }
        if let winURL = Bundle.main.url(
            forResource: "winner-sound",
            withExtension: "mp3"
        ) {
            winPlayer = try? AVAudioPlayer(contentsOf: winURL)
            winPlayer?.volume = 0.8
            winPlayer?.prepareToPlay()
        }

        if let loseURL = Bundle.main.url(
            forResource: "loser-sound",
            withExtension: "mp3"
        ) {
            losePlayer = try? AVAudioPlayer(contentsOf: loseURL)
            losePlayer?.volume = 0.8
            losePlayer?.prepareToPlay()
        }
    }

    func playBGM(filename: String, volume: Float = 0.3) {
        guard UserDefaults.standard.bool(forKey: "isMusicEnabled") else {
            bgmPlayer?.stop()
            return
        }

        if let currentURL = bgmPlayer?.url,
            currentURL.lastPathComponent == "\(filename).mp3",
            bgmPlayer?.isPlaying == true
        {
            return
        }

        guard
            let url = Bundle.main.url(
                forResource: filename,
                withExtension: "mp3"
            )
        else {
            print("Could not find \(filename).mp3")
            return
        }

        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1
            bgmPlayer?.volume = volume
            bgmPlayer?.play()
        } catch {
            print("Failed to play BGM: \(filename)")
        }
    }

    func stopBGM() {
        bgmPlayer?.stop()
    }

    func resumeBGM() {
        bgmPlayer?.play()
    }

    func playCardFlip() {
        guard UserDefaults.standard.bool(forKey: "isSfxEnabled") else { return }
        flipPlayer?.currentTime = 0
        flipPlayer?.play()
    }

    func playSlapSound() {
        guard UserDefaults.standard.bool(forKey: "isSfxEnabled") else { return }
        slapPlayer?.currentTime = 0
        slapPlayer?.play()
    }

    func playWinSound() {
        guard UserDefaults.standard.bool(forKey: "isSfxEnabled") else { return }
        winPlayer?.currentTime = 0
        winPlayer?.play()
    }

    func playLoseSound() {
        guard UserDefaults.standard.bool(forKey: "isSfxEnabled") else { return }
        losePlayer?.currentTime = 0
        losePlayer?.play()
    }
}
