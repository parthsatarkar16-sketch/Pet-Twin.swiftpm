//
//  TranslatorResult.swift
//  GuardianTwin
//

import Foundation

struct TranslatorResult: Codable {
    let timestamp: Date
    var detectedEmotion: Emotion
    var confidence: Double // 0.0 to 1.0
    var interpretedMessage: String
    var suggestedAction: String
    
    enum Emotion: String, CaseIterable, Codable {
        case happy = "Happy"
        case sad = "Sad"
        case anxious = "Anxious"
        case excited = "Excited"
        case scared = "Scared"
        case angry = "Angry"
        case curious = "Curious"
        case tired = "Tired"
        case calm = "Calm"
        case lonely = "Lonely"
        case aggressive = "Aggressive"
        
        var color: String {
            switch self {
            case .happy: return "green"
            case .sad: return "blue"
            case .anxious: return "yellow"
            case .excited: return "orange"
            case .scared: return "red"
            case .angry: return "purple"
            case .curious: return "teal"
            case .tired: return "gray"
            case .calm: return "blue"
            case .lonely: return "blue"
            case .aggressive: return "red"
            }
        }
    }
    
    init(timestamp: Date = Date(), 
         detectedEmotion: Emotion, 
         confidence: Double, 
         interpretedMessage: String, 
         suggestedAction: String) {
        self.timestamp = timestamp
        self.detectedEmotion = detectedEmotion
        self.confidence = confidence
        self.interpretedMessage = interpretedMessage
        self.suggestedAction = suggestedAction
    }
}