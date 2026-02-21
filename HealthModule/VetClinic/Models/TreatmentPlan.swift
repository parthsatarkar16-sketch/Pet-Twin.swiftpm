import Foundation

struct TreatmentPlan: Identifiable, Codable {
    var id = UUID()
    var title: String
    var startDate: Date
    var endDate: Date?
    var instructions: String
    var medicationIds: [UUID] = []
    var isCompleted: Bool = false
}
