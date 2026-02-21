import SwiftUI

struct FeedingDashboardView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(LocalStorageService.self) var storage
    @State private var viewModel: FeedingViewModel?
    @State private var showingAdd = false
    
    // Form state
    @State private var mealType = "Morning"
    @State private var foodName = ""
    @State private var amount = ""
    
    let bgColor = Color(red: 0.98, green: 0.97, blue: 0.94)
    let accentColor = Color(red: 0.9, green: 0.7, blue: 0.5)
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
                            Text("Feeding Log")
                                .font(.system(size: 34, weight: .bold, design: .serif))
                                .foregroundColor(deepText)
                            Text("Nutrition for \(pet.name)")
                                .font(.system(size: 14))
                                .foregroundColor(deepText.opacity(0.5))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    
                    if let viewModel = viewModel {
                        // Meals List
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Recent Meals")
                                .font(.system(size: 20, weight: .bold, design: .serif))
                                .padding(.horizontal, 30)
                            
                            if viewModel.records.isEmpty {
                                Text("No meals logged yet.")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 30)
                            } else {
                                VStack(spacing: 16) {
                                    ForEach(viewModel.records) { record in
                                        MealRow(title: "\(record.mealType) Feeding", time: record.time.formatted(date: .omitted, time: .shortened), status: record.amount, icon: "fork.knife.circle.fill")
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
            
            // Add Button
            VStack {
                Spacer()
                Button(action: { showingAdd = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                        Text("Log Meal")
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
                viewModel = FeedingViewModel(modelContext: modelContext)
            }
        }
        .sheet(isPresented: $showingAdd) {
            VStack(spacing: 30) {
                Text("New Meal")
                    .font(.headline)
                
                Picker("Type", selection: $mealType) {
                    Text("Morning").tag("Morning")
                    Text("Lunch").tag("Lunch")
                    Text("Dinner").tag("Dinner")
                    Text("Snack").tag("Snack")
                }
                .pickerStyle(.segmented)
                
                TextField("Food Name (e.g. Kibble)", text: $foodName)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(12)
                
                TextField("Amount (e.g. 200g)", text: $amount)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(12)
                
                Button("Save Meal") {
                    viewModel?.addRecord(petId: pet.id, mealType: mealType, amount: amount, foodName: foodName, time: Date())
                    foodName = ""
                    amount = ""
                    showingAdd = false
                }
                .disabled(foodName.isEmpty || amount.isEmpty)
                .buttonStyle(.borderedProminent)
            }
            .padding(40)
            .presentationDetents([.medium])
        }
    }
}

struct MealRow: View {
    let title: String
    let time: String
    let status: String
    let icon: String
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
    let accentColor = Color(red: 0.9, green: 0.7, blue: 0.5)
    
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
                Text("\(time) • \(status)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            Spacer()
            if status == "Completed" {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white))
        .shadow(color: Color.black.opacity(0.02), radius: 10, y: 5)
    }
}
