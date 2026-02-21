import SwiftUI

struct StatusBadge: View {
    let status: VaccinationStatus
    
    var color: Color {
        switch status {
        case .upToDate: return .green
        case .dueSoon: return .yellow
        case .overdue: return .red
        }
    }
    
    var body: some View {
        Text(status.rawValue.uppercased())
            .font(.system(size: 8, weight: .black))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(4)
    }
}

struct VaccineCard: View {
    let record: VaccinationRecord
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(record.vaccineName)
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                    StatusBadge(status: record.status)
                }
                
                HStack {
                    Label(record.dateGiven.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar.badge.checkmark")
                    Spacer()
                    Label("Next: \(record.nextDueDate.formatted(date: .abbreviated, time: .omitted))", systemImage: "clock.arrow.circlepath")
                        .foregroundColor(record.status == .overdue ? .red : .secondary)
                }
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white))
        .shadow(color: .black.opacity(0.02), radius: 10, y: 5)
    }
}
