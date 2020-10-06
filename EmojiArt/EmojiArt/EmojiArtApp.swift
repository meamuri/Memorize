//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Roman Dronov on 23.09.2020.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentChooser()
                .environmentObject(getStore())
        }
    }
    
    func getStore() -> EmojiArtDocumentStore {
//        return EmojiArtDocument(named: "Emoji Art")
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return EmojiArtDocumentStore(directory: url)
    }
}
