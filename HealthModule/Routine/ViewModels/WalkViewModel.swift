import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
class WalkViewModel {
    var modelContext: ModelContext
    var records: [WalkRecord] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchRecords()
    }
    
    func fetchRecords() {
        let descriptor = FetchDescriptor<WalkRecord>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        do {
            records = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func addRecord(petId: UUID, title: String, distance: Double, steps: Int, duration: Int, calories: Int, date: Date) {
        let record = WalkRecord(petId: petId, title: title, distance: distance, steps: steps, duration: duration, calories: calories, date: date)
        modelContext.insert(record)
        try? modelContext.save()
        fetchRecords()
    }
    
    func deleteRecord(_ record: WalkRecord) {
        modelContext.delete(record)
        try? modelContext.save()
        fetchRecords()
    }
    
    var totalDistanceToday: Double {
        let calendar = Calendar.current
        return records.filter { calendar.isDateInToday($0.date) }.reduce(0) { $0 + $1.distance }
    }
    
    var totalStepsToday: Int {
        let calendar = Calendar.current
        return records.filter { calendar.isDateInToday($0.date) }.reduce(0) { $0 + $1.steps }
    }
}
