//
//  RiskIndicatorView.swift
//  GuardianTwin
//

import SwiftUI

struct RiskIndicatorView: View {
    let riskLevel: Double // Value between 0 and 1
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Risk Level")
                    .font(.headline)
                
                Spacer()
                
                Text(String(format: "%.0f%%", riskLevel * 100))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(getRiskColor(riskLevel))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .cornerRadius(10)
                    
                    // Progress bar
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.green,
                                    riskLevel > 0.3 ? Color.yellow : Color.green,
                                    riskLevel > 0.6 ? Color.red : Color.yellow
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(10)
                        .frame(width: geometry.size.width * CGFloat(min(riskLevel, 1.0)))
                    
                    // Threshold markers
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: geometry.size.width * 0.3)
                            .overlay(
                                GeometryReader { reader in
                                    Rectangle()
                                        .fill(Color.black.opacity(0.2))
                                        .frame(width: 1, height: reader.size.height)
                                        .offset(x: reader.size.width - 0.5, y: 0)
                                }
                            )
                        
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: geometry.size.width * 0.3)
                            .overlay(
                                GeometryReader { reader in
                                    Rectangle()
                                        .fill(Color.black.opacity(0.2))
                                        .frame(width: 1, height: reader.size.height)
                                        .offset(x: reader.size.width - 0.5, y: 0)
                                }
                            )
                        
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: geometry.size.width * 0.4)
                    }
                }
                .frame(height: 20)
            }
            
            HStack {
                Text("Low")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Moderate")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("High")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private func getRiskColor(_ risk: Double) -> Color {
        if risk < 0.3 {
            return Color.green
        } else if risk < 0.6 {
            return Color.yellow
        } else {
            return Color.red
        }
    }
}

struct RiskIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            RiskIndicatorView(riskLevel: 0.2)
            RiskIndicatorView(riskLevel: 0.5)
            RiskIndicatorView(riskLevel: 0.8)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}