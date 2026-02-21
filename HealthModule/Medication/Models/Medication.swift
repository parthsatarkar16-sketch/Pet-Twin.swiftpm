import Foundation

struct Medication: Codable, Identifiable {
    var id = UUID()
    var name: String
    var type: MedicationType
    var dosage: String
    var frequency: FrequencyType
    var startDate: Date
    var endDate: Date?
    var notes: String?
    var schedules: [DoseSchedule]
    var isActive: Bool
    
    // Inventory management
    var remainingQuantity: Double?
    var totalQuantity: Double?
    var refillThreshold: Double?
    
    init(name: String, type: MedicationType, dosage: String, frequency: FrequencyType, startDate: Date = Date(), schedules: [DoseSchedule] = [], isActive: Bool = true) {
        self.name = name
        self.type = type
        self.dosage = dosage
        self.frequency = frequency
        self.startDate = startDate
        self.schedules = schedules
        self.isActive = isActive
    }
}
