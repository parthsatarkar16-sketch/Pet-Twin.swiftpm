//
//  SimulationViewModel.swift
//  GuardianTwin
//

import Foundation
import SwiftUI

class SimulationViewModel: ObservableObject {
    @Published var selectedMonths: Int = 6
    @Published var selectedTemperature: Double = 25.0
    @Published var simulationResult: SimulationResult?
    @Published var climateRisk: ClimateRiskAssessment?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let riskCalculator = OfflineRiskCalculator.shared
    private let climateAnalyzer = ClimateAnalyzer.shared
    private let petViewModel: PetViewModel
    
    init(petViewModel: PetViewModel) {
        self.petViewModel = petViewModel
        self.updateSimulation()
    }
    
    func updateSimulation() {
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Calculate pet-related simulation
            let petResult = self.petViewModel.calculateRiskForSimulation(months: self.selectedMonths)
            
            // Calculate climate risk if pet profile exists
            var climateRisk: ClimateRiskAssessment?
            if let petProfile = self.petViewModel.petProfile {
                climateRisk = self.climateAnalyzer.analyzeClimateRisk(
                    temperature: self.selectedTemperature,
                    humidity: 50, // Default humidity
                    breed: petProfile.breed
                )
            }
            
            DispatchQueue.main.async {
                self.simulationResult = petResult
                self.climateRisk = climateRisk
                self.isLoading = false
            }
        }
    }
    
    func getCombinedRiskPercentage() -> Double {
        guard let petResult = simulationResult else { return 0.0 }
        
        // Combine pet risk and climate risk if available
        let petRisk = petResult.riskPercentage
        let climateRiskValue = climateRisk?.overallRisk ?? 0.0
        
        // Calculate weighted average (pet risk is primary, climate is additional)
        let combinedRisk = (petRisk * 0.7) + (climateRiskValue * 0.3)
        
        return min(combinedRisk, 1.0) // Cap at 100%
    }
    
    func getCombinedHealthScore() -> Int {
        let combinedRisk = getCombinedRiskPercentage()
        return Int((1.0 - combinedRisk) * 100)
    }
    
    func getRecommendations() -> [String] {
        var allRecommendations: [String] = []
        
        // Add pet-specific recommendations
        if let petResult = simulationResult {
            allRecommendations.append(contentsOf: petResult.recommendations)
        }
        
        // Add climate-specific recommendations
        if let climateRisk = climateRisk {
            allRecommendations.append(contentsOf: climateRisk.recommendations)
        }
        
        // Add seasonal recommendations
        if let petProfile = petViewModel.petProfile {
            let month = Calendar.current.component(.month, from: Date())
            let seasonalRecs = climateAnalyzer.getSeasonalRecommendations(
                month: month,
                breed: petProfile.breed
            )
            allRecommendations.append(contentsOf: seasonalRecs)
        }
        
        // Remove duplicates
        return Array(Set(allRecommendations))
    }
}