import SwiftUI

struct ScoreRing: View {
    var progress: Double // 0 to 1
    var color: Color = .blue
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.1), lineWidth: 12)
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(color, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(), value: progress)
            
            VStack {
                Text("\(Int(progress * 100))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text("Score")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.secondary)
            }
        }
    }
}
