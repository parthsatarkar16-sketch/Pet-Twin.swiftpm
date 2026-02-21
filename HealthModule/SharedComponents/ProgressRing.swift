import SwiftUI

struct ProgressRing: View {
    var progress: CGFloat
    var color: Color = .blue
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.1), lineWidth: 8)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(), value: progress)
        }
    }
}
