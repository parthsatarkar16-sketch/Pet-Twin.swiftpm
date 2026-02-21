import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
class VaccinationViewModel {
    var modelContext: ModelContext
    var records: [VaccinationRecord] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchRecords()
    }
    
    func fetchRecords() {
        let descriptor = FetchDescriptor<VaccinationRecord>(sortBy: [SortDescriptor(\.nextDueDate)])
        do {
            records = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func addRecord(name: String, petType: String, dateGiven: Date, boosterInterval: Int, notes: String, petId: UUID) {
        let nextDueDate = VaccinationScheduleGenerator.calculateNextBooster(from: dateGiven, intervalMonths: boosterInterval)
        let record = VaccinationRecord(
            petId: petId,
            vaccineName: name,
            petType: petType,
            dateGiven: dateGiven,
            nextDueDate: nextDueDate,
            boosterInterval: boosterInterval,
            notes: notes
        )
        
        modelContext.insert(record)
        try? modelContext.save()
        
        NotificationService.shared.scheduleVaccinationReminder(for: record)
        fetchRecords()
    }
    
    func deleteRecord(_ record: VaccinationRecord) {
        NotificationService.shared.cancelReminder(for: record.id)
        modelContext.delete(record)
        try? modelContext.save()
        fetchRecords()
    }
    
    func updateRecord(_ record: VaccinationRecord) {
        try? modelContext.save()
        NotificationService.shared.scheduleVaccinationReminder(for: record)
        fetchRecords()
    }
    
    func generateAutoSchedule(pet: Pet) {
        // Approximate birthdate calculation from age
        let birthDate = Calendar.current.date(byAdding: .year, value: -pet.age, to: Date()) ?? Date()
        let autoRecords = VaccinationScheduleGenerator.generateInitialSchedule(
            petType: pet.species,
            birthDate: birthDate,
            petId: pet.id
        )
        
        for record in autoRecords {
            modelContext.insert(record)
        }
        try? modelContext.save()
        fetchRecords()
    }
}
