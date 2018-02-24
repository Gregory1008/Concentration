//
//  ViewController.swift
//  Concentration
//
//  Created by Roland Herzfeld on 02.02.18.
//  Copyright © 2018 Roland Herzfeld. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)

    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet { updateViewFromModel() }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        game.chooseCard(at: cardButtons.index(of: sender)!)
        updateViewFromModel()
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let card = game.cards[index]
            let button = cardButtons[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        flipCountLabel.text = String(game.flipCount)
    }
    
    var emojiChoises = "🎃👻😱😈🦇🍬🍭🍎🙀".map {String($0)}
    
    private var emoji = [Int:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card.hashValue] == nil, !emojiChoises.isEmpty {
            emoji[card.hashValue] = emojiChoises.remove(at: emojiChoises.count.arc4random)
        }
        return emoji[card.hashValue] ?? "?"
    }
    
    @IBAction func newGame() {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updateViewFromModel()
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
