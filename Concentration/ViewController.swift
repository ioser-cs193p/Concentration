//
//  ViewController.swift
//  Concentration
//
//  Created by Richard Millet on 1/16/18.
//  Copyright © 2018 Richard Millet. All rights reserved.
//

import UIKit

/**
 Extend the Int "class" with an new var that returns a random number
 */
extension Int {
    var arc4random: Int {
        get {
            if self > 0 {
                return Int(arc4random_uniform(UInt32(self)))
            } else if self < 0 {
                return -Int(arc4random_uniform(UInt32(-self)))
            } else {
                return self
            }
        }
    }
}

class ViewController: UIViewController
{
    private var gameBeingPlay = false
    private var game: Concentration?
    private var emojiChoices: Array<String>?
    private var emojiThemes: Dictionary = [
        "0" : ["👻", "🎃", "😾", "🦇", "🍎", "😱", "😈", "🍭", "🍬"],
        "1" : ["🎱", "⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🏓"],
        "2" : ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒"]
    ]

    @IBAction func startNewGame() {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        emojiChoices = emojiThemes[String(emojiThemes.keys.count.arc4random)]
        updateViewFromModel()
        flipCount = 0
        gameBeingPlay = true
    }
    
    var numberOfPairsOfCards: Int {
        get {
            return (cardButtons.count + 1) / 2
        }
    }
    
    private(set) var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)";
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if !gameBeingPlay {
            startNewGame()
        }
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            //flipCard(withEmoji: emojiChoices[cardNumber], on: sender);
            game!.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game!.cards[index]
            if (card.isFaceUp) {
                button.setTitle(emojiForCard(card: card), for: UIControlState.normal)
                button.backgroundColor = UIColor.white
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? UIColor.clear : UIColor.orange
            }
        }
    }
    
    
    private var emoji = [Int:String]() // Dictionary<Int, String>()

    private func emojiForCard(card: Card) -> String {
        if emoji[card.identifier] == nil && emojiChoices!.count > 0 {
            emoji[card.identifier] = emojiChoices!.remove(at: emojiChoices!.count.arc4random)
        }
        
        return emoji[card.identifier] ?? "?" // If not nil return it, else return "?"
    }
}

