import Foundation
import SwiftData

@Model
final class WalkRecord {
    @Attribute(.unique) var id: UUID
    var petId: UUID
    var title: String
    var distance: Double // KM
    var steps: Int
    var duration: Int // Minutes
    var calories: Int
    var date: Date
    
    init(petId: UUID, title: String, distance: Double, steps: Int, duration: Int, calories: Int, date: Date) {
        self.id = UUID()
        self.petId = petId
        self.title = title
        self.distance = distance
        self.steps = steps
        self.duration = duration
        self.calories = calories
        self.date = date
    }
}
