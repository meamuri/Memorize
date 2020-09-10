//
//  GridLayout.swift
//  Memorize
//
//  Created by Roman Dronov on 10.09.2020.
//  Copyright © 2020 Roman Dronov. All rights reserved.
//

import SwiftUI

struct GridLayout {
    var size: CGSize
    var rowCount: Int = 0
    var columnCount: Int = 0
    
    init(itemCount: Int, nearAspectRatio desiredAscpectRatio: Double = 1, in size: CGSize) {
        self.size = size
        self.columnCount = itemCount
        self.rowCount = 1
    }
    
    var itemSize: CGSize {
        return CGSize(width: self.itemWidth - 10, height: size.height)
    }
    
    func location(ofItemAt index: Int) -> CGPoint {
        return CGPoint(x: CGFloat(index) * itemWidth, y: size.height / 2.0)
    }
    
    private var itemWidth: CGFloat { size.width / CGFloat(columnCount) }
}
