//
//  ClimateAnalyzer.swift
//  GuardianTwin
//

import Foundation

class ClimateAnalyzer {
    
    nonisolated(unsafe) static let shared = ClimateAnalyzer()
    
    private init() {}
    
    func analyzeClimateRisk(temperature: Double, humidity: Double, breed: String) -> ClimateRiskAssessment {
        var riskFactors: [RiskFactor] = []
        var overallRisk = 0.0
        var recommendations: [String] = []
        
        // Temperature risk assessment
        if temperature > 35 {
            riskFactors.append(RiskFactor(type: .heat, severity: .high, description: "Dangerous heat exposure"))
            overallRisk += 0.4
            recommendations.append("Provide plenty of fresh water and shade")
            recommendations.append("Limit outdoor activity during peak heat")
        } else if temperature > 30 {
            riskFactors.append(RiskFactor(type: .heat, severity: .moderate, description: "Moderate heat stress"))
            overallRisk += 0.2
            recommendations.append("Monitor for signs of overheating")
        } else if temperature < 5 {
            riskFactors.append(RiskFactor(type: .cold, severity: .moderate, description: "Cold exposure risk"))
            overallRisk += 0.15
            recommendations.append("Provide warm shelter and extra bedding")
        }
        
        // Humidity risk assessment
        if humidity > 80 {
            riskFactors.append(RiskFactor(type: .humidity, severity: .moderate, description: "High humidity stress"))
            overallRisk += 0.15
            recommendations.append("Ensure good ventilation in living space")
        } else if humidity < 20 {
            riskFactors.append(RiskFactor(type: .humidity, severity: .low, description: "Low humidity risk"))
            overallRisk += 0.1
            recommendations.append("Maintain proper hydration levels")
        }
        
        // Breed-specific climate considerations
        let brachycephalicBreeds = ["Pug", "French Bulldog", "English Bulldog", "Boston Terrier", "Boxer"]
        if brachycephalicBreeds.contains(where: { breed.localizedCaseInsensitiveContains($0) }) {
            if temperature > 25 {
                riskFactors.append(RiskFactor(type: .breedSpecific, severity: .high, description: "Brachycephalic breed heat sensitivity"))
                overallRisk += 0.25
                recommendations.append("Extra care needed in warm weather for flat-faced breeds")
                recommendations.append("Never leave in car during warm weather")
            }
        }
        
        // Cap overall risk at 1.0
        overallRisk = min(overallRisk, 1.0)
        
        return ClimateRiskAssessment(
            temperature: temperature,
            humidity: humidity,
            overallRisk: overallRisk,
            riskFactors: riskFactors,
            recommendations: recommendations
        )
    }
    
    func getSeasonalRecommendations(month: Int, breed: String) -> [String] {
        var recommendations: [String] = []
        
        // Seasonal adjustments based on month (1-12)
        if month >= 12 || month <= 2 { // Winter months
            recommendations.append("Provide extra warmth with heated beds")
            recommendations.append("Shorten walk duration in extreme cold")
            recommendations.append("Check paws for ice/road salt damage")
        } else if month >= 3 && month <= 5 { // Spring
            recommendations.append("Gradually increase exercise as weather warms")
            recommendations.append("Watch for seasonal allergies")
        } else if month >= 6 && month <= 8 { // Summer
            recommendations.append("Walk early morning or late evening to avoid heat")
            recommendations.append("Provide cooling mats or vests")
            recommendations.append("Increase water availability")
        } else { // Fall
            recommendations.append("Prepare for seasonal shedding")
            recommendations.append("Gradually adjust feeding as activity decreases")
        }
        
        return recommendations
    }
}

// Supporting structures
struct ClimateRiskAssessment {
    let temperature: Double
    let humidity: Double
    let overallRisk: Double
    let riskFactors: [RiskFactor]
    let recommendations: [String]
}

struct RiskFactor {
    let type: RiskType
    let severity: SeverityLevel
    let description: String
}

enum RiskType {
    case heat
    case cold
    case humidity
    case breedSpecific
}

enum SeverityLevel {
    case low
    case moderate
    case high
}
