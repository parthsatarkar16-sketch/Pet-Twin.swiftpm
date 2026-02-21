import Foundation

struct MedicationLog: Codable, Identifiable {
    var id = UUID()
    var medicationId: UUID
    var medicationName: String
    var doseScheduled: Date
    var doseTaken: Date
    var doseAmount: String
    var status: DoseStatus
    var notes: String?
}
