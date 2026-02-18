//
//  PetProfile.swift
//  GuardianTwin
//

import Foundation

struct PetProfile: Codable, Identifiable {
    let id = UUID()
    var name: String
    var breed: String
    var age: Int
    var weight: Double
    var activityLevel: Int // 1-5 scale
    var dailyCalories: Int
    
    init(name: String, breed: String, age: Int, weight: Double, activityLevel: Int, dailyCalories: Int) {
        self.name = name
        self.breed = breed
        self.age = age
        self.weight = weight
        self.activityLevel = activityLevel
        self.dailyCalories = dailyCalories
    }
    
    // Calculated properties
    var riskLevel: Double {
        // Calculate risk based on various factors
        var risk = 0.0
        
        // Higher weight increases risk
        if weight > 40 { risk += 0.2 } // Heavy pet
        else if weight > 25 { risk += 0.1 } // Medium weight
        
        // Older pets have higher risk
        if age > 10 { risk += 0.15 }
        else if age > 7 { risk += 0.05 }
        
        // Lower activity increases risk
        if activityLevel < 2 { risk += 0.15 }
        else if activityLevel < 3 { risk += 0.05 }
        
        return min(risk, 1.0) // Cap at 100%
    }
    
    var healthScore: Int {
        let baseScore = 100
        let riskReduction = Int(riskLevel * 100)
        return max(0, baseScore - riskReduction)
    }
}