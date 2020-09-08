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
    
    func choose(card: Card) {
        print("card chosen: \(card)")
    }
    
    struct Card: Identifiable {
        var isFacedUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
