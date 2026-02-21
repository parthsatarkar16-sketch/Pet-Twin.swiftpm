import Foundation
import SwiftData

@Model
final class FeedingRecord {
    @Attribute(.unique) var id: UUID
    var petId: UUID
    var mealType: String // "Morning", "Lunch", "Dinner", "Snack"
    var amount: String // e.g. "200g"
    var foodName: String
    var time: Date
    var isCompleted: Bool
    
    init(petId: UUID, mealType: String, amount: String, foodName: String, time: Date, isCompleted: Bool = true) {
        self.id = UUID()
        self.petId = petId
        self.mealType = mealType
        self.amount = amount
        self.foodName = foodName
        self.time = time
        self.isCompleted = isCompleted
    }
}
