//
//  PetTranslatorService.swift
//  GuardianTwin
//

import Foundation

class PetTranslatorService: ObservableObject {
    
    nonisolated(unsafe) static let shared = PetTranslatorService()
    
    private init() {}
    
    func analyzeBehavior(soundPattern: String, bodyLanguage: String, context: String) -> TranslatorResult {
        // Simulate analysis based on input parameters
        let emotion = determineEmotion(from: soundPattern, bodyLanguage: bodyLanguage, context: context)
        let confidence = calculateConfidence(emotion: emotion, soundPattern: soundPattern, bodyLanguage: bodyLanguage)
        let interpretedMessage = generateInterpretation(emotion: emotion, context: context)
        let suggestedAction = generateSuggestion(emotion: emotion, context: context)
        
        return TranslatorResult(
            detectedEmotion: emotion,
            confidence: confidence,
            interpretedMessage: interpretedMessage,
            suggestedAction: suggestedAction
        )
    }
    
    private func determineEmotion(from soundPattern: String, bodyLanguage: String, context: String) -> TranslatorResult.Emotion {
        // Analyze sound patterns
        let soundAnalysis = analyzeSound(soundPattern: soundPattern)
        
        // Analyze body language
        let bodyAnalysis = analyzeBodyLanguage(bodyLanguage: bodyLanguage)
        
        // Analyze context
        let contextAnalysis = analyzeContext(context: context)
        
        // Combine analyses to determine emotion
        var emotionScores: [TranslatorResult.Emotion: Double] = [:]
        
        // Sound-based emotions
        for (emotion, score) in soundAnalysis {
            emotionScores[emotion, default: 0] += score
        }
        
        // Body language-based emotions
        for (emotion, score) in bodyAnalysis {
            emotionScores[emotion, default: 0] += score
        }
        
        // Context-based emotions
        for (emotion, score) in contextAnalysis {
            emotionScores[emotion, default: 0] += score
        }
        
        // Return emotion with highest score
        if let topEmotion = emotionScores.max(by: { $0.value < $1.value })?.key {
            return topEmotion
        } else {
            // Default to curious if no clear winner
            return .curious
        }
    }
    
    private func analyzeSound(soundPattern: String) -> [TranslatorResult.Emotion: Double] {
        var scores: [TranslatorResult.Emotion: Double] = [:]
        
        let lowerPattern = soundPattern.lowercased()
        
        if lowerPattern.contains("bark") || lowerPattern.contains("woof") {
            scores[.excited] = 0.7
            scores[.happy] = 0.6
        } else if lowerPattern.contains("whimper") || lowerPattern.contains("whine") {
            scores[.sad] = 0.8
            scores[.anxious] = 0.7
        } else if lowerPattern.contains("growl") {
            scores[.angry] = 0.8
            scores[.scared] = 0.5
        } else if lowerPattern.contains("pant") {
            scores[.tired] = 0.6
            scores[.excited] = 0.4
        } else if lowerPattern.contains("howl") {
            scores[.sad] = 0.7
            scores[.lonely] = 0.6
        }
        
        return scores
    }
    
    private func analyzeBodyLanguage(bodyLanguage: String) -> [TranslatorResult.Emotion: Double] {
        var scores: [TranslatorResult.Emotion: Double] = [:]
        
        let lowerBodyLang = bodyLanguage.lowercased()
        
        if lowerBodyLang.contains("tail wagging") || lowerBodyLang.contains("play bow") {
            scores[.happy] = 0.8
            scores[.excited] = 0.7
        } else if lowerBodyLang.contains("tail tucked") || lowerBodyLang.contains("ears back") {
            scores[.scared] = 0.8
            scores[.anxious] = 0.7
        } else if lowerBodyLang.contains("stiff posture") || lowerBodyLang.contains("hackles up") {
            scores[.angry] = 0.8
            scores[.aggressive] = 0.7
        } else if lowerBodyLang.contains("laying down") || lowerBodyLang.contains("sleeping") {
            scores[.tired] = 0.9
            scores[.calm] = 0.6
        } else if lowerBodyLang.contains("pacing") || lowerBodyLang.contains("restless") {
            scores[.anxious] = 0.8
            scores[.excited] = 0.5
        }
        
        return scores
    }
    
    private func analyzeContext(context: String) -> [TranslatorResult.Emotion: Double] {
        var scores: [TranslatorResult.Emotion: Double] = [:]
        
        let lowerContext = context.lowercased()
        
        if lowerContext.contains("meal") || lowerContext.contains("food") {
            scores[.excited] = 0.7
            scores[.happy] = 0.6
        } else if lowerContext.contains("thunder") || lowerContext.contains("storm") {
            scores[.scared] = 0.8
            scores[.anxious] = 0.7
        } else if lowerContext.contains("bedtime") || lowerContext.contains("night") {
            scores[.tired] = 0.7
            scores[.calm] = 0.6
        } else if lowerContext.contains("stranger") || lowerContext.contains("unknown person") {
            scores[.anxious] = 0.7
            scores[.scared] = 0.6
        } else if lowerContext.contains("play") || lowerContext.contains("walk") {
            scores[.excited] = 0.8
            scores[.happy] = 0.7
        }
        
        return scores
    }
    
    private func calculateConfidence(emotion: TranslatorResult.Emotion, soundPattern: String, bodyLanguage: String) -> Double {
        // Calculate confidence based on how consistent the signals are
        var confidence = 0.5 // Base confidence
        
        // Increase confidence if sound and body language align
        let soundScores = analyzeSound(soundPattern: soundPattern)
        let bodyScores = analyzeBodyLanguage(bodyLanguage: bodyLanguage)
        
        if soundScores[emotion, default: 0] > 0.5 && bodyScores[emotion, default: 0] > 0.5 {
            confidence += 0.3 // Strong alignment
        } else if soundScores[emotion, default: 0] > 0.3 || bodyScores[emotion, default: 0] > 0.3 {
            confidence += 0.1 // Some alignment
        }
        
        // Further refine based on context
        let contextScores = analyzeContext(context: "general") // We'll use general context here
        
        if contextScores[emotion, default: 0] > 0.5 {
            confidence += 0.1
        }
        
        // Cap confidence at 0.95
        return min(confidence, 0.95)
    }
    
    private func generateInterpretation(emotion: TranslatorResult.Emotion, context: String) -> String {
        let interpretations: [TranslatorResult.Emotion: String] = [
            .happy: "Your pet seems joyful and content. They're expressing happiness and satisfaction with their current situation.",
            .sad: "Your pet appears to be feeling down or lonely. They may need extra comfort and attention.",
            .anxious: "Your pet is showing signs of nervousness or worry. They might need reassurance and a calm environment.",
            .excited: "Your pet is full of energy and enthusiasm. They're eager for interaction or activity.",
            .scared: "Your pet feels threatened or frightened. They need comfort and a safe space to calm down.",
            .angry: "Your pet is displaying aggression or irritation. Give them space and avoid confrontation.",
            .curious: "Your pet is interested and exploring their surroundings. They're engaged with their environment.",
            .tired: "Your pet is sleepy and needs rest. They should be given a quiet place to relax.",
            .calm: "Your pet is relaxed and peaceful. They're in a comfortable and secure state.",
            .lonely: "Your pet seems to be feeling isolated or missing companionship. They may need more social interaction.",
            .aggressive: "Your pet is displaying dominant or territorial behavior. Maintain calm and avoid direct confrontation."
        ]
        
        return interpretations[emotion] ?? "Your pet is expressing a mix of emotions that require attention."
    }
    
    private func generateSuggestion(emotion: TranslatorResult.Emotion, context: String) -> String {
        let suggestions: [TranslatorResult.Emotion: String] = [
            .happy: "Continue positive interactions and reward good behavior.",
            .sad: "Spend quality time with your pet and offer comfort items like toys or blankets.",
            .anxious: "Create a calm environment and consider using anxiety-reducing techniques.",
            .excited: "Channel their energy into positive activities like play or training.",
            .scared: "Provide a safe, quiet space and avoid forcing interaction until they calm down.",
            .angry: "Identify and remove the trigger, then give them space to calm down.",
            .curious: "Encourage exploration in a safe way and engage their mind with puzzles or toys.",
            .tired: "Allow them to rest and ensure they have a comfortable sleeping area.",
            .calm: "Maintain the peaceful environment and continue providing comfort.",
            .lonely: "Spend more quality time with your pet and provide social interaction opportunities.",
            .aggressive: "Create distance and avoid direct confrontation. Consult a pet behavior specialist if aggression continues."
        ]
        
        return suggestions[emotion] ?? "Observe your pet's behavior and respond appropriately to their needs."
    }
}
