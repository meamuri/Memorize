//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Roman Dronov on 23.09.2020.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        HStack {
            ForEach(EmojiArtDocument.pallete.map { String($0) }, id: \.self) { emoji in
                Text(emoji)
            }
        }
    }
}
