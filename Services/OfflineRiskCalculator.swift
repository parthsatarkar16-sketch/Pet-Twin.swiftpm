//
//  OfflineRiskCalculator.swift
//  GuardianTwin
//

import Foundation

class OfflineRiskCalculator {
    
    nonisolated(unsafe) static let shared = OfflineRiskCalculator()
    
    private init() {}
    
    func calculateRisk(for petProfile: PetProfile) -> Double {
        var risk = 0.0
        
        // Age factor
        if petProfile.age > 12 {
            risk += 0.3
        } else if petProfile.age > 8 {
            risk += 0.2
        } else if petProfile.age > 5 {
            risk += 0.1
        }
        
        // Weight factor
        if petProfile.weight > 50 {
            risk += 0.25
        } else if petProfile.weight > 30 {
            risk += 0.15
        } else if petProfile.weight > 15 {
            risk += 0.05
        }
        
        // Activity level factor
        if petProfile.activityLevel < 2 {
            risk += 0.3
        } else if petProfile.activityLevel < 3 {
            risk += 0.15
        }
        
        // Breed factor (simplified - some breeds are prone to health issues)
        let highRiskBreeds = ["Bulldog", "Pug", "Great Dane", "Chihuahua", "Rottweiler"]
        if highRiskBreeds.contains(where: { petProfile.breed.localizedCaseInsensitiveContains($0) }) {
            risk += 0.1
        }
        
        // Cap the risk at 100%
        return min(risk, 1.0)
    }
    
    func calculateProjectedWeight(currentWeight: Double, months: Int, activityLevel: Int, calories: Int) -> Double {
        // Simplified weight projection algorithm
        var weightChangePerMonth = 0.0
        
        // Activity level affects metabolism
        let activityFactor = Double(activityLevel) / 3.0 // Normalize to 1-5 scale, center at 3
        
        // Calorie intake affects weight gain/loss
        let calorieFactor = Double(calories) / 500.0 // Normalize against average calorie needs
        
        // Base change: positive for low activity/high calories, negative for high activity/low calories
        if activityLevel < 3 && calories > 400 {
            weightChangePerMonth = 0.5 * activityFactor * calorieFactor
        } else if activityLevel > 3 && calories < 300 {
            weightChangePerMonth = -0.3 * activityFactor * calorieFactor
        } else {
            weightChangePerMonth = 0.1 * (activityFactor - calorieFactor) // Small adjustment
        }
        
        return currentWeight + (weightChangePerMonth * Double(months))
    }
    
    func calculateEnvironmentalRisk(temperature: Double, humidity: Double) -> Double {
        var risk = 0.0
        
        // Temperature risk (pets are comfortable between 18-24°C)
        if temperature > 35 {
            risk += 0.4 // High heat risk
        } else if temperature > 30 {
            risk += 0.2 // Moderate heat risk
        } else if temperature < 5 {
            risk += 0.15 // Cold risk
        }
        
        // Humidity risk (comfortable range: 30-70%)
        if humidity > 80 {
            risk += 0.15 // High humidity risk
        } else if humidity < 20 {
            risk += 0.1 // Low humidity risk
        }
        
        return min(risk, 1.0)
    }
    
    func generateRecommendations(for petProfile: PetProfile, riskLevel: Double) -> [String] {
        var recommendations: [String] = []
        
        if riskLevel > 0.6 {
            recommendations.append("Schedule a veterinary checkup soon")
            recommendations.append("Monitor eating and sleeping patterns closely")
        }
        
        if petProfile.activityLevel < 3 {
            recommendations.append("Increase daily exercise to improve health")
        }
        
        if petProfile.weight > 30 {
            recommendations.append("Consider portion control and healthy diet")
        }
        
        if petProfile.age > 7 {
            recommendations.append("Regular senior pet health screenings recommended")
        }
        
        if petProfile.dailyCalories > 600 {
            recommendations.append("Review daily caloric intake with vet")
        }
        
        return recommendations
    }
}
