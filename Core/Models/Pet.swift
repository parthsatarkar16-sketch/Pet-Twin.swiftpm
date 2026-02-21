import SwiftUI

struct Pet: Codable, Identifiable {
    var id = UUID()
    var name: String
    var species: String // Dog / Cat
    var breed: String
    var age: Int
    var gender: String
    var personality: String
    var imageData: Data?
}
