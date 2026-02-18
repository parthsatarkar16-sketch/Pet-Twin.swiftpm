//
//  EmergencyView.swift
//  GuardianTwin
//

import SwiftUI

struct EmergencyView: View {
    private let emergencyService = EmergencyGuideService.shared
    @State private var selectedSymptom: SymptomType?
    @State private var showingGuide = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "staroflife.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.red)
                        
                        Text("Emergency Guide")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Tap any symptom for immediate guidance")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Symptom List
                    LazyVStack(spacing: 16) {
                        ForEach(emergencyService.getAllSymptoms(), id: \.self) { symptom in
                            Button(action: {
                                selectedSymptom = symptom
                                showingGuide = true
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(symptom.rawValue)
                                            .font(.headline)
                                        
                                        Text(getSymptomDescription(for: symptom))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                            .sheet(isPresented: $showingGuide) {
                                if let symptom = selectedSymptom {
                                    EmergencyGuideDetailView(
                                        guide: emergencyService.getEmergencyGuide(for: symptom)
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Emergency Contact Section
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "phone.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.red)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Emergency Contacts")
                                    .font(.headline)
                                
                                Text("Save these numbers for quick access")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        VStack(spacing: 12) {
                            EmergencyContactRow(
                                name: "Emergency Vet",
                                phone: "911",
                                color: Color.red
                            )
                            
                            EmergencyContactRow(
                                name: "Poison Control",
                                phone: "1-888-426-4435",
                                color: Color.orange
                            )
                            
                            EmergencyContactRow(
                                name: "Regular Vet",
                                phone: "Add Number",
                                color: Color.blue
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("Emergency")
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.05, green: 0.1, blue: 0.2), Color(red: 0.1, green: 0.2, blue: 0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
    }
    
    private func getSymptomDescription(for symptom: SymptomType) -> String {
        switch symptom {
        case .vomiting:
            return "Persistent nausea, possible dehydration"
        case .injury:
            return "Physical trauma, bleeding, or mobility issues"
        case .lethargy:
            return "Unusual tiredness, lack of energy"
        case .seizure:
            return "Sudden convulsions or loss of consciousness"
        case .difficultyBreathing:
            return "Labored breathing, gasping, wheezing"
        case .heatStroke:
            return "Overheating, panting, collapse"
        }
    }
}

struct EmergencyContactRow: View {
    let name: String
    let phone: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(phone)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Image(systemName: "phone.fill")
                .foregroundColor(color)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct EmergencyGuideDetailView: View {
    let guide: EmergencyGuide
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    HStack {
                        Text(guide.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text(guide.severity.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(getSeverityColor(guide.severity))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Divider()
                    
                    // Immediate Steps
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Immediate Steps")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        ForEach(Array(guide.immediateSteps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                                
                                Text(step)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                        }
                    }
                    
                    // When to Call Vet
                    VStack(alignment: .leading, spacing: 12) {
                        Text("When to Call Your Vet")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        ForEach(guide.whenToCallVet, id: \.self) { condition in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                    .frame(width: 20)
                                
                                Text(condition)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                        }
                    }
                    
                    // Prevention Tips
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Prevention Tips")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        ForEach(guide.preventionTips, id: \.self) { tip in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                    .frame(width: 20)
                                
                                Text(tip)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.05, green: 0.1, blue: 0.2), Color(red: 0.1, green: 0.2, blue: 0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
    }
    
    private func getSeverityColor(_ severity: EmergencyGuide.SeverityLevel) -> Color {
        switch severity {
        case .low: return Color.green
        case .moderate: return Color.yellow
        case .high: return Color.orange
        case .critical: return Color.red
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
}

struct EmergencyView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyView()
    }
}