//
//  Item.swift
//  devTYSV2
//
//  Created by RIcardo Bucio on 10/17/25.
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
