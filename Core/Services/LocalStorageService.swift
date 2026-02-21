import Foundation
import SwiftUI

@MainActor
@Observable
final class LocalStorageService {
    static let shared = LocalStorageService()
    
    var allPets: [Pet] = [] {
        didSet {
            saveAllPets()
        }
    }
    
    var currentPetId: UUID? {
        didSet {
            UserDefaults.standard.set(currentPetId?.uuidString, forKey: currentPetIdKey)
        }
    }
    
    var currentPet: Pet? {
        allPets.first(where: { $0.id == currentPetId })
    }
    
    private let allPetsKey = "saved_all_pets"
    private let currentPetIdKey = "current_pet_id"
    private let medicationsKey = "saved_medications"
    private let logsKey = "medication_logs"
    private let symptomsKey = "symptom_logs"
    private let visitsKey = "vet_visits"
    private let weightsKey = "weight_records"
    
    init() {
        loadData()
    }
    
    // MARK: - Pet Management
    func addPet(_ pet: Pet) {
        allPets.append(pet)
        currentPetId = pet.id
    }
    
    func switchPet(to id: UUID) {
        currentPetId = id
    }
    
    private func saveAllPets() {
        if let encoded = try? JSONEncoder().encode(allPets) {
            UserDefaults.standard.set(encoded, forKey: allPetsKey)
        }
    }
    
    private func loadData() {
        // Load all pets
        if let data = UserDefaults.standard.data(forKey: allPetsKey),
           let decoded = try? JSONDecoder().decode([Pet].self, from: data) {
            allPets = decoded
        }
        
        // Load legacy pet if exists and convert to allPets if empty
        if allPets.isEmpty {
            if let data = UserDefaults.standard.data(forKey: "saved_pet_profile"),
               let decoded = try? JSONDecoder().decode(Pet.self, from: data) {
                allPets = [decoded]
                currentPetId = decoded.id
                return
            }
        }
        
        // Load current selection
        if let idString = UserDefaults.standard.string(forKey: currentPetIdKey),
           let uuid = UUID(uuidString: idString) {
            currentPetId = uuid
        } else if let firstPet = allPets.first {
            currentPetId = firstPet.id
        }
    }
    
    // MARK: - Medications
    func saveMedications(_ medications: [Medication]) {
        if let encoded = try? JSONEncoder().encode(medications) {
            UserDefaults.standard.set(encoded, forKey: medicationsKey)
        }
    }
    
    func loadMedications() -> [Medication] {
        guard let data = UserDefaults.standard.data(forKey: medicationsKey),
              let decoded = try? JSONDecoder().decode([Medication].self, from: data) else {
            return []
        }
        return decoded
    }
    
    // MARK: - Medication Logs
    func saveLogs(_ logs: [MedicationLog]) {
        if let encoded = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(encoded, forKey: logsKey)
        }
    }
    
    func loadLogs() -> [MedicationLog] {
        guard let data = UserDefaults.standard.data(forKey: logsKey),
              let decoded = try? JSONDecoder().decode([MedicationLog].self, from: data) else {
            return []
        }
        return decoded
    }
    
    // MARK: - Symptoms
    func saveSymptoms(_ symptoms: [SymptomLog]) {
        if let encoded = try? JSONEncoder().encode(symptoms) {
            UserDefaults.standard.set(encoded, forKey: symptomsKey)
        }
    }
    
    func loadSymptoms() -> [SymptomLog] {
        guard let data = UserDefaults.standard.data(forKey: symptomsKey),
              let decoded = try? JSONDecoder().decode([SymptomLog].self, from: data) else {
            return []
        }
        return decoded
    }
    
    // MARK: - Vet Visits
    func saveVisits(_ visits: [VetVisit]) {
        if let encoded = try? JSONEncoder().encode(visits) {
            UserDefaults.standard.set(encoded, forKey: visitsKey)
        }
    }
    
    func loadVisits() -> [VetVisit] {
        guard let data = UserDefaults.standard.data(forKey: visitsKey),
              let decoded = try? JSONDecoder().decode([VetVisit].self, from: data) else {
            return []
        }
        return decoded
    }
    
    // MARK: - Weight Records
    func saveWeightRecords(_ records: [WeightRecord]) {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: weightsKey)
        }
    }
    
    func loadWeightRecords() -> [WeightRecord] {
        guard let data = UserDefaults.standard.data(forKey: weightsKey),
              let decoded = try? JSONDecoder().decode([WeightRecord].self, from: data) else {
            return []
        }
        return decoded
    }
}
