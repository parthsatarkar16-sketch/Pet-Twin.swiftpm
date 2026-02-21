import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) var dismiss
    var viewModel: MedicationViewModel
    
    @State private var name = ""
    @State private var type: MedicationType = .tablet
    @State private var dosage = ""
    @State private var frequency: FrequencyType = .daily
    @State private var selectedTime = Date()
    @State private var notes = ""
    
    // Luxury Palette
    let bgColor = Color(red: 0.98, green: 0.97, blue: 0.94)
    let accentColor = Color(red: 0.85, green: 0.56, blue: 0.43)
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
    
    var body: some View {
        NavigationView {
            ZStack {
                bgColor.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        
                        // MARK: - Icon Selector (Fixed: Horizontal Scroll)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Medication Type")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(deepText.opacity(0.6))
                                .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(MedicationType.allCases, id: \.self) { t in
                                        Button(action: { type = t }) {
                                            VStack(spacing: 8) {
                                                Image(systemName: t.icon)
                                                    .font(.system(size: 20))
                                                Text(t.rawValue)
                                                    .font(.system(size: 10, weight: .bold))
                                            }
                                            .frame(width: 70, height: 75)
                                            .background(type == t ? accentColor : Color.white)
                                            .foregroundColor(type == t ? .white : deepText)
                                            .cornerRadius(20)
                                            .shadow(color: Color.black.opacity(0.05), radius: 5, y: 5)
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 5)
                            }
                        }
                        
                        // MARK: - Main Form
                        VStack(alignment: .leading, spacing: 24) {
                            inputField(label: "Medication Name", text: $name, placeholder: "e.g. Heartworm Pill")
                            inputField(label: "Dosage", text: $dosage, placeholder: "e.g. 1 Tablet / 5ml")
                            
                            // Frequency Picker (Fixed: Menu Style instead of Segmented)
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Frequency")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(deepText.opacity(0.6))
                                
                                Picker("Frequency", selection: $frequency) {
                                    ForEach(FrequencyType.allCases, id: \.self) { f in
                                        Text(f.rawValue).tag(f)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.02), radius: 5)
                            }
                            
                            // Time Picker
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Reminder Time")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(deepText.opacity(0.6))
                                
                                DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .padding(8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.02), radius: 5)
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Notes")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(deepText.opacity(0.6))
                                TextEditor(text: $notes)
                                    .frame(height: 100)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.02), radius: 5)
                            }
                        }
                        .padding(24)
                        .background(RoundedRectangle(cornerRadius: 32).fill(Color.white.opacity(0.5)))
                        .padding(.horizontal, 16) // Slightly smaller padding for container
                        
                        // Save Button
                        Button(action: saveMedication) {
                            Text("Save Medication")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(name.isEmpty ? Color.gray.opacity(0.3) : accentColor)
                                .cornerRadius(20)
                                .shadow(color: accentColor.opacity(0.3), radius: 10, y: 5)
                        }
                        .disabled(name.isEmpty)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("New Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(deepText)
                        .font(.system(size: 16, weight: .medium))
                }
            }
        }
    }
    
    private func inputField(label: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(deepText.opacity(0.6))
            TextField(placeholder, text: text)
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.02), radius: 5)
        }
    }
    
    private func saveMedication() {
        let schedules = viewModel.generateSchedules(
            for: name,
            type: type,
            doseAmount: dosage,
            frequency: frequency,
            startTime: selectedTime
        )
        
        let med = Medication(
            name: name,
            type: type,
            dosage: dosage,
            frequency: frequency,
            startDate: Date(),
            schedules: schedules,
            isActive: true
        )
        viewModel.addMedication(med)
        dismiss()
    }
}
