import Foundation

struct DoseSchedule: Codable, Identifiable {
    var id = UUID()
    var time: Date
    var dose: String // e.g., "1 tablet", "5ml"
    var status: DoseStatus
    var takenAt: Date?
    
    init(time: Date, dose: String, status: DoseStatus = .scheduled) {
        self.time = time
        self.dose = dose
        self.status = status
    }
}
