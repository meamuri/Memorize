//
//  Array+Only.swift
//  Memorize
//
//  Created by Roman Dronov on 10.09.2020.
//  Copyright © 2020 Roman Dronov. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
