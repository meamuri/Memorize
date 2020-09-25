//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Roman Dronov on 26.09.2020.
//

import SwiftUI


struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}
