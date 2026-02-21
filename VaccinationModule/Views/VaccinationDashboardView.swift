import SwiftUI
import SwiftData

struct VaccinationDashboardView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(LocalStorageService.self) var storage
    @State private var viewModel: VaccinationViewModel?
    @State private var showingAdd = false
    
    let bgColor = Color(red: 0.98, green: 0.97, blue: 0.94)
    let accentColor = Color(red: 0.54, green: 0.43, blue: 0.85) // Royal Purple
    
    // No explicit init needed here as we will set VM onAppear
    
    var body: some View {
        let pet = storage.currentPet ?? Pet(name: "Your Pet", species: "Dog", breed: "Unknown", age: 0, gender: "Other", personality: "")
        
        ZStack(alignment: .bottom) {
            bgColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    if let viewModel = viewModel {
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
                                Text("Vaccinations")
                                    .font(.system(size: 34, weight: .bold, design: .serif))
                                Text("Defense & Protection for \(pet.name)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "shield.checkered")
                                .font(.system(size: 30))
                                .foregroundColor(accentColor)
                        }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    
                    // Summary
                    vaccinationSummaryHUD(viewModel: viewModel)
                    
                    // Auto-Generate Button (Empty State)
                    if viewModel.records.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "sparkles.rectangle.stack")
                                .font(.system(size: 48))
                                .foregroundColor(accentColor.opacity(0.3))
                            Text("No records found")
                                .font(.headline)
                            Button(action: { viewModel.generateAutoSchedule(pet: pet) }) {
                                Text("Generate Smart Schedule")
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            Text("Based on \(pet.species) core vaccines")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 60)
                    }
                    
                    // Records List
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(viewModel.records) { record in
                            VaccineCard(record: record)
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
                    } else {
                        ProgressView("Initializing defenses...")
                            .padding(.top, 100)
                    }
                    
                    Spacer(minLength: 120)
                }
            }
            
            // Add Button
            if let viewModel = viewModel {
                Button(action: { showingAdd = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus")
                        Text("Manual Entry")
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 20)
                    .background(accentColor)
                    .clipShape(Capsule())
                    .shadow(color: accentColor.opacity(0.4), radius: 20, y: 10)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAdd) {
            if let viewModel = viewModel {
                AddVaccinationView(viewModel: viewModel, petId: pet.id, petType: pet.species)
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = VaccinationViewModel(modelContext: modelContext)
            }
            NotificationService.shared.requestAuthorization()
        }
    }
    
    private func vaccinationSummaryHUD(viewModel: VaccinationViewModel) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("VACCINATION STATUS")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.secondary)
                
                let hasOverdue = viewModel.records.contains(where: { $0.status == .overdue })
                let hasDueSoon = viewModel.records.contains(where: { $0.status == .dueSoon })
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(hasOverdue ? .red : (hasDueSoon ? .yellow : .green))
                        .frame(width: 8, height: 8)
                    Text(hasOverdue ? "OVERDUE" : (hasDueSoon ? "DUE SOON" : "UP TO DATE"))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(deepText)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 28).fill(Color.white))
            
            VStack(alignment: .leading, spacing: 12) {
                Text("TOTAL")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.secondary)
                Text("\(viewModel.records.count)")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(accentColor)
            }
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 28).fill(Color.white))
        }
        .padding(.horizontal, 24)
    }
    
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
}
