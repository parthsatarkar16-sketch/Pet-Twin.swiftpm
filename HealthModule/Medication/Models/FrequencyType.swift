import Foundation

enum FrequencyType: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case asNeeded = "As Needed"
    case specificDays = "Specific Days"
    
    var description: String {
        switch self {
        case .daily: return "Every day"
        case .weekly: return "Once a week"
        case .monthly: return "Once a month"
        case .asNeeded: return "When required"
        case .specificDays: return "Custom schedule"
        }
    }
}
