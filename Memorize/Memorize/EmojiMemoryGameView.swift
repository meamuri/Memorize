//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Rom Dr on 01.09.2020.
//  Copyright © 2020 Roman Dronov. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.75)) {
                        self.viewModel.choose(card: card)
                    }
                }
                    .padding(5)
            }
                .padding()
                .foregroundColor(Color.orange)
                .font(Font.largeTitle)
            Button(action: {
                withAnimation(.easeInOut) {
                    viewModel.resetGame()
                }
            }, label: {
                Text("New Game")
            })  
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        GeometryReader { geometry in
             self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startAnumatingBonusRemaining() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0 - 90),
                            endAngle: Angle(degrees: -animatedBonusRemaining * 360 - 90),
                            clockwise: true)
                                .onAppear {
                                    startAnumatingBonusRemaining()
                                }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90),
                            endAngle: Angle(degrees: -card.bonusRemaining * 360 - 90),
                            clockwise: true)
                    }
                }.padding(5).opacity(0.4)
                
                Text(self.card.content)
                    .font(Font.system(size: self.fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)            
        }
    }
    
    // MARK: - Drawing Constants
 
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

struct EmojuMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        let card = game.cards[3]
        game.choose(card: card)
        return EmojiMemoryGameView(viewModel: game)
    }
}
