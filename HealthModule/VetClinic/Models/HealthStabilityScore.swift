import Foundation

struct HealthStabilityScore: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var score: Double // 0.0 - 1.0 or 0-100
    var trend: HealthTrend
    
    enum HealthTrend: String, Codable {
        case improving, stable, declining
    }
}
