//
//  SimulationResult.swift
//  GuardianTwin
//

import Foundation

struct SimulationResult: Codable {
    let simulationDate: Date
    var projectedWeight: Double
    var riskPercentage: Double
    var healthScore: Int
    var environmentalRisk: Double
    var recommendations: [String]
    
    init(simulationDate: Date = Date(),
         projectedWeight: Double,
         riskPercentage: Double,
         healthScore: Int,
         environmentalRisk: Double = 0.0,
         recommendations: [String] = []) {
        self.simulationDate = simulationDate
        self.projectedWeight = projectedWeight
        self.riskPercentage = riskPercentage
        self.healthScore = healthScore
        self.environmentalRisk = environmentalRisk
        self.recommendations = recommendations
    }
}