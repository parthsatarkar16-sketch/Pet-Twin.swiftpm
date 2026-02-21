import Foundation
import SwiftUI

@MainActor
@Observable
class VetClinicViewModel {
    var visits: [VetVisit] = []
    var weightRecords: [WeightRecord] = []
    var stabilityScores: [HealthStabilityScore] = []
    
    init() {
        loadData()
    }
    
    var stabilityScore: Double {
        let symptoms = LocalStorageService.shared.loadSymptoms()
        if symptoms.isEmpty { return 1.0 }
        
        let avgSeverity = symptoms.reduce(0.0) { $0 + Double($1.severity) } / Double(symptoms.count)
        // Score: 100% at 0 severity, 0% at 10 severity
        return max(0.0, 1.0 - (avgSeverity / 10.0))
    }
    
    func addVisit(_ visit: VetVisit) {
        visits.append(visit)
        saveVisits()
    }
    
    func addWeightRecord(_ record: WeightRecord) {
        weightRecords.append(record)
        saveWeightRecords()
    }
    
    func clearWeightRecords() {
        weightRecords.removeAll()
        saveWeightRecords()
    }
    
    private func saveVisits() {
        LocalStorageService.shared.saveVisits(visits)
    }
    
    private func saveWeightRecords() {
        LocalStorageService.shared.saveWeightRecords(weightRecords)
    }
    
    private func loadData() {
        self.visits = LocalStorageService.shared.loadVisits()
        self.weightRecords = LocalStorageService.shared.loadWeightRecords()
    }
}
