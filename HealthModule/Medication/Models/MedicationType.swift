import Foundation

enum MedicationType: String, Codable, CaseIterable {
    case tablet = "Tablet"
    case capsule = "Capsule"
    case liquid = "Liquid"
    case injection = "Injection"
    case topical = "Topical"
    case drops = "Drops"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .tablet: return "pills.fill"
        case .capsule: return "pills"
        case .liquid: return "drop.fill"
        case .injection: return "syringe.fill"
        case .topical: return "hand.raised.fill"
        case .drops: return "eyedropper.full"
        case .other: return "questionmark.circle.fill"
        }
    }
}
