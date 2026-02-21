import SwiftUI

struct AddVaccinationView: View {
    @Environment(\.dismiss) var dismiss
    var viewModel: VaccinationViewModel
    let petId: UUID
    let petType: String
    
    @State private var name = ""
    @State private var dateGiven = Date()
    @State private var boosterInterval = 12
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    TextField("Vaccine Name", text: $name)
                    Picker("Booster Interval", selection: $boosterInterval) {
                        Text("6 Months").tag(6)
                        Text("1 Year").tag(12)
                        Text("3 Years").tag(36)
                    }
                }
                
                Section("Dates") {
                    DatePicker("Date Administered", selection: $dateGiven, displayedComponents: .date)
                    Text("Auto-calculated Next Due: \(nextDueDateForecast.formatted(date: .long, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("New Vaccination")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addRecord(
                            name: name,
                            petType: petType,
                            dateGiven: dateGiven,
                            boosterInterval: boosterInterval,
                            notes: notes,
                            petId: petId
                        )
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private var nextDueDateForecast: Date {
        VaccinationScheduleGenerator.calculateNextBooster(from: dateGiven, intervalMonths: boosterInterval)
    }
}
