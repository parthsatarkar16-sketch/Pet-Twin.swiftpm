import Foundation

struct Vaccination: Codable, Identifiable {
    var id = UUID()
    var name: String
    var dateAdministered: Date
    var nextDueDate: Date?
    var veterinarian: String?
    var clinicName: String?
    var batchNumber: String?
    var notes: String?
}
