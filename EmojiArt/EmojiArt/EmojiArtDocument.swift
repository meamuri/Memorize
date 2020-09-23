//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Roman Dronov on 23.09.2020.
//

import SwiftUI

class EmojiArtDocument : ObservableObject {
    static let pallete: String = "🎾🍉🐭🤠🚤📸✅🇮🇪"
    
    @Published private var emojiArt: EmojiArt = EmojiArt()
    
    @Published private(set) var backgroundImage: UIImage?
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: - intent(s)
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let emojiIndex = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[emojiIndex].x += Int(offset.width)
            emojiArt.emojis[emojiIndex].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let emojiIndex = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[emojiIndex].size = Int((CGFloat(emojiArt.emojis[emojiIndex].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    func setBackgroundUrl(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }                        
                    }
                }
            }
        }
    }
}


extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: self.x, y: self.y)}
}
