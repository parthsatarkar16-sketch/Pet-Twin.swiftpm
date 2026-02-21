import Foundation
import UserNotifications

@MainActor
final class NotificationService {
    static let shared = NotificationService()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleMedicationReminder(for medication: Medication, dose: DoseSchedule) {
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "It's time for \(medication.name) (\(dose.dose))"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dose.time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: dose.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelReminder(for doseId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [doseId.uuidString])
    }
    
    func scheduleVaccinationReminder(for record: VaccinationRecord) {
        let content = UNMutableNotificationContent()
        content.title = "Vaccination Reminder 💉"
        content.body = "\(record.vaccineName) is due soon for your pet."
        content.sound = .default
        
        let reminderDate = Calendar.current.date(byAdding: .day, value: -7, to: record.nextDueDate) ?? record.nextDueDate
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: record.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
