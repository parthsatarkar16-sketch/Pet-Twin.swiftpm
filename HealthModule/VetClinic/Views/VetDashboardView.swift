import SwiftUI

struct VetDashboardView: View {
    @State var viewModel = VetClinicViewModel()
    
    // Luxury Palette
    let bgColor = Color(red: 0.98, green: 0.97, blue: 0.94) 
    let accentColor = Color(red: 0.85, green: 0.56, blue: 0.43)
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Vet Clinic")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(deepText)
                        Text("Professional Pet Care")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(deepText.opacity(0.6))
                    }
                    Spacer()
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 24))
                        .foregroundColor(accentColor)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Stability Score Card
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Health Stability")
                                .font(.system(size: 18, weight: .bold, design: .serif))
                            Text("Updated 2 hours ago")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        ScoreRing(progress: viewModel.stabilityScore, color: accentColor)
                            .frame(width: 70, height: 70)
                    }
                    .padding(24)
                    .background(RoundedRectangle(cornerRadius: 32).fill(Color.white))
                    .padding(.horizontal, 24)
                }
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 20) {
                    Text("Medical Trackers")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .padding(.horizontal, 32)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        NavigationLink(destination: SymptomDashboardView()) {
                            TrackerQuickCard(title: "Symptoms", icon: "waveform.path.ecg", color: .red)
                        }
                        NavigationLink(destination: WeightTrackerView()) {
                            TrackerQuickCard(title: "Weight", icon: "scalemass.fill", color: .blue)
                        }
                        NavigationLink(destination: VaccinationDashboardView()) {
                            TrackerQuickCard(title: "Vaccinations", icon: "syringe.fill", color: .purple)
                        }
                        TrackerQuickCard(title: "Recovery", icon: "heart.text.square.fill", color: .green)
                    }
                    .padding(.horizontal, 24)
                }
                
                // Recent Visits
                VStack(alignment: .leading, spacing: 20) {
                    Text("Recent Visits")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .padding(.horizontal, 32)
                    
                    if viewModel.visits.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 40))
                                .foregroundColor(accentColor.opacity(0.3))
                            Text("No recent visits recorded")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                    } else {
                        // List visits
                    }
                }
                
                Spacer(minLength: 50)
            }
        }
        .background(bgColor.ignoresSafeArea())
    }
}

struct TrackerQuickCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle().fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 18))
            }
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(red: 0.28, green: 0.24, blue: 0.20))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 28).fill(Color.white))
        .shadow(color: Color.black.opacity(0.02), radius: 10, y: 5)
    }
}
