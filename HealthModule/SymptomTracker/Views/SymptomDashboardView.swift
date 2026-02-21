import SwiftUI

struct SymptomDashboardView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = SymptomViewModel()
    @State private var showingAddSymptom = false
    
    // Luxury Palette
    let bgColor = Color(red: 0.98, green: 0.97, blue: 0.94)
    let accentColor = Color(red: 0.85, green: 0.56, blue: 0.43)
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
    
    var body: some View {
        ZStack(alignment: .top) {
            bgColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Header Section
                    HStack(alignment: .top, spacing: 20) {
                        // Back Button (Leading Side)
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(deepText)
                                .padding(12)
                                .background(Circle().fill(Color.white))
                                .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Symptom Care")
                                .font(.system(size: 34, weight: .bold, design: .serif))
                                .foregroundColor(deepText)
                            
                            Text("Tracking health patterns locally")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(deepText.opacity(0.4))
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    
                    // Health Perspective Card (Premium Insight)
                    healthInsightCard
                    
                    // NEW: Visual Health Trend Graph
                    if !viewModel.symptomLogs.isEmpty {
                        healthTrendGraph
                    }
                    
                    // Quick Action: Diagnostic Log
                    quickActionPanel
                    
                    // History Section
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Medical History")
                                .font(.system(size: 20, weight: .bold, design: .serif))
                                .foregroundColor(deepText)
                            Spacer()
                            if !viewModel.symptomLogs.isEmpty {
                                Button("Clear All") {
                                    viewModel.clearAllSymptoms()
                                }
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red.opacity(0.7))
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        if viewModel.symptomLogs.isEmpty {
                            emptyStateView
                        } else {
                            VStack(spacing: 16) {
                                ForEach(Array(viewModel.symptomLogs.reversed())) { log in
                                    SymptomProfessionalCard(log: log)
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
                Button(action: { showingAddSymptom = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus")
                        Text("Record Symptom")
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
        .navigationBarHidden(true) // We use our custom header
        .sheet(isPresented: $showingAddSymptom) {
            AddSymptomLogView(viewModel: viewModel)
        }
    }
    
    // MARK: - Premium Analytics Card
    private var healthInsightCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(accentColor)
                Text("Health Insight")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(deepText.opacity(0.6))
                Spacer()
                Text("OFFLINE MODE")
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(4)
            }
            
            Text(insightMessage)
                .font(.system(size: 18, weight: .medium, design: .serif))
                .foregroundColor(deepText)
                .lineSpacing(4)
            
            HStack(spacing: 20) {
                insightStat(label: "LOGS", value: "\(viewModel.symptomLogs.count)")
                insightStat(label: "AVG SEVERITY", value: String(format: "%.1f", averageSeverity))
                insightStat(label: "STATUS", value: healthStatus)
            }
            .padding(.top, 8)
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 36)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 30, y: 15)
        )
        .padding(.horizontal, 24)
    }
    
    private var quickActionPanel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(SymptomCategory.allCases, id: \.self) { category in
                    Button(action: { /* Quick Filter or Log */ }) {
                        Text(category.rawValue)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(accentColor)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(accentColor.opacity(0.08))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle().fill(accentColor.opacity(0.03)).frame(width: 140, height: 140)
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 50))
                    .foregroundColor(accentColor.opacity(0.2))
            }
            Text("No health logs recorded yet")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(deepText.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func insightStat(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(deepText.opacity(0.4))
            Text(value)
                .font(.system(size: 16, weight: .black))
                .foregroundColor(deepText)
        }
    }
    
    // MARK: - Logic Helpers
    private var averageSeverity: Double {
        guard !viewModel.symptomLogs.isEmpty else { return 0 }
        let total = viewModel.symptomLogs.reduce(0) { $0 + Double($1.severity) }
        return total / Double(viewModel.symptomLogs.count)
    }
    
    private var insightMessage: String {
        if viewModel.symptomLogs.isEmpty {
            return "Start logging symptoms to see AI-driven health insights here."
        } else if averageSeverity > 7 {
            return "High severity detected. Consider consulting your vet with these logs."
        } else {
            return "Your pet's health pattern looks stable based on recent observations."
        }
    }
    
    private var healthStatus: String {
        if viewModel.symptomLogs.isEmpty { return "STABLE" }
        return averageSeverity > 7 ? "CONCERN" : "GOOD"
    }
    
    // MARK: - Visual Components
    private var healthTrendGraph: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Severity Trend (Last 7 Entries)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(deepText.opacity(0.5))
            
            HStack(alignment: .bottom, spacing: 12) {
                let lastLogs = Array(viewModel.symptomLogs.suffix(7))
                ForEach(lastLogs) { log in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(LinearGradient(colors: [graphColor(for: log.severity), graphColor(for: log.severity).opacity(0.5)], startPoint: .top, endPoint: .bottom))
                            .frame(height: CGFloat(log.severity) * 15)
                        
                        Text(log.date.formatted(Date.FormatStyle().month(.abbreviated).day()))
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(deepText.opacity(0.4))
                    }
                }
            }
            .frame(height: 180, alignment: .bottom)
        }
        .padding(24)
        .background(RoundedRectangle(cornerRadius: 32).fill(Color.white).shadow(color: Color.black.opacity(0.02), radius: 10, y: 5))
        .padding(.horizontal, 24)
    }
    
    private func graphColor(for severity: Int) -> Color {
        if severity > 7 { return .red }
        if severity > 4 { return .orange }
        return .green
    }
}

struct SymptomProfessionalCard: View {
    let log: SymptomLog
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
    let accentColor = Color(red: 0.85, green: 0.56, blue: 0.43)
    
    var body: some View {
        HStack(spacing: 16) {
            // Severity Indicator Ring
            ZStack {
                Circle()
                    .stroke(severityColor.opacity(0.1), lineWidth: 4)
                    .frame(width: 48, height: 48)
                Text("\(log.severity)")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(severityColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(log.symptomName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(deepText)
                    Spacer()
                    Text(log.category.rawValue)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(accentColor.opacity(0.1))
                        .foregroundColor(accentColor)
                        .clipShape(Capsule())
                }
                
                Text(log.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 12))
                    .foregroundColor(deepText.opacity(0.4))
                
                if let notes = log.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.system(size: 13))
                        .foregroundColor(deepText.opacity(0.7))
                        .padding(.top, 4)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.02), radius: 10, y: 5)
        )
    }
    
    private var severityColor: Color {
        if log.severity > 7 { return .red }
        if log.severity > 4 { return .orange }
        return .green
    }
}

struct AddSymptomLogView: View {
    @Environment(\.dismiss) var dismiss
    var viewModel: SymptomViewModel
    
    @State private var name = ""
    @State private var category: SymptomCategory = .digestive
    @State private var severity = 5.0
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medical Details")) {
                    TextField("Symptom (e.g. Lethargy)", text: $name)
                    Picker("Category", selection: $category) {
                        ForEach(SymptomCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Severity Level: \(Int(severity))/10")
                            .font(.system(size: 14, weight: .bold))
                        Slider(value: $severity, in: 1...10, step: 1)
                            .accentColor(.red)
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Observations")) {
                    TextEditor(text: $notes)
                        .frame(height: 120)
                        .overlay(
                            Group {
                                if notes.isEmpty {
                                    Text("Add any specific details for your vet...")
                                        .foregroundColor(.gray.opacity(0.5))
                                        .padding(.leading, 4)
                                        .padding(.top, 8)
                                }
                            },
                            alignment: .topLeading
                        )
                }
            }
            .navigationTitle("New Medical Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Entry") {
                        let log = SymptomLog(
                            date: Date(),
                            symptomName: name,
                            category: category,
                            severity: Int(severity),
                            notes: notes
                        )
                        viewModel.addSymptomLog(log)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .fontWeight(.bold)
                }
            }
        }
    }
}

// MARK: - Navigation Extensions
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
