//
//  MemoryGame.swift
//  Memorize
//
//  Created by Roman Dronov on 08.09.2020.
//  Copyright © 2020 Roman Dronov. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> {
    
    var cards: Array<Card>
    
    init(numberofPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberofPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
    }
    
    mutating func choose(card: Card) {
        let chosenIndex = index(of: card)
        self.cards[chosenIndex].isFacedUp = !self.cards[chosenIndex].isFacedUp
    }
    
    func index(of card: Card) -> Int {
        for index in 0..<cards.count {
            if self.cards[index].id == card.id {
                return index
            }
        }
        return -1 // TODO: bogus
    }
    
    struct Card: Identifiable {
        var isFacedUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
