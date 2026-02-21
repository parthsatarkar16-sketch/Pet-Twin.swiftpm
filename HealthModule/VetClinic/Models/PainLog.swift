import Foundation

struct PainLog: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var level: Int // 1-10
    var location: String?
    var notes: String?
}
