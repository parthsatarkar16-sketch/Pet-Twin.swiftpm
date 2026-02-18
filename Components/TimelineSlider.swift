import SwiftUI

struct TimelineSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let onEditingChanged: (Double) -> Void
    
    init(value: Binding<Double>, range: ClosedRange<Double>, step: Double = 1.0, onEditingChanged: @escaping (Double) -> Void) {
        self._value = value
        self.range = range
        self.step = step
        self.onEditingChanged = onEditingChanged
    }
    
    private var markerValues: [Double] {
        var values: [Double] = []
        var current = range.lowerBound
        while current <= range.upperBound {
            values.append(current)
            current += step
        }
        return values
    }
    
    var body: some View {
        VStack(spacing: 16) {
            GeometryReader { proxy in
                ZStack {
                    trackView
                    progressView(proxy: proxy)
                    markersView(proxy: proxy)
                    thumbView(proxy: proxy)
                }
                .frame(height: 60)
            }
            .onChange(of: value) { newValue in
                onEditingChanged(newValue)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var trackView: some View {
        Capsule()
            .fill(Color(.systemGray4))
            .frame(height: 8)
    }
    
    private func progressView(proxy: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            Capsule()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.teal]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: calculateProgressWidth(proxy: proxy), height: 8)
            
            Spacer()
        }
    }
    
    private func markersView(proxy: GeometryProxy) -> some View {
        HStack {
            ForEach(markerValues, id: \.self) { marker in
                markerItem(marker: marker, proxy: proxy)
            }
        }
    }
    
    private func markerItem(marker: Double, proxy: GeometryProxy) -> some View {
        let position = ((marker - range.lowerBound) / (range.upperBound - range.lowerBound)) * 100
        let isSelected = marker == value
        
        return VStack {
            Circle()
                .fill(isSelected ? Color.white : Color(.systemGray4))
                .frame(width: isSelected ? 16 : 8, height: isSelected ? 16 : 8)
                .overlay(
                    Circle()
                        .stroke(Color.accentColor, lineWidth: isSelected ? 2 : 1)
                )
            
            if shouldShowLabel(for: marker) {
                Text("\(Int(marker))\(getUnit(for: marker))")
                    .font(.caption2)
                    .foregroundColor(isSelected ? Color.white : Color.secondary)
                    .offset(y: 8)
            }
        }
        .frame(width: 30)
        .offset(x: (position / 100) * (proxy.size.width - 60) - (proxy.size.width - 60) / 2)
    }
    
    private func thumbView(proxy: GeometryProxy) -> some View {
        HStack {
            Spacer()
            Circle()
                .fill(Color.white)
                .frame(width: 24, height: 24)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                .offset(x: calculateThumbOffset(proxy: proxy))
            Spacer()
        }
    }
    
    // MARK: - Helpers
    
    private func calculateProgressWidth(proxy: GeometryProxy) -> CGFloat {
        let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return CGFloat(progress) * (proxy.size.width - 60)
    }
    
    private func calculateThumbOffset(proxy: GeometryProxy) -> CGFloat {
        let position = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return (CGFloat(position) * (proxy.size.width - 60)) - ((proxy.size.width - 60) / 2)
    }
    
    private func shouldShowLabel(for marker: Double) -> Bool {
        let stepCount = Int((marker - range.lowerBound) / step)
        return stepCount % 2 == 0
    }
    
    private func getUnit(for marker: Double) -> String {
        if marker == 1 {
            return "mo"
        } else {
            return "mos"
        }
    }
}

struct TimelineSlider_Previews: PreviewProvider {
    static var previews: some View {
        @State var value = 6.0
        return VStack {
            TimelineSlider(
                value: $value,
                range: 1...12,
                step: 1.0
            ) { newValue in
                print("Value changed to: \(newValue)")
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}