//
//  DashboardView.swift
//  GuardianTwin
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var petViewModel: PetViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hello, \(petViewModel.petProfile?.name ?? "Pet Parent")!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Here's your pet's health overview")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Health Score Card
                    if let petProfile = petViewModel.petProfile {
                        HealthScoreCard(score: petProfile.healthScore)
                            .padding(.horizontal)
                    }
                    
                    // Risk Indicator
                    if let petProfile = petViewModel.petProfile {
                        RiskIndicatorView(riskLevel: petProfile.riskLevel)
                            .padding(.horizontal)
                    }
                    
                    // Quick Actions
                    VStack(spacing: 12) {
                        Text("Quick Actions")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            NavigationLink(destination: SimulationView()) {
                                VStack {
                                    Image(systemName: "brain.filled.head.profile")
                                        .font(.system(size: 24))
                                        .foregroundColor(.blue)
                                    
                                    Text("Simulate")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                                .frame(width: 80, height: 80)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(16)
                            }
                            
                            NavigationLink(destination: TranslatorView()) {
                                VStack {
                                    Image(systemName: "waveform")
                                        .font(.system(size: 24))
                                        .foregroundColor(.green)
                                    
                                    Text("Translate")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                                .frame(width: 80, height: 80)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(16)
                            }
                            
                            NavigationLink(destination: EmergencyView()) {
                                VStack {
                                    Image(systemName: "staroflife.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.red)
                                    
                                    Text("Emergency")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                                .frame(width: 80, height: 80)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Dashboard")
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
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(PetViewModel())
    }
}