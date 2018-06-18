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
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var newGameLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shuffleThemes()
        updateViewFromModel()
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
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : choosenTheme.buttonAndLabelBackgroundColor
            }
        }
        view.backgroundColor = choosenTheme.viewBackgroundColor
        let attributes: [NSAttributedStringKey : Any] = [
            .strokeColor : choosenTheme.buttonAndLabelBackgroundColor,
            .strokeWidth : 5.0
        ]
        
        flipCountLabel?.attributedText = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        scoreLabel?.attributedText = NSAttributedString(string: "Score: \(game.score)", attributes: attributes)
        newGameLabel?.setAttributedTitle(NSAttributedString(string: "New Game", attributes: attributes), for: .normal)
    }
    
    private var emojiChoisesArray:
        [(emojiChoises: [String], buttonAndLabelBackgroundColor: UIColor, viewBackgroundColor: UIColor)] =
        [  (["🎃","👻","😱","😈","🦇","🍬","🍭","🍎","🙀"],#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
           (["😂","😇","😍","😝","😎","😡","🤢","🤯","🤗"],#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)),
           (["🇮🇳","🏳️‍🌈","🇩🇪","🇬🇹","🇺🇸","🇷🇺","🇮🇹","🇯🇵","🇨🇺"],#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)),
           (["⚽️","🏹","⛳️","⛷","🎮","🎸","🏉","🎱","🏓"],#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    ]
    
    private lazy var choosenTheme = emojiChoisesArray[0]
    
    private func shuffleThemes() {
        choosenTheme = emojiChoisesArray[emojiChoisesArray.count.arc4random]
    }
    
    private var emoji = [Int:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card.hashValue] == nil, !(choosenTheme.emojiChoises.isEmpty) {
            emoji[card.hashValue] = choosenTheme.emojiChoises.remove(at: (choosenTheme.emojiChoises.count.arc4random))
        }
        return emoji[card.hashValue] ?? "?"
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        shuffleThemes()
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

