import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
class FeedingViewModel {
    var modelContext: ModelContext
    var records: [FeedingRecord] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchRecords()
    }
    
    func fetchRecords() {
        let descriptor = FetchDescriptor<FeedingRecord>(sortBy: [SortDescriptor(\.time, order: .reverse)])
        do {
            records = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func addRecord(petId: UUID, mealType: String, amount: String, foodName: String, time: Date) {
        let record = FeedingRecord(petId: petId, mealType: mealType, amount: amount, foodName: foodName, time: time)
        modelContext.insert(record)
        try? modelContext.save()
        fetchRecords()
    }
    
    func deleteRecord(_ record: FeedingRecord) {
        modelContext.delete(record)
        try? modelContext.save()
        fetchRecords()
    }
}
