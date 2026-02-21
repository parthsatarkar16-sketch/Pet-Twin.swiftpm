import Foundation
import SwiftUI

@MainActor
@Observable
class SymptomViewModel {
    var symptomLogs: [SymptomLog] = []
    
    init() {
        self.symptomLogs = LocalStorageService.shared.loadSymptoms()
    }
    
    func addSymptomLog(_ log: SymptomLog) {
        symptomLogs.append(log)
        saveData()
    }
    
    func clearAllSymptoms() {
        symptomLogs.removeAll()
        saveData()
    }
    
    private func saveData() {
        LocalStorageService.shared.saveSymptoms(symptomLogs)
    }
}
