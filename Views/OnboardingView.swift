//
//  OnboardingView.swift
//  GuardianTwin
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var petViewModel = PetViewModel()
    @State private var name = ""
    @State private var breed = ""
    @State private var age = 1
    @State private var weight = 10.0
    @State private var activityLevel = 3
    @State private var dailyCalories = 300
    @State private var showingDashboard = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 48))
                            .foregroundColor(Color("AccentColor"))
                        
                        Text("Welcome to GuardianTwin")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Complete your pet's profile to get started")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    // Form
                    VStack(spacing: 20) {
                        // Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Pet's Name")
                                .font(.headline)
                            
                            TextField("Enter your pet's name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical, 4)
                        }
                        
                        // Breed Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Breed")
                                .font(.headline)
                            
                            TextField("Enter your pet's breed", text: $breed)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical, 4)
                        }
                        
                        // Age Slider
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Age")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text("\(age) years")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Slider(value: Binding(
                                get: { Double(age) },
                                set: { age = Int($0) }
                            ), in: 0...20, step: 1)
                            .accentColor(Color("AccentColor"))
                        }
                        
                        // Weight Slider
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Weight")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text(String(format: "%.1f kg", weight))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Slider(value: $weight, in: 0.5...100, step: 0.5)
                                .accentColor(Color("AccentColor"))
                        }
                        
                        // Activity Level Slider
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Activity Level")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text("\(activityLevel)/5")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Slider(value: Binding(
                                get: { Double(activityLevel) },
                                set: { activityLevel = Int($0) }
                            ), in: 1...5, step: 1)
                            .accentColor(Color("AccentColor"))
                        }
                        
                        // Daily Calories Slider
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Daily Calories")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text("\(dailyCalories) kcal")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Slider(value: Binding(
                                get: { Double(dailyCalories) },
                                set: { dailyCalories = Int($0) }
                            ), in: 100...1000, step: 50)
                            .accentColor(Color("AccentColor"))
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    // Save Button
                    NavigationLink(destination: DashboardView()
                                    .environmentObject(petViewModel), isActive: $showingDashboard) {
                        Button(action: {
                            petViewModel.savePetProfile(
                                name: name,
                                breed: breed,
                                age: age,
                                weight: weight,
                                activityLevel: activityLevel,
                                dailyCalories: dailyCalories
                            )
                            
                            // Delay navigation to show animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showingDashboard = true
                            }
                        }) {
                            Text("Complete Profile")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.teal]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .disabled(name.isEmpty || breed.isEmpty)
                    }
                    .isDetailLink(false)
                }
                .padding()
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
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}