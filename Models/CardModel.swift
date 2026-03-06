//
//  CardModel.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 19/2/26.
//
import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let rank: Int
    let suit: Suit

    enum Suit: String, CaseIterable {
        case hearts = "hearts"
        case diamonds = "diamonds"
        case clubs = "clubs"
        case spades = "spades"
    }

    var displayString: String {
        switch rank {
        case 1: return "A"
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "\(rank)"
        }
    }

    var isRed: Bool {
        suit == .hearts || suit == .diamonds
    }

    var suitSymbol: String {
        switch suit {
        case .hearts: return "♥"
        case .diamonds: return "♦"
        case .clubs: return "♣"
        case .spades: return "♠"
        }
    }
}

func buildShuffledDeck() -> (playerHand: [Card], computerHand: [Card]) {
    var deck: [Card] = []
    for suit in Card.Suit.allCases {
        for rank in 1...13 {
            deck.append(Card(rank: rank, suit: suit))
        }
    }
    deck.shuffle()

    let playerHand = Array(deck[0..<26])
    let computerHand = Array(deck[26..<52])

    return (playerHand, computerHand)
}
