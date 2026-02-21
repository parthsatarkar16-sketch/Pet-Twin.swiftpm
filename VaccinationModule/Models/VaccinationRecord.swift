import Foundation
import SwiftData

@Model
final class VaccinationRecord {
    @Attribute(.unique) var id: UUID
    var petId: UUID
    var vaccineName: String
    var petType: String // "Dog" or "Cat"
    var dateGiven: Date
    var nextDueDate: Date
    var boosterInterval: Int // in months
    var notes: String
    var statusString: String
    
    init(
        id: UUID = UUID(),
        petId: UUID,
        vaccineName: String,
        petType: String,
        dateGiven: Date,
        nextDueDate: Date,
        boosterInterval: Int,
        notes: String = ""
    ) {
        self.id = id
        self.petId = petId
        self.vaccineName = vaccineName
        self.petType = petType
        self.dateGiven = dateGiven
        self.nextDueDate = nextDueDate
        self.boosterInterval = boosterInterval
        self.notes = notes
        self.statusString = "Up to Date" // Initial calculation
    }
    
    var status: VaccinationStatus {
        let now = Date()
        if now > nextDueDate {
            return .overdue
        } else if Calendar.current.date(byAdding: .month, value: -1, to: nextDueDate)! <= now {
            return .dueSoon
        } else {
            return .upToDate
        }
    }
}

enum VaccinationStatus: String, Codable, CaseIterable {
    case upToDate = "Up to Date"
    case dueSoon = "Due Soon"
    case overdue = "Overdue"
}
