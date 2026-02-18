//
//  HealthMetrics.swift
//  GuardianTwin
//

import Foundation

struct HealthMetrics: Codable {
    let timestamp: Date
    var heartRate: Int?
    var temperature: Double?
    var activityMinutes: Int?
    var sleepHours: Double?
    var waterIntake: Double? // in ml
    var foodIntake: Double? // in grams
    
    init(timestamp: Date = Date(), 
         heartRate: Int? = nil, 
         temperature: Double? = nil, 
         activityMinutes: Int? = nil, 
         sleepHours: Double? = nil, 
         waterIntake: Double? = nil, 
         foodIntake: Double? = nil) {
        self.timestamp = timestamp
        self.heartRate = heartRate
        self.temperature = temperature
        self.activityMinutes = activityMinutes
        self.sleepHours = sleepHours
        self.waterIntake = waterIntake
        self.foodIntake = foodIntake
    }
    
    var healthScore: Int {
        guard let heartRate = heartRate, let temperature = temperature else {
            return 100 // Default score if no vital signs
        }
        
        var score = 100
        
        // Heart rate analysis (normal range: 60-140)
        if heartRate < 60 || heartRate > 140 {
            score -= 20
        } else if heartRate < 70 || heartRate > 130 {
            score -= 10
        }
        
        // Temperature analysis (normal range: 38-39°C)
        if temperature < 37.5 || temperature > 39.5 {
            score -= 25
        } else if temperature < 38.0 || temperature > 39.0 {
            score -= 15
        }
        
        // Activity minutes (recommended: 30+ mins)
        if let activityMinutes = activityMinutes {
            if activityMinutes < 15 {
                score -= 20
            } else if activityMinutes < 30 {
                score -= 10
            }
        }
        
        // Sleep hours (recommended: 12-14 hrs for dogs)
        if let sleepHours = sleepHours {
            if sleepHours < 8 {
                score -= 25
            } else if sleepHours < 12 {
                score -= 10
            }
        }
        
        return max(0, score)
    }
}