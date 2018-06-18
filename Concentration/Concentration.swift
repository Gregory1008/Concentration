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

    private(set) var score = 0
    
    let startDate = Date()
    
    var timeIntervalToCompare = 10.0
    
    private var previoslySeenCardsIndices = [Int]()
    
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
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                flipCount += 1
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    for penalizingIndex in previoslySeenCardsIndices {
                        if cards[matchIndex].hashValue == cards[penalizingIndex].hashValue {
                            score -= 1
                        } else if index == penalizingIndex {
                            score -= 1
                        }
                    }
                }
                cards[index].isFaceUp = true
                previoslySeenCardsIndices.append(index)
                previoslySeenCardsIndices.append(matchIndex)
            } else if indexOfOneAndOnlyFaceUpCard == nil  {
                flipCount += 1
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        let timeIntervalSinceGameStart = Date().timeIntervalSince(startDate)
        while timeIntervalSinceGameStart > timeIntervalToCompare {
            score -= 1
            timeIntervalToCompare += 10.0
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card,card]
        }
        
        // Shuffle the cards
//
//                var tempCardArray = [Card]()
//                for _ in cards.indices {
//                    tempCardArray.append(cards.remove(at: cards.count.arc4random))
//                }
//                cards = tempCardArray
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

extension Array where Element: Equatable {
    var uniquified: [Element] {
        var elements = [Element]()
        forEach { if !elements.contains($0) { elements.append($0) } }
        return elements
    }
}
