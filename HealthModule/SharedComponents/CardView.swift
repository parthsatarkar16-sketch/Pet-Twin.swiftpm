import SwiftUI

struct MedicationCard: View {
    let medication: Medication
    let dose: DoseSchedule
    var onTaken: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 50, height: 50)
                Image(systemName: medication.type.icon)
                    .foregroundColor(.blue)
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                HStack(spacing: 6) {
                    Text(dose.dose)
                    Text("•")
                    Text(dose.time, style: .time)
                }
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if dose.status == .taken {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 28))
            } else {
                Button(action: onTaken) {
                    Text("Take")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}
