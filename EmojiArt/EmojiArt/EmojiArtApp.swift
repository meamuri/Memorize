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
        EmojiArtDocumentStore(named: "Emoji Art")        
    }
}
