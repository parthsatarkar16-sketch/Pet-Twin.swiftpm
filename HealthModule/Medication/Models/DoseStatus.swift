import Foundation
import SwiftUI

enum DoseStatus: String, Codable, CaseIterable {
    case scheduled = "Scheduled"
    case taken = "Taken"
    case skipped = "Skipped"
    case missed = "Missed"
    
    var color: Color {
        switch self {
        case .scheduled: return .blue
        case .taken: return .green
        case .skipped: return .orange
        case .missed: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .scheduled: return "clock"
        case .taken: return "checkmark.circle.fill"
        case .skipped: return "arrow.turn.up.right"
        case .missed: return "xmark.circle.fill"
        }
    }
}
