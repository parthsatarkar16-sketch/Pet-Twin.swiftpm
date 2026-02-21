import Foundation

struct VetVisit: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var clinicName: String
    var veterinarianName: String
    var reasonForVisit: String
    var diagnosis: String?
    var notes: String?
    var followUpDate: Date?
}
