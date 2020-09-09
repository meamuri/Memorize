//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Roman Dronov on 08.09.2020.
//  Copyright © 2020 Roman Dronov. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = createGame()
    
    static func createGame() -> MemoryGame<String> {
        let emojis = ["🎃", "👻", "🕷"]
        return MemoryGame(numberofPairsOfCards: emojis.count) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
