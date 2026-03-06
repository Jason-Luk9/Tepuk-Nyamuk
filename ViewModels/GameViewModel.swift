//
//  GameViewModel.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 18/2/26.
//
import AVFoundation
import Combine
import SwiftUI

enum GamePhase {
    case countdown
    case playing
    case result
}

enum SlapSource {
    case player
    case cpu
}

@MainActor
class GameViewModel: ObservableObject {
    enum Difficulty {
        case easy
        case medium
        case hard
    }

    // Display count on the screen
    var countLabel: String {
        switch currentCount {
        case 0: return "READY"
        case 1: return "Ace"
        case 11: return "Jack"
        case 12: return "Queen"
        case 13: return "King"
        default: return "\(currentCount)"
        }
    }

    @Published var phase: GamePhase = .countdown
    @Published var playerHand: [Card] = []
    @Published var computerHand: [Card] = []
    @Published var centerPile: [Card] = []
    @Published var feedbackMessage: String = ""
    @Published var winner: String = ""
    @Published var showCorrectFeedback: Bool = false
    @Published var showWrongFeedback: Bool = false
    @Published var slapAnimating: Bool = false
    @Published var isPaused: Bool = false
    @Published var goHomeView: Bool = false
    @Published var currentCount: Int = 0
    @Published var countdownNumber: Int = 3
    @Published var playerGain: Int? = nil
    @Published var cpuGain: Int? = nil
    @Published var difficulty: Difficulty = .easy
    @Published var lastSlapSource: SlapSource = .player

    private var gameTimer: Timer?
    private var canSlap: Bool = false
    private var isPlayerTurn: Bool = true
    private var speechSynth = AVSpeechSynthesizer()
    private var cpuFlipDelay: Double = 1.5
    private var cpuSlapDelay: Double = 1.0

    func startCountdown() {
        AudioManager.shared.stopBGM()
        phase = .countdown
        countdownNumber = 0

        Task {
            try? await Task.sleep(nanoseconds: 400_000_000)

            for i in stride(from: 3, through: 1, by: -1) {
                countdownNumber = i
                speak("\(i)")
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            countdownNumber = 0
            speak("Go!")
            try? await Task.sleep(nanoseconds: 600_000_000)
            startGame()
        }
    }

    func pauseGame() {
        isPaused = true
        gameTimer?.invalidate()
        speechSynth.stopSpeaking(at: .immediate)
    }

    func resumeGame() {
        isPaused = false

        if !isPlayerTurn {
            if centerPile.last?.rank == currentCount {
                scheduleCpuSlap()
            } else {
                scheduleCpuFlip()
            }
        }
    }

    private func startGame() {
        (playerHand, computerHand) = buildShuffledDeck()
        centerPile = []
        winner = ""
        currentCount = 0
        canSlap = false
        showCorrectFeedback = false
        showWrongFeedback = false
        slapAnimating = false
        isPlayerTurn = true
        isPaused = false
        feedbackMessage = ""
        AudioManager.shared.playBGM(filename: "game-music", volume: 0.08)
        switch difficulty {
        case .easy:
            cpuFlipDelay = 1.2
            cpuSlapDelay = Double.random(in: 1.1...1.5)
        case .medium:
            cpuFlipDelay = 0.8
            cpuSlapDelay = Double.random(in: 0.6...0.9)
        case .hard:
            cpuFlipDelay = 0.5
            cpuSlapDelay = Double.random(in: 0.3...0.5)
        }
        goHomeView = false
        phase = .playing
    }

    private func advanceCount() {
        if currentCount == 0 || currentCount == 13 {
            currentCount = 1
        } else {
            currentCount += 1
        }
    }

    func playerFlipped() {
        guard phase == .playing, isPlayerTurn, !isPaused else { return }

        if let card = playerHand.last {
            AudioManager.shared.playCardFlip()
            centerPile.append(card)
            playerHand.removeLast()
            advanceCount()
            speak(countLabel)
            canSlap = true
            isPlayerTurn = false
            checkForWinner()
            guard phase == .playing else { return }
            if centerPile.last?.rank == currentCount {
                scheduleCpuSlap()
            } else {
                scheduleCpuFlip()
            }
        }
    }

    func computerFlipped() {
        guard !isPlayerTurn else { return }

        if let card = computerHand.last {
            AudioManager.shared.playCardFlip()
            centerPile.append(card)
            computerHand.removeLast()
            advanceCount()
            speak(countLabel)
            canSlap = true
            isPlayerTurn = true
            checkForWinner()
            guard phase == .playing else { return }
            if centerPile.last?.rank == currentCount {
                scheduleCpuSlap()
            }
        }
    }

    private func scheduleCpuFlip() {
        gameTimer = Timer.scheduledTimer(
            withTimeInterval: cpuFlipDelay,
            repeats: false
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.computerFlipped()
            }
        }
    }

    func playerSlapped() {
        guard phase == .playing, canSlap else { return }
        playSlapEffects(source: .player)
        canSlap = false
        gameTimer?.invalidate()

        let isCorrect = centerPile.last?.rank == currentCount

        if isCorrect {
            handleCorrectSlap(by: .player)
        } else {
            handleWrongSlap(by: .player)
        }
    }

    func computerSlapped() {
        guard phase == .playing, canSlap else { return }
        playSlapEffects(source: .cpu)
        canSlap = false
        gameTimer?.invalidate()

        let isCorrect = centerPile.last?.rank == currentCount

        if isCorrect {
            handleCorrectSlap(by: .cpu)
        } else {
            handleWrongSlap(by: .cpu)
        }
    }

    private func scheduleCpuSlap() {
        gameTimer = Timer.scheduledTimer(
            withTimeInterval: cpuSlapDelay,
            repeats: false
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.computerSlapped()
            }
        }
    }

    private func handleCorrectSlap(by source: SlapSource) {
        let plusAmount = centerPile.count
        if source == .player {
            computerHand.insert(contentsOf: centerPile, at: 0)
            isPlayerTurn = false
            withAnimation { cpuGain = plusAmount }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation { self.cpuGain = nil }
            }
        } else {
            playerHand.insert(contentsOf: centerPile, at: 0)
            isPlayerTurn = true
            withAnimation { playerGain = plusAmount }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation { self.playerGain = nil }
            }
        }
        resetAfterSlap()
    }

    private func handleWrongSlap(by source: SlapSource) {
        let penaltyAmount = centerPile.count
        if source == .player {
            playerHand.insert(contentsOf: centerPile, at: 0)
            isPlayerTurn = true
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            withAnimation { playerGain = penaltyAmount }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation { self.playerGain = nil }
            }
        } else {
            computerHand.insert(contentsOf: centerPile, at: 0)
            isPlayerTurn = false
            withAnimation { cpuGain = penaltyAmount }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation { self.cpuGain = nil }
            }
        }
        resetAfterSlap()
    }

    private func resetAfterSlap() {
        centerPile = []
        currentCount = 0
        checkForWinner()
        canSlap = false

        if phase == .playing {
            if !isPlayerTurn {
                scheduleCpuFlip()
            }
        }
    }

    private func checkForWinner() {
        if playerHand.isEmpty {
            winner = "player"
            gameTimer?.invalidate()
            speechSynth.stopSpeaking(at: .immediate)
            phase = .result
            AudioManager.shared.stopBGM()
            AudioManager.shared.playWinSound()
            triggerFeedback("You Won!", isCorrect: true, haptic: .success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                if self.phase == .result {
                    AudioManager.shared.playBGM(
                        filename: "lobby-music",
                        volume: 0.4
                    )
                }
            }
        } else if computerHand.isEmpty {
            winner = "computer"
            gameTimer?.invalidate()
            speechSynth.stopSpeaking(at: .immediate)
            phase = .result
            AudioManager.shared.stopBGM()
            AudioManager.shared.playLoseSound()
            triggerFeedback("You Lost!", isCorrect: false, haptic: .error)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if self.phase == .result {
                    AudioManager.shared.playBGM(
                        filename: "lobby-music",
                        volume: 0.4
                    )
                }
            }
        }
    }

    private func speak(_ text: String) {
        guard phase != .result else { return }
        speechSynth.stopSpeaking(at: .immediate)
        let utt = AVSpeechUtterance(string: text)
        utt.rate = 0.52
        utt.pitchMultiplier = 1.1
        speechSynth.speak(utt)
    }

    private func triggerFeedback(
        _ message: String,
        isCorrect: Bool,
        haptic: UINotificationFeedbackGenerator.FeedbackType
    ) {
        feedbackMessage = message
        if isCorrect {
            withAnimation { showCorrectFeedback = true }
        } else {
            withAnimation { showWrongFeedback = true }
        }
        UINotificationFeedbackGenerator().notificationOccurred(haptic)
        Task {
            try? await Task.sleep(nanoseconds: 900_000_000)
            withAnimation {
                showCorrectFeedback = false
                showWrongFeedback = false
            }
        }
    }

    func cleanup() {
        gameTimer?.invalidate()
        speechSynth.stopSpeaking(at: .immediate)
    }

    private var audioPlayer: AVAudioPlayer?

    func playSlapEffects(source: SlapSource) {
        lastSlapSource = source

        let hapticsOn = UserDefaults.standard.bool(forKey: "isHapticsEnabled")

        AudioManager.shared.playSlapSound()

        if hapticsOn {
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
        }

        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
            slapAnimating = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                self.slapAnimating = false
            }
        }
    }
}
