//
//  Item.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
