import Foundation

enum SymptomCategory: String, Codable, CaseIterable {
    case digestive = "Digestive"
    case respiratory = "Respiratory"
    case skin = "Skin / Coat"
    case behavior = "Behavioral"
    case mobility = "Mobility"
    case other = "Other"
}

struct SymptomLog: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var symptomName: String
    var category: SymptomCategory
    var severity: Int // 1-10
    var notes: String?
}
