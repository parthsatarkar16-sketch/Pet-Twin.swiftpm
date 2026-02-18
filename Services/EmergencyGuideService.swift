//
//  EmergencyGuideService.swift
//  GuardianTwin
//

import Foundation

class EmergencyGuideService: ObservableObject {
    
    nonisolated(unsafe) static let shared = EmergencyGuideService()
    
    private init() {}
    
    func getEmergencyGuide(for symptom: SymptomType) -> EmergencyGuide {
        switch symptom {
        case .vomiting:
            return EmergencyGuide(
                title: "Vomiting Emergency",
                severity: .moderate,
                immediateSteps: [
                    "Remove food and water for 1-2 hours",
                    "Observe vomit color and consistency",
                    "Keep pet calm and quiet"
                ],
                whenToCallVet: [
                    "Vomiting persists for more than 24 hours",
                    "Blood present in vomit",
                    "Signs of dehydration",
                    "Lethargy or weakness accompanies vomiting"
                ],
                preventionTips: [
                    "Feed smaller, more frequent meals",
                    "Avoid sudden diet changes",
                    "Prevent access to toxic foods"
                ]
            )
        case .injury:
            return EmergencyGuide(
                title: "Injury Response",
                severity: .high,
                immediateSteps: [
                    "Stay calm and approach slowly",
                    "Check for consciousness and breathing",
                    "Apply pressure to bleeding wounds",
                    "Immobilize injured area if possible"
                ],
                whenToCallVet: [
                    "Severe bleeding that won't stop",
                    "Difficulty breathing",
                    "Possible broken bones",
                    "Loss of consciousness"
                ],
                preventionTips: [
                    "Supervise play and exercise",
                    "Pet-proof living areas",
                    "Regular nail trims to prevent accidents"
                ]
            )
        case .lethargy:
            return EmergencyGuide(
                title: "Lethargy Warning",
                severity: .moderate,
                immediateSteps: [
                    "Monitor temperature and breathing",
                    "Check for other symptoms",
                    "Encourage small amounts of water",
                    "Create quiet, comfortable space"
                ],
                whenToCallVet: [
                    "Lethargy persists for more than 24 hours",
                    "Accompanied by loss of appetite",
                    "Signs of pain or discomfort",
                    "Difficulty walking or standing"
                ],
                preventionTips: [
                    "Maintain regular exercise routine",
                    "Monitor for underlying health issues",
                    "Ensure adequate rest and nutrition"
                ]
            )
        case .seizure:
            return EmergencyGuide(
                title: "Seizure Management",
                severity: .high,
                immediateSteps: [
                    "Stay calm and time the seizure",
                    "Move objects away from pet",
                    "Don't put hands near mouth",
                    "Speak softly to comfort pet"
                ],
                whenToCallVet: [
                    "Seizure lasts longer than 5 minutes",
                    "Multiple seizures in a day",
                    "Doesn't regain consciousness between seizures",
                    "First time experiencing a seizure"
                ],
                preventionTips: [
                    "Follow prescribed medication schedule",
                    "Maintain consistent sleep patterns",
                    "Avoid known seizure triggers"
                ]
            )
        case .difficultyBreathing:
            return EmergencyGuide(
                title: "Breathing Difficulty",
                severity: .critical,
                immediateSteps: [
                    "Keep pet calm and cool",
                    "Ensure airways are clear",
                    "Position for optimal breathing",
                    "Transport to vet immediately"
                ],
                whenToCallVet: [
                    "Any difficulty breathing is emergency",
                    "Blue or pale gums",
                    "Gasping or labored breathing",
                    "Collapse or fainting"
                ],
                preventionTips: [
                    "Maintain healthy weight",
                    "Avoid extreme temperatures",
                    "Regular cardiac and respiratory checks"
                ]
            )
        case .heatStroke:
            return EmergencyGuide(
                title: "Heat Stroke Response",
                severity: .critical,
                immediateSteps: [
                    "Move to cool area immediately",
                    "Apply cool (not cold) water to paws and belly",
                    "Offer small amounts of water",
                    "Use fan for air circulation"
                ],
                whenToCallVet: [
                    "Body temperature over 104°F (40°C)",
                    "Signs of distress or collapse",
                    "Gums are bright red or dry",
                    "Any sign of heat stroke requires immediate care"
                ],
                preventionTips: [
                    "Never leave pet in car",
                    "Provide shade and water during hot days",
                    "Exercise during cooler parts of day"
                ]
            )
        }
    }
    
    func getAllSymptoms() -> [SymptomType] {
        return SymptomType.allCases
    }
}

struct EmergencyGuide {
    let title: String
    let severity: SeverityLevel
    let immediateSteps: [String]
    let whenToCallVet: [String]
    let preventionTips: [String]
    
    enum SeverityLevel: String, CaseIterable {
        case low = "Low Risk"
        case moderate = "Moderate Risk" 
        case high = "High Risk"
        case critical = "Critical Emergency"
        
        var color: String {
            switch self {
            case .low: return "green"
            case .moderate: return "yellow"
            case .high: return "orange"
            case .critical: return "red"
            }
        }
    }
}

enum SymptomType: String, CaseIterable {
    case vomiting = "Vomiting"
    case injury = "Injury"
    case lethargy = "Lethargy"
    case seizure = "Seizure"
    case difficultyBreathing = "Difficulty Breathing"
    case heatStroke = "Heat Stroke"
}
