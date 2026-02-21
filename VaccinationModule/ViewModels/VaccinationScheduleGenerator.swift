import Foundation

final class VaccinationScheduleGenerator {
    static func generateInitialSchedule(petType: String, birthDate: Date, petId: UUID) -> [VaccinationRecord] {
        var records: [VaccinationRecord] = []
        
        let vaccines = petType == "Dog" ? VaccinationConstants.dogCoreVaccines : VaccinationConstants.catCoreVaccines
        
        for vaccine in vaccines {
            // Puppies/Kittens starting at 8 weeks
            let initialDate = Calendar.current.date(byAdding: .weekOfYear, value: 8, to: birthDate) ?? Date()
            let nextDue = Calendar.current.date(byAdding: .month, value: vaccine.boosterMonths, to: initialDate) ?? Date()
            
            let record = VaccinationRecord(
                petId: petId,
                vaccineName: vaccine.name,
                petType: petType,
                dateGiven: initialDate,
                nextDueDate: nextDue,
                boosterInterval: vaccine.boosterMonths,
                notes: "Auto-generated initial schedule"
            )
            records.append(record)
        }
        
        return records
    }
    
    static func calculateNextBooster(from lastDate: Date, intervalMonths: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: intervalMonths, to: lastDate) ?? lastDate
    }
}
