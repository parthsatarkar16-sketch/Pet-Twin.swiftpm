import SwiftUI

struct WalkTrackerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(LocalStorageService.self) var storage
    @State private var viewModel: WalkViewModel?
    @State private var showingAdd = false
    
    // Form state
    @State private var walkTitle: String = ""
    @State private var distance: String = ""
    @State private var duration: String = ""
    
    let bgColor = Color(red: 0.98, green: 0.97, blue: 0.94)
    let accentColor = Color(red: 0.6, green: 0.7, blue: 0.5)
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
    
    var body: some View {
        let pet = storage.currentPet ?? Pet(name: "Pet", species: "Dog", breed: "Unknown", age: 0, gender: "Other", personality: "")
        
        ZStack(alignment: .top) {
            bgColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Header
                    HStack(spacing: 20) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(deepText)
                                .padding(12)
                                .background(Circle().fill(Color.white))
                                .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Walk Tracker")
                                .font(.system(size: 34, weight: .bold, design: .serif))
                                .foregroundColor(deepText)
                            Text("Activity Log for \(pet.name)")
                                .font(.system(size: 14))
                                .foregroundColor(deepText.opacity(0.5))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    
                    if let viewModel = viewModel {
                        // Route Summary Card
                        VStack(spacing: 20) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("TODAY'S DISTANCE")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(.secondary)
                                    Text(String(format: "%.1f KM", viewModel.totalDistanceToday))
                                        .font(.system(size: 24, weight: .black))
                                }
                                Spacer()
                                Image(systemName: "figure.walk.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(accentColor)
                            }
                            Divider()
                            HStack {
                                WalkStat(label: "STEPS", value: "\(viewModel.totalStepsToday)")
                                Spacer()
                                WalkStat(label: "RECORDS", value: "\(viewModel.records.count)")
                            }
                        }
                        .padding(32)
                        .background(RoundedRectangle(cornerRadius: 32).fill(Color.white))
                        .padding(.horizontal, 24)
                        
                        // History
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Recent Strolls")
                                .font(.system(size: 20, weight: .bold, design: .serif))
                                .padding(.horizontal, 30)
                            
                            if viewModel.records.isEmpty {
                                Text("No walks recorded yet.")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 30)
                            } else {
                                VStack(spacing: 16) {
                                    ForEach(viewModel.records) { record in
                                        WalkRow(title: record.title, detail: "\(String(format: "%.1f", record.distance)) km • \(record.duration) min", icon: "figure.walk.circle.fill")
                                            .contextMenu {
                                                Button(role: .destructive) {
                                                    viewModel.deleteRecord(record)
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    } else {
                        ProgressView().padding(.top, 50)
                    }
                    
                    Spacer(minLength: 120)
                }
            }
            
            // Start Walk Button
            VStack {
                Spacer()
                Button(action: { showingAdd = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "play.fill")
                        Text("Record New Walk")
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 18)
                    .background(accentColor)
                    .clipShape(Capsule())
                    .shadow(color: accentColor.opacity(0.4), radius: 20, y: 10)
                }
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if viewModel == nil {
                viewModel = WalkViewModel(modelContext: modelContext)
            }
        }
        .sheet(isPresented: $showingAdd) {
            VStack(spacing: 30) {
                Text("New Walk")
                    .font(.headline)
                
                TextField("Walk Name (e.g. Park Run)", text: $walkTitle)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(12)
                
                TextField("Distance (KM)", text: $distance)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(12)
                
                TextField("Duration (Minutes)", text: $duration)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(12)
                
                Button("Save Walk") {
                    let d = Double(distance) ?? 0
                    let dr = Int(duration) ?? 0
                    let steps = Int(d * 1400) // Rough estimation
                    let calories = Int(d * 50)  // Rough estimation
                    
                    viewModel?.addRecord(petId: pet.id, title: walkTitle.isEmpty ? "Daily Stroll" : walkTitle, distance: d, steps: steps, duration: dr, calories: calories, date: Date())
                    walkTitle = ""
                    distance = ""
                    duration = ""
                    showingAdd = false
                }
                .disabled(distance.isEmpty || duration.isEmpty)
                .buttonStyle(.borderedProminent)
            }
            .padding(40)
            .presentationDetents([.medium])
        }
    }
}

struct WalkStat: View {
    let label: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 8, weight: .black))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 14, weight: .bold))
        }
    }
}

struct WalkRow: View {
    let title: String
    let detail: String
    let icon: String
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
    let accentColor = Color(red: 0.6, green: 0.7, blue: 0.5)
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(accentColor.opacity(0.1))
                    .frame(width: 50, height: 50)
                Image(systemName: icon)
                    .foregroundColor(accentColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(deepText)
                Text(detail)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white))
        .shadow(color: Color.black.opacity(0.02), radius: 10, y: 5)
    }
}
