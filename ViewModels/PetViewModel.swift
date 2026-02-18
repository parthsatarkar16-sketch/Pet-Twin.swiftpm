//
//  PetViewModel.swift
//  GuardianTwin
//

import Foundation
import SwiftUI

class PetViewModel: ObservableObject {
    @Published var petProfile: PetProfile?
    @Published var healthMetrics: HealthMetrics = HealthMetrics()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let riskCalculator = OfflineRiskCalculator.shared
    
    init() {
        loadPetProfile()
    }
    
    func savePetProfile(name: String, breed: String, age: Int, weight: Double, activityLevel: Int, dailyCalories: Int) {
        let profile = PetProfile(
            name: name,
            breed: breed,
            age: age,
            weight: weight,
            activityLevel: activityLevel,
            dailyCalories: dailyCalories
        )
        
        self.petProfile = profile
        saveToUserDefaults(profile)
    }
    
    func updateHealthMetrics(heartRate: Int?, temperature: Double?, activityMinutes: Int?, sleepHours: Double?) {
        healthMetrics = HealthMetrics(
            heartRate: heartRate,
            temperature: temperature,
            activityMinutes: activityMinutes,
            sleepHours: sleepHours
        )
    }
    
    func getCurrentRiskLevel() -> Double {
        guard let profile = petProfile else { return 0.0 }
        return riskCalculator.calculateRisk(for: profile)
    }
    
    func getCurrentHealthScore() -> Int {
        guard let profile = petProfile else { return 100 }
        return profile.healthScore
    }
    
    private func saveToUserDefaults(_ profile: PetProfile) {
        do {
            let data = try JSONEncoder().encode(profile)
            UserDefaults.standard.set(data, forKey: "PetProfile")
        } catch {
            print("Failed to save pet profile: \(error)")
            errorMessage = "Could not save pet profile"
        }
    }
    
    private func loadPetProfile() {
        guard let data = UserDefaults.standard.data(forKey: "PetProfile") else {
            return
        }
        
        do {
            let profile = try JSONDecoder().decode(PetProfile.self, from: data)
            petProfile = profile
        } catch {
            print("Failed to load pet profile: \(error)")
            errorMessage = "Could not load pet profile"
        }
    }
    
    func calculateRiskForSimulation(months: Int) -> SimulationResult {
        guard let profile = petProfile else {
            return SimulationResult(
                projectedWeight: 0,
                riskPercentage: 0,
                healthScore: 100
            )
        }
        
        let projectedWeight = riskCalculator.calculateProjectedWeight(
            currentWeight: profile.weight,
            months: months,
            activityLevel: profile.activityLevel,
            calories: profile.dailyCalories
        )
        
        // Calculate risk based on projected weight and other factors
        var riskPercentage = getCurrentRiskLevel()
        
        // Adjust risk based on projected weight change
        let weightChange = abs(projectedWeight - profile.weight)
        if weightChange > 5 { // Significant weight change increases risk
            riskPercentage += (weightChange / 20.0) // Scale weight change impact
        }
        
        // Cap risk at 100%
        riskPercentage = min(riskPercentage, 1.0)
        
        let healthScore = Int((1.0 - riskPercentage) * 100)
        
        // Generate recommendations based on simulation
        let recommendations = riskCalculator.generateRecommendations(for: profile, riskLevel: riskPercentage)
        
        return SimulationResult(
            projectedWeight: projectedWeight,
            riskPercentage: riskPercentage,
            healthScore: healthScore,
            recommendations: recommendations
        )
    }
    
    func getRecommendations() -> [String] {
        guard let profile = petProfile else { return [] }
        return riskCalculator.generateRecommendations(for: profile, riskLevel: getCurrentRiskLevel())
    }
}