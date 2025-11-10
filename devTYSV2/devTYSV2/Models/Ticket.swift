//tickets

import Foundation
import SwiftUI

struct Ticket: Identifiable, Codable {
    var id = UUID()
    var eventName: String
    var date: String
    var seat: String
    var price: Double
}

