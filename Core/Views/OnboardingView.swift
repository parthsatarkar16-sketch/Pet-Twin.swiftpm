import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isCompleted: Bool
    
    var currentTheme: OnboardingTheme {
        onboardingScreens[currentPage].theme
    }
    
    var body: some View {
        ZStack {
            // Base Background
            currentTheme.backgroundColor
                .ignoresSafeArea()
                .animation(Animation.easeInOut(duration: 0.6), value: currentPage)
            
            // Background Split (Artist Style)
            if let splitColor = currentTheme.splitBackgroundColor {
                VStack {
                    Spacer()
                    splitColor
                        .frame(height: 350)
                }
                .ignoresSafeArea()
                .transition(.move(edge: .bottom))
                .animation(Animation.easeInOut(duration: 0.6), value: currentPage)
            }
            
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingScreens.count, id: \.self) { index in
                    OnboardingScreenView(currentPage: $currentPage, screen: onboardingScreens[index], isFirst: index == 0, isLast: index == onboardingScreens.count - 1) {
                        withAnimation {
                            isCompleted = true
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Navigation Elements
            VStack {
                HStack {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Rectangle().fill(Color.black.opacity(0.8)).frame(width: 20, height: 2)
                        Rectangle().fill(Color.black.opacity(0.8)).frame(width: 20, height: 2)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                Spacer()
            }
        }
        .preferredColorScheme(.light)
    }
}

struct OnboardingScreenView: View {
    @Binding var currentPage: Int
    let screen: OnboardingScreen
    let isFirst: Bool
    let isLast: Bool
    let onComplete: () -> Void
    
    @State private var animate = false
    @State private var hoverEffect = false
    
    var body: some View {
        ZStack {
            // 1. Texture & Vertical Title Base Layer
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Text(screen.verticalTitle)
                        .font(.system(size: geo.size.width * 0.5, weight: .black, design: .rounded))
                        .foregroundColor(screen.theme.accentColor.opacity(0.4))
                        .rotationEffect(.degrees(-90))
                        .fixedSize()
                        .offset(x: -geo.size.width * 0.4, y: geo.size.height * 0.05)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // 2. Hero Content Layer
            VStack(spacing: 0) {
                // Top Editorial Taglines
                VStack(spacing: 8) {
                    Text(screen.topText.uppercased())
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .kerning(4)
                        .foregroundColor(screen.theme.textColor.opacity(0.6))
                    
                    Text(screen.subHeadline.lowercased())
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .lineSpacing(-10)
                        .multilineTextAlignment(.center)
                        .foregroundColor(screen.theme.textColor)
                }
                .padding(.top, 80)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)
                
                Spacer()
                
                // The "Settle" - Central Hero Image
                ZStack {
                    if isFirst {
                        // Designer Frame for 1st screen
                        HandDrawnFrame()
                            .stroke(screen.theme.textColor.opacity(0.15), lineWidth: 3)
                            .frame(width: 330, height: 430)
                            .rotationEffect(.degrees(-1))
                    }
                    
                    Image(screen.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 400)
                        .clipShape(isFirst ? AnyShape(SpeechBubbleFrame()) : AnyShape(RoundedRectangle(cornerRadius: 40, style: .continuous)))
                        .overlay(
                            isFirst ? AnyShape(SpeechBubbleFrame()).stroke(Color.black.opacity(0.05), lineWidth: 1) : AnyShape(RoundedRectangle(cornerRadius: 40, style: .continuous)).stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 40, x: 0, y: 20)
                        .rotationEffect(.degrees(hoverEffect ? 1 : -1))
                }
                .scaleEffect(animate ? 1 : 0.8)
                .onAppear {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        hoverEffect = true
                    }
                }
                
                Spacer()
                
                // 3. Footer Interaction Layer
                VStack(spacing: 30) {
                    Text(screen.headline)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(screen.theme.textColor.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                    
                    footerButton
                }
                .padding(.bottom, 70)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 30)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.8).delay(0.2)) {
                animate = true
            }
        }
    }
    
    private var footerButton: some View {
        Button(action: {
            if !isLast {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    currentPage += 1
                }
            } else {
                onComplete()
            }
        }) {
            HStack(spacing: 12) {
                Text(screen.footerText.lowercased())
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .bold))
            }
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(screen.theme.textColor)
            .padding(.horizontal, 32)
            .padding(.vertical, 18)
            .background(
                ZStack {
                    // Premium Glassmorphism
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    Capsule()
                        .stroke(screen.theme.textColor.opacity(0.2), lineWidth: 1.5)
                }
            )
            .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
        }
    }
}


// Custom Shape for the Speech Bubble Image Mask
struct SpeechBubbleFrame: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: 10, y: 10))
        path.addCurve(to: CGPoint(x: w-10, y: 8), control1: CGPoint(x: w/2, y: -5), control2: CGPoint(x: w/2 + 20, y: 5))
        path.addCurve(to: CGPoint(x: w+2, y: h*0.8), control1: CGPoint(x: w+5, y: h/2), control2: CGPoint(x: w-5, y: h/2 + 30))
        
        // The "Tail" of the bubble
        path.addLine(to: CGPoint(x: w * 0.9, y: h - 10))
        path.addCurve(to: CGPoint(x: w * 0.4, y: h - 15), control1: CGPoint(x: w/2 + 50, y: h+5), control2: CGPoint(x: w/2, y: h-10))
        
        path.addCurve(to: CGPoint(x: 10, y: 10), control1: CGPoint(x: -5, y: h/2), control2: CGPoint(x: 5, y: h/3))
        
        return path
    }
}

struct Scribble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 20))
        path.addCurve(to: CGPoint(x: rect.width, y: 20), control1: CGPoint(x: rect.width/3, y: 0), control2: CGPoint(x: 2*rect.width/3, y: 40))
        path.addCurve(to: CGPoint(x: 0, y: 40), control1: CGPoint(x: 2*rect.width/3, y: 0), control2: CGPoint(x: rect.width/3, y: 40))
        return path
    }
}

struct HandDrawnFrame: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + 5, y: rect.minY + 2))
        path.addCurve(to: CGPoint(x: rect.maxX - 5, y: rect.minY + 5), control1: CGPoint(x: rect.midX, y: rect.minY - 5), control2: CGPoint(x: rect.midX + 50, y: rect.minY + 10))
        path.addCurve(to: CGPoint(x: rect.maxX + 2, y: rect.maxY - 10), control1: CGPoint(x: rect.maxX + 8, y: rect.midY), control2: CGPoint(x: rect.maxX - 5, y: rect.midY + 40))
        path.addCurve(to: CGPoint(x: rect.minX + 8, y: rect.maxY + 3), control1: CGPoint(x: rect.midX, y: rect.maxY + 10), control2: CGPoint(x: rect.minX + 40, y: rect.maxY - 5))
        path.addCurve(to: CGPoint(x: rect.minX + 5, y: rect.minY + 2), control1: CGPoint(x: rect.minX - 10, y: rect.midY), control2: CGPoint(x: rect.minX + 5, y: rect.midY - 20))
        return path
    }
}

struct AnyShape: Shape {
    private let _path: @Sendable (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        self._path = { rect in shape.path(in: rect) }
    }

    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}
