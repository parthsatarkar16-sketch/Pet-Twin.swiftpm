import SwiftUI
import SwiftData

@main
struct PetGuardApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: [VaccinationRecord.self, FeedingRecord.self, WalkRecord.self])
    }
}
