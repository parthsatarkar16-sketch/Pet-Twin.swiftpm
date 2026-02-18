//
//  HealthScoreCard.swift
//  GuardianTwin
//

import SwiftUI

struct HealthScoreCard: View {
    let score: Int
    @State private var animatedScore: Int = 0
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(lineWidth: 12)
                    .opacity(0.2)
                    .foregroundColor(Color.gray)
                
                // Progress circle
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(Double(animatedScore) / 100.0, 1.0)))
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                getHealthColor(Double(animatedScore) / 100.0),
                                Color.blue,
                                Color.teal
                            ]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(Angle(degrees: 270))
                    .animation(.easeInOut(duration: 1.0), value: animatedScore)
                
                // Score text
                VStack(spacing: 4) {
                    Text("\(animatedScore)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(getHealthColor(Double(animatedScore) / 100.0))
                    
                    Text("Health Score")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 200, height: 200)
            
            // Status description
            Text(getStatusDescription(score: animatedScore))
                .font(.headline)
                .foregroundColor(getHealthColor(Double(animatedScore) / 100.0))
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 5)
        )
        .onAppear {
            animateScore()
        }
    }
    
    private func animateScore() {
        // Animate from 0 to the target score
        let animationTime = 1.5
        let delayPerStep = animationTime / Double(score)
        
        for i in 0...score {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayPerStep * Double(i)) {
                animatedScore = i
            }
        }
    }
    
    private func getHealthColor(_ percentage: Double) -> Color {
        if percentage >= 0.8 {
            return Color.green
        } else if percentage >= 0.6 {
            return Color.yellow
        } else {
            return Color.red
        }
    }
    
    private func getStatusDescription(score: Int) -> String {
        if score >= 80 {
            return "Excellent Health"
        } else if score >= 60 {
            return "Good Health"
        } else if score >= 40 {
            return "Fair Health"
        } else {
            return "Needs Attention"
        }
    }
}

struct HealthScoreCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HealthScoreCard(score: 75)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}