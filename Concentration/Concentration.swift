//
//  Concentration.swift
//  Concentration
//
//  Created by Richard Millet on 2/13/18.
//  Copyright © 2018 Richard Millet. All rights reserved.
//

import Foundation

class Concentration
{
    private(set) var cards = [Card]() // aka, Array<Card>()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        
        set(newValue) {
            assert(cards.indices.contains(newValue!), "New value for indexOfOneAndOnlyFaceUpCard was invalid.")
            for index in cards.indices {
                cards[index].isFaceUp = false
            }
            cards[newValue!].isFaceUp = true
        }
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index))
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[index].identifier == cards[matchIndex].identifier {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                }
                cards[index].isFaceUp = true;
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards.append(card) // adding a struct to array makes a copy
            cards.append(card) // adding makes another copy
            // Equivalent
            // cards += [card, card]
        }
        // TODO: Shuffle the cards
        shuffle()
    }
    
    func shuffle() {
        for i in cards.indices {
            cards.swapAt(i, cards.count.arc4random)
        }
    }
}
