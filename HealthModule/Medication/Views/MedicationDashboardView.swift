import SwiftUI

struct MedicationDashboardView: View {
    @State var viewModel = MedicationViewModel()
    @State private var showingAddMedication = false
    
    // Luxury Palette from HomeView
    let bgColor = Color(red: 0.98, green: 0.97, blue: 0.94) // Warm Cream
    let accentColor = Color(red: 0.85, green: 0.56, blue: 0.43) // Muted Terracotta
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20) // Deep Mocha
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Medication")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(deepText)
                        Text("Health is Wealth")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(deepText.opacity(0.6))
                    }
                    Spacer()
                    Button(action: { showingAddMedication = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Circle().fill(accentColor))
                            .shadow(color: accentColor.opacity(0.3), radius: 10, y: 5)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Today's Progress Overview
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Daily Progress")
                            .font(.system(size: 18, weight: .bold, design: .serif))
                        Text("\(completedCount)/\(totalTodayCount) Doses Taken")
                            .font(.system(size: 14))
                            .foregroundColor(deepText.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    ProgressRing(progress: completionRate, color: accentColor)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text("\(Int(completionRate * 100))%")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(deepText)
                        )
                }
                .padding(24)
                .background(RoundedRectangle(cornerRadius: 32).fill(Color.white))
                .padding(.horizontal, 24)
                
                // Today's Doses
                VStack(alignment: .leading, spacing: 20) {
                    Text("Today's Schedule")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .padding(.horizontal, 32)
                    
                    let todayDoses = viewModel.todayMedications()
                    
                    if todayDoses.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "pills.fill")
                                .font(.system(size: 50))
                                .foregroundColor(accentColor.opacity(0.2))
                            Text("No medications scheduled for today")
                                .font(.system(size: 14))
                                .foregroundColor(deepText.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(todayDoses, id: \.1.id) { pair in
                                MedicationCard(medication: pair.0, dose: pair.1) {
                                    viewModel.markDoseAsTaken(medication: pair.0, dose: pair.1)
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal, 24)
                        .animation(.spring(), value: todayDoses.count)
                    }
                }
                
                Spacer(minLength: 50)
            }
        }
        .background(bgColor.ignoresSafeArea())
        .onAppear {
            // Force a refresh when the view appears
        }
        .sheet(isPresented: $showingAddMedication) {
            AddMedicationView(viewModel: viewModel)
        }
    }
    
    private var totalTodayCount: Int {
        viewModel.todayMedications().count
    }
    
    private var completedCount: Int {
        viewModel.todayMedications().filter { $0.1.status == .taken }.count
    }
    
    private var completionRate: CGFloat {
        guard totalTodayCount > 0 else { return 0 }
        return CGFloat(completedCount) / CGFloat(totalTodayCount)
    }
}
