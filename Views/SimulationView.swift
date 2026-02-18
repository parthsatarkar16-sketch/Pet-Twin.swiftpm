//
//  SimulationView.swift
//  GuardianTwin
//

import SwiftUI

struct SimulationView: View {
    @StateObject private var petViewModel: PetViewModel
    @StateObject private var simulationViewModel: SimulationViewModel
    
    init() {
        let pet = PetViewModel()
        _petViewModel = StateObject(wrappedValue: pet)
        _simulationViewModel = StateObject(wrappedValue: SimulationViewModel(petViewModel: pet))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Risk Simulation")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Project your pet's health over time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Timeline Slider
                    VStack(spacing: 16) {
                        HStack {
                            Text("Timeline")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("\(simulationViewModel.selectedMonths) months")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        TimelineSlider(
                            value: Binding(
                                get: { Double(simulationViewModel.selectedMonths) },
                                set: { simulationViewModel.selectedMonths = Int($0) }
                            ),
                            range: 1...12
                        ) { value in
                            simulationViewModel.selectedMonths = Int(value)
                            simulationViewModel.updateSimulation()
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    // Climate Temperature Control
                    VStack(spacing: 16) {
                        HStack {
                            Text("Ambient Temperature")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("\(String(format: "%.1f", simulationViewModel.selectedTemperature))°C")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Slider(
                            value: $simulationViewModel.selectedTemperature,
                            in: 20...45,
                            step: 0.5
                        ) { _ in
                            simulationViewModel.updateSimulation()
                        }
                        .accentColor(Color("AccentColor"))
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    // Results Section
                    if !simulationViewModel.isLoading {
                        VStack(spacing: 20) {
                            // Health Score Card
                            HealthScoreCard(score: simulationViewModel.getCombinedHealthScore())
                            
                            // Projected Metrics
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Projected Weight")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    if let result = simulationViewModel.simulationResult {
                                        Text(String(format: "%.1f kg", result.projectedWeight))
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                    }
                                }
                                
                                HStack {
                                    Text("Overall Risk")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Text(String(format: "%.0f%%", simulationViewModel.getCombinedRiskPercentage() * 100))
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(getRiskColor(simulationViewModel.getCombinedRiskPercentage()))
                                }
                                
                                // Climate Risk Indicator
                                if let climateRisk = simulationViewModel.climateRisk {
                                    HStack {
                                        Text("Climate Risk")
                                            .font(.headline)
                                        
                                        Spacer()
                                        
                                        Text(String(format: "%.0f%%", climateRisk.overallRisk * 100))
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(getRiskColor(climateRisk.overallRisk))
                                    }
                                    
                                    // Climate Risk Warning
                                    if climateRisk.overallRisk > 0.7 {
                                        HStack {
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .foregroundColor(.yellow)
                                            
                                            Text("High climate risk detected! Take extra precautions.")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding()
                                        .background(Color.yellow.opacity(0.1))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                            
                            // Recommendations
                            if !simulationViewModel.getRecommendations().isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Recommendations")
                                        .font(.headline)
                                    
                                    ForEach(simulationViewModel.getRecommendations().prefix(5), id: \.self) { recommendation in
                                        HStack {
                                            Circle()
                                                .fill(Color.accentColor)
                                                .frame(width: 6, height: 6)
                                            
                                            Text(recommendation)
                                                .font(.subheadline)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                        }
                                        .padding(.vertical, 2)
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        ProgressView("Calculating simulation...")
                            .padding()
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("Simulation")
            .onAppear {
                simulationViewModel.updateSimulation()
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
    
    private func getRiskColor(_ risk: Double) -> Color {
        if risk < 0.3 {
            return Color.green
        } else if risk < 0.6 {
            return Color.yellow
        } else {
            return Color.red
        }
    }
}

struct SimulationView_Previews: PreviewProvider {
    static var previews: some View {
        SimulationView()
    }
}