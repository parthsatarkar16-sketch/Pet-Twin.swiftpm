//
//  TranslatorViewModel.swift
//  GuardianTwin
//

import Foundation
import SwiftUI

class TranslatorViewModel: ObservableObject {
    @Published var currentTranslation: TranslatorResult?
    @Published var recordedSoundPattern: String = ""
    @Published var detectedBodyLanguage: String = ""
    @Published var detectedContext: String = ""
    @Published var isAnalyzing = false
    @Published var errorMessage: String?
    
    private let translatorService = PetTranslatorService.shared
    
    func analyzePetBehavior() {
        isAnalyzing = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.translatorService.analyzeBehavior(
                soundPattern: self.recordedSoundPattern,
                bodyLanguage: self.detectedBodyLanguage,
                context: self.detectedContext
            )
            
            DispatchQueue.main.async {
                self.currentTranslation = result
                self.isAnalyzing = false
            }
        }
    }
    
    func simulateBehaviorAnalysis() {
        // For demonstration purposes, create a simulated result
        let emotions = TranslatorResult.Emotion.allCases
        let randomEmotion = emotions.randomElement() ?? .happy
        let confidence = Double.random(in: 0.6...1.0)
        
        let sampleMessages = [
            "Your pet is feeling playful and energetic today.",
            "They seem content and relaxed in their environment.",
            "Your pet appears to be seeking attention or affection.",
            "They're showing curiosity about their surroundings.",
            "Your pet seems tired and ready for rest.",
            "They appear to be alert and watchful of their environment."
        ]
        
        let sampleActions = [
            "Spend some interactive time playing with your pet.",
            "Provide a quiet space for relaxation.",
            "Offer comfort and reassurance if needed.",
            "Engage their mind with puzzle toys or training.",
            "Ensure they have a comfortable place to rest.",
            "Monitor their behavior for any changes."
        ]
        
        let simulatedResult = TranslatorResult(
            detectedEmotion: randomEmotion,
            confidence: confidence,
            interpretedMessage: sampleMessages.randomElement() ?? "",
            suggestedAction: sampleActions.randomElement() ?? ""
        )
        
        currentTranslation = simulatedResult
    }
    
    func clearCurrentTranslation() {
        currentTranslation = nil
    }
    
    func getEmotionColor(_ emotion: TranslatorResult.Emotion) -> Color {
        switch emotion {
        case .happy: return Color.green
        case .sad: return Color.blue
        case .anxious: return Color.yellow
        case .excited: return Color.orange
        case .scared: return Color.red
        case .angry: return Color.purple
        case .curious: return Color.teal
        case .tired: return Color.gray
        case .calm: return Color.blue
        case .lonely: return Color.blue
        case .aggressive: return Color.red
        }
    }
}
