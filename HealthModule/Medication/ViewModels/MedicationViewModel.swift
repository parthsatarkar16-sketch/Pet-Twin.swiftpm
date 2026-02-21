import Foundation
import SwiftUI

@MainActor
@Observable
class MedicationViewModel {
    var medications: [Medication] = []
    var medicationLogs: [MedicationLog] = []
    
    init() {
        self.medications = LocalStorageService.shared.loadMedications()
        self.medicationLogs = LocalStorageService.shared.loadLogs()
        NotificationService.shared.requestAuthorization()
    }
    
    func addMedication(_ medication: Medication) {
        medications.append(medication)
        saveMedications()
        scheduleNotifications(for: medication)
    }
    
    func updateMedication(_ medication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index] = medication
            saveMedications()
            // Re-schedule notifications if needed
            cancelNotifications(for: medication)
            scheduleNotifications(for: medication)
        }
    }
    
    func deleteMedication(_ medication: Medication) {
        medications.removeAll(where: { $0.id == medication.id })
        saveMedications()
        cancelNotifications(for: medication)
    }
    
    func markDoseAsTaken(medication: Medication, dose: DoseSchedule) {
        withAnimation(.spring()) {
            guard let medIndex = medications.firstIndex(where: { $0.id == medication.id }),
                  let doseIndex = medications[medIndex].schedules.firstIndex(where: { $0.id == dose.id }) else { return }
            
            medications[medIndex].schedules[doseIndex].status = .taken
            medications[medIndex].schedules[doseIndex].takenAt = Date()
            
            let log = MedicationLog(
                medicationId: medication.id,
                medicationName: medication.name,
                doseScheduled: dose.time,
                doseTaken: Date(),
                doseAmount: dose.dose,
                status: .taken
            )
            medicationLogs.append(log)
            
            saveMedications()
            saveLogs()
        }
    }
    
    // Helper to generate doses for the next 7 days based on frequency
    func generateSchedules(for name: String, type: MedicationType, doseAmount: String, frequency: FrequencyType, startTime: Date) -> [DoseSchedule] {
        var schedules: [DoseSchedule] = []
        let calendar = Calendar.current
        
        // Generate for the next 7 days
        for dayOffset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startTime) {
                // For daily, we add it every day
                if frequency == .daily {
                    schedules.append(DoseSchedule(time: date, dose: doseAmount))
                } 
                // For other frequencies, you'd add logic here (e.g. weekly)
                else if frequency == .weekly && dayOffset == 0 {
                    schedules.append(DoseSchedule(time: date, dose: doseAmount))
                }
                else if dayOffset == 0 { // Default to at least one dose for other types for now
                    schedules.append(DoseSchedule(time: date, dose: doseAmount))
                }
            }
        }
        return schedules
    }
    
    private func saveMedications() {
        LocalStorageService.shared.saveMedications(medications)
    }
    
    private func saveLogs() {
        LocalStorageService.shared.saveLogs(medicationLogs)
    }
    
    private func scheduleNotifications(for medication: Medication) {
        for dose in medication.schedules where dose.status == .scheduled && dose.time > Date() {
            NotificationService.shared.scheduleMedicationReminder(for: medication, dose: dose)
        }
    }
    
    private func cancelNotifications(for medication: Medication) {
        for dose in medication.schedules {
            NotificationService.shared.cancelReminder(for: dose.id)
        }
    }
    
    // Filtering helper
    func todayMedications() -> [(Medication, DoseSchedule)] {
        let calendar = Calendar.current
        var todayDoses: [(Medication, DoseSchedule)] = []
        
        for med in medications {
            for dose in med.schedules {
                if calendar.isDateInToday(dose.time) {
                    todayDoses.append((med, dose))
                }
            }
        }
        return todayDoses.sorted { $0.1.time < $1.1.time }
    }
}
