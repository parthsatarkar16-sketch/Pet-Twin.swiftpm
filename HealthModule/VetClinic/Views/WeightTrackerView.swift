import SwiftUI

struct WeightTrackerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(LocalStorageService.self) var storage
    @State var viewModel = VetClinicViewModel()
    @State private var showingAddWeight = false
    
    // Luxury Palette
    let bgColor = Color(red: 0.98, green: 0.97, blue: 0.94)
    let accentColor = Color(red: 0.43, green: 0.56, blue: 0.85) // Medical Blue-ish for Weight
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
    
    var body: some View {
        ZStack(alignment: .top) {
            bgColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Custom Header
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
                            Text("Weight Center")
                                .font(.system(size: 34, weight: .bold, design: .serif))
                                .foregroundColor(deepText)
                            Text("Growth & Physical Health")
                                .font(.system(size: 14))
                                .foregroundColor(deepText.opacity(0.5))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    
                    // Analytics Section
                    VStack(spacing: 24) {
                        annualSnapshotCard
                        
                        // NEW: Ideal Weight Reference Guide
                        referenceGuideCard
                        
                        if !viewModel.weightRecords.isEmpty {
                            weightTrendChart
                        }
                    }
                    
                    // Main Analytics Card (Historical Context)
                    weightHeroCard
                    
                    // History List
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Recording History")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .padding(.horizontal, 30)
                        
                        if viewModel.weightRecords.isEmpty {
                            emptyStateView
                        } else {
                            VStack(spacing: 16) {
                                ForEach(viewModel.weightRecords.reversed()) { record in
                                    WeightRecordRow(record: record)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            
            // Floating Action Button
            VStack {
                Spacer()
                Button(action: { showingAddWeight = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus")
                        Text("Log Weight")
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
        .sheet(isPresented: $showingAddWeight) {
            AddWeightView(viewModel: viewModel)
        }
    }
    
    // MARK: - Components
    
    private var weightHeroCard: some View {
        VStack(spacing: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("CURRENT WEIGHT")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(deepText.opacity(0.4))
                        .kerning(1)
                    
                    HStack(alignment: .bottom, spacing: 4) {
                        Text(currentWeightString)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(deepText)
                        Text(currentUnit)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(deepText.opacity(0.4))
                            .padding(.bottom, 8)
                    }
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.1))
                        .frame(width: 80, height: 80)
                    Image(systemName: "scalemass.fill")
                        .font(.system(size: 30))
                        .foregroundColor(accentColor)
                }
            }
            
            Divider().background(Color.black.opacity(0.05))
            
            HStack(spacing: 40) {
                statItem(label: "CHANGE", value: weightChangeInfo, color: weightChangeColor)
                statItem(label: "STATUS", value: weightStatus, color: .green)
                statItem(label: "YEAR AVG", value: annualAverageString, color: accentColor)
            }
        }
        .padding(32)
        .background(RoundedRectangle(cornerRadius: 36).fill(Color.white).shadow(color: Color.black.opacity(0.03), radius: 20, y: 10))
        .padding(.horizontal, 24)
    }
    
    // MARK: - Veterinary Reference Guide
    struct Benchmark {
        let age: String
        let minWeight: Double
        let maxWeight: Double
    }
    
    private let dogBenchmarks = [
        Benchmark(age: "0-6m", minWeight: 5, maxWeight: 15),
        Benchmark(age: "6-12m", minWeight: 15, maxWeight: 25),
        Benchmark(age: "1-5y", minWeight: 25, maxWeight: 35),
        Benchmark(age: "5y+", minWeight: 25, maxWeight: 32)
    ]
    
    private let catBenchmarks = [
        Benchmark(age: "0-6m", minWeight: 1, maxWeight: 3),
        Benchmark(age: "6-12m", minWeight: 3, maxWeight: 5),
        Benchmark(age: "1-5y", minWeight: 4, maxWeight: 6),
        Benchmark(age: "5y+", minWeight: 3.5, maxWeight: 5.5)
    ]
    
    private var referenceGuideCard: some View {
        let pet = storage.currentPet
        let species = pet?.species ?? "Dog"
        
        return VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Veterinary Growth Guide")
                        .font(.system(size: 16, weight: .bold, design: .serif))
                    Text("Ideal weight benchmarks for your \(species)")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: species == "Dog" ? "dog.fill" : "cat.fill")
                    .font(.system(size: 24))
                    .foregroundColor(accentColor.opacity(0.3))
            }
            
            VStack(spacing: 12) {
                let benchmarks = species == "Dog" ? dogBenchmarks : catBenchmarks
                
                ForEach(benchmarks, id: \.age) { benchmark in
                    let isCurrentAge = checkAgeMatch(ageLabel: benchmark.age, petAge: pet?.age ?? 0)
                    
                    HStack {
                        Text(benchmark.age)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(isCurrentAge ? accentColor : deepText)
                            .frame(width: 80, alignment: .leading)
                        
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.black.opacity(0.03))
                                .frame(height: 8)
                            
                            Capsule()
                                .fill(isCurrentAge ? accentColor : accentColor.opacity(0.2))
                                .frame(width: CGFloat(benchmark.maxWeight) * (species == "Dog" ? 4 : 20), height: 8)
                        }
                        
                        Text("\(benchmark.minWeight)-\(benchmark.maxWeight) \(currentUnit)")
                            .font(.system(size: 11, weight: .black, design: .monospaced))
                            .foregroundColor(isCurrentAge ? accentColor : deepText.opacity(0.6))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isCurrentAge ? accentColor.opacity(0.08) : Color.clear)
                    .cornerRadius(12)
                }
            }
            
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                Text("Estimates based on medium-sized breeds. Individual needs vary.")
                    .font(.system(size: 9, weight: .bold))
            }
            .foregroundColor(deepText.opacity(0.3))
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.02), radius: 10, y: 5)
        )
        .padding(.horizontal, 24)
    }
    
    private func checkAgeMatch(ageLabel: String, petAge: Int) -> Bool {
        if ageLabel == "0-6m" { return petAge == 0 } // Roughly
        if ageLabel == "6-12m" { return petAge == 0 } // Roughly
        if ageLabel == "1-5y" { return petAge >= 1 && petAge <= 5 }
        if ageLabel == "5y+" { return petAge > 5 }
        return false
    }
    private var annualSnapshotCard: some View {
        let pet = storage.currentPet
        let species = pet?.species ?? "Pet"
        
        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.orange)
                    Text("ANNUAL WELLNESS OVERVIEW")
                        .font(.system(size: 11, weight: .black))
                        .kerning(1)
                }
                .foregroundColor(deepText.opacity(0.6))
                
                Spacer()
                
                Text("VET VERIFIED")
                    .font(.system(size: 8, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(4)
            }
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("YEAR MAX")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.secondary)
                    Text(yearMaxString)
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundColor(deepText)
                    Text(currentUnit).font(.system(size: 10, weight: .bold)).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Rectangle()
                    .fill(Color.black.opacity(0.05))
                    .frame(width: 1, height: 40)
                    .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("YEAR MIN")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.secondary)
                    Text(yearMinString)
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundColor(deepText)
                    Text(currentUnit).font(.system(size: 10, weight: .bold)).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(accentColor)
                VStack(alignment: .leading, spacing: 2) {
                    Text(yearlyInsightMessage)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(deepText)
                    Text("Total recorded for this calendar year.")
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(accentColor.opacity(0.08))
            .cornerRadius(16)
            
            // Explicit Summary Text
            Text("In \(String(Calendar.current.component(.year, from: Date()))), your \(species.lowercased()) has tracked a weight range from \(yearMinString)\(currentUnit) to \(yearMaxString)\(currentUnit).")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(deepText.opacity(0.6))
                .padding(.top, 4)
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 36)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 25, y: 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 36)
                        .stroke(accentColor.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal, 24)
    }
    
    private var weightTrendChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weight Growth Curve")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(deepText.opacity(0.5))
            
            HStack(alignment: .bottom, spacing: 12) {
                let lastRecords = Array(viewModel.weightRecords.suffix(7))
                let minWeight = lastRecords.map { $0.weight }.min() ?? 0
                let maxWeight = lastRecords.map { $0.weight }.max() ?? 1
                let range = max(maxWeight - minWeight, 1.0)
                
                ForEach(lastRecords) { record in
                    VStack(spacing: 8) {
                        let normalizedHeight = (record.weight - minWeight) / range
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(colors: [accentColor, accentColor.opacity(0.4)], startPoint: .top, endPoint: .bottom))
                            .frame(height: 50 + (normalizedHeight * 100))
                        
                        Text(record.date.formatted(Date.FormatStyle().month(.abbreviated).day()))
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(deepText.opacity(0.4))
                    }
                }
            }
            .frame(height: 200, alignment: .bottom)
        }
        .padding(24)
        .background(RoundedRectangle(cornerRadius: 32).fill(Color.white).shadow(color: Color.black.opacity(0.02), radius: 10, y: 5))
        .padding(.horizontal, 24)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "plus.viewfinder")
                .font(.system(size: 40))
                .foregroundColor(accentColor.opacity(0.2))
            Text("No weight records found")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(deepText.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func statItem(label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(deepText.opacity(0.4))
            Text(value)
                .font(.system(size: 14, weight: .black))
                .foregroundColor(color)
        }
    }
    
    // MARK: - Logic
    
    private var currentWeightString: String {
        guard let last = viewModel.weightRecords.last else { return "0.0" }
        return String(format: "%.1f", last.weight)
    }
    
    private var currentUnit: String {
        viewModel.weightRecords.last?.unit ?? "kg"
    }
    
    private var weightChangeInfo: String {
        guard viewModel.weightRecords.count >= 2 else { return "N/A" }
        let last = viewModel.weightRecords.last!.weight
        let previous = viewModel.weightRecords[viewModel.weightRecords.count - 2].weight
        let diff = last - previous
        let prefix = diff >= 0 ? "+" : ""
        return "\(prefix)\(String(format: "%.1f", diff))"
    }
    
    private var weightChangeColor: Color {
        guard viewModel.weightRecords.count >= 2 else { return deepText }
        let diff = viewModel.weightRecords.last!.weight - viewModel.weightRecords[viewModel.weightRecords.count - 2].weight
        return diff >= 0 ? .green : .red
    }
    
    private var weightStatus: String {
        if viewModel.weightRecords.isEmpty { return "READY" }
        return "TRACKING"
    }

    // MARK: - Annual Statistics Logic
    
    private var thisYearRecords: [WeightRecord] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return viewModel.weightRecords.filter { Calendar.current.component(.year, from: $0.date) == currentYear }
    }
    
    private var annualAverageString: String {
        guard !thisYearRecords.isEmpty else { return "0.0" }
        let sum = thisYearRecords.reduce(0) { $0 + $1.weight }
        return String(format: "%.1f", sum / Double(thisYearRecords.count))
    }
    
    private var yearMaxString: String {
        guard !thisYearRecords.isEmpty else { return "0.0" }
        let max = thisYearRecords.map { $0.weight }.max() ?? 0
        return String(format: "%.1f", max)
    }
    
    private var yearMinString: String {
        guard !thisYearRecords.isEmpty else { return "0.0" }
        let min = thisYearRecords.map { $0.weight }.min() ?? 0
        return String(format: "%.1f", min)
    }
    
    private var yearlyInsightMessage: String {
        guard thisYearRecords.count >= 2 else { return "Stay consistent" }
        let first = thisYearRecords.first!.weight
        let last = thisYearRecords.last!.weight
        let diff = last - first
        
        if abs(diff) < 0.5 {
            return "Status: Maintaining"
        } else if diff > 0 {
            return "Stable Growth"
        } else {
            return "Weight Reduction"
        }
    }
}

struct WeightRecordRow: View {
    let record: WeightRecord
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.date.formatted(date: .long, time: .omitted))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(deepText)
                Text(record.date.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(String(format: "%.1f", record.weight)) \(record.unit)")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundColor(deepText)
        }
        .padding(24)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white))
        .shadow(color: Color.black.opacity(0.01), radius: 10, y: 5)
    }
}

struct AddWeightView: View {
    @Environment(\.dismiss) var dismiss
    var viewModel: VetClinicViewModel
    
    @State private var weight = ""
    @State private var unit = "kg"
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Measurement")) {
                    HStack {
                        TextField("Weight", text: $weight)
                            .keyboardType(.decimalPad)
                        Picker("", selection: $unit) {
                            Text("kg").tag("kg")
                            Text("lbs").tag("lbs")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 100)
                    }
                }
                
                Section(header: Text("Entry Date")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Log New Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let w = Double(weight) {
                            let record = WeightRecord(date: date, weight: w, unit: unit)
                            viewModel.addWeightRecord(record)
                            dismiss()
                        }
                    }
                    .disabled(weight.isEmpty)
                    .fontWeight(.bold)
                }
            }
        }
    }
}
