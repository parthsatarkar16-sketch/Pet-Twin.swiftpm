import Foundation

struct WeightRecord: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var weight: Double
    var unit: String // "kg" or "lbs"
}
