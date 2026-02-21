import Foundation

struct VaccineType: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let boosterMonths: Int
    let targetSpecies: String // "Dog", "Cat", or "Both"
}

struct VaccinationConstants {
    static let dogCoreVaccines = [
        VaccineType(name: "DHPP", description: "Distemper, Hepatitis, Parainfluenza, Parvovirus", boosterMonths: 12, targetSpecies: "Dog"),
        VaccineType(name: "Rabies", description: "Mandatory rabies vaccination", boosterMonths: 36, targetSpecies: "Dog"),
        VaccineType(name: "Leptospirosis", description: "Bacterial infection prevention", boosterMonths: 12, targetSpecies: "Dog"),
        VaccineType(name: "Kennel Cough", description: "Bordetella prevention", boosterMonths: 6, targetSpecies: "Dog")
    ]
    
    static let catCoreVaccines = [
        VaccineType(name: "FVRCP", description: "Viral Rhinotracheitis, Calicivirus, Panleukopenia", boosterMonths: 12, targetSpecies: "Cat"),
        VaccineType(name: "Rabies", description: "Mandatory rabies vaccination", boosterMonths: 12, targetSpecies: "Cat"),
        VaccineType(name: "FeLV", description: "Feline Leukemia Virus", boosterMonths: 12, targetSpecies: "Cat")
    ]
}
