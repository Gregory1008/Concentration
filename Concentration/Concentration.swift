//
//  Concentration.swift
//  Concentration
//
//  Created by Roland Herzfeld on 03.02.18.
//  Copyright © 2018 Roland Herzfeld. All rights reserved.
//

import Foundation

struct Concentration  {
    
    private(set) var cards = [Card]()
    
    private(set) var flipCount = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly ?? nil
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func chooseCard(at index: Int)  {
        if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
            flipCount += 1
            if cards[matchIndex] == cards[index] {
                cards[matchIndex].isMatched = true
                cards[index].isMatched = true
            }
            cards[index].isFaceUp = true
        } else if indexOfOneAndOnlyFaceUpCard == nil  {
            flipCount += 1
            indexOfOneAndOnlyFaceUpCard = index
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card,card]
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
