//
//  TranslatorView.swift
//  GuardianTwin
//

import SwiftUI

struct TranslatorView: View {
    @StateObject private var translatorViewModel = TranslatorViewModel()
    @State private var recording = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "waveform.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.green)
                            .overlay(
                                Circle()
                                    .stroke(
                                        AngularGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.green, Color.blue]),
                                            center: .center
                                        ),
                                        lineWidth: 3
                                    )
                                    .frame(width: 60, height: 60)
                            )
                        
                        Text("Pet Translator")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Understand your pet's emotions and needs")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Recording Section
                    VStack(spacing: 16) {
                        Text(recording ? "Listening..." : "Tap to record")
                            .font(.headline)
                            .foregroundColor(recording ? .green : .primary)
                        
                        Button(action: {
                            recording.toggle()
                            if recording {
                                // Simulate recording for 2 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    recording = false
                                    translatorViewModel.simulateBehaviorAnalysis()
                                }
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(recording ? Color.red : Color.blue)
                                    .frame(width: 80, height: 80)
                                    .shadow(color: recording ? Color.red.opacity(0.5) : Color.blue.opacity(0.5), radius: 15, x: 0, y: 5)
                                
                                Image(systemName: recording ? "stop.fill" : "mic.fill")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Text("Record sounds and behaviors to analyze your pet's emotions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    // Waveform Animation
                    if recording {
                        WaveformView()
                            .frame(height: 100)
                            .padding(.horizontal)
                    }
                    
                    // Analysis Result
                    if let translation = translatorViewModel.currentTranslation {
                        VStack(spacing: 20) {
                            // Emotion Display
                            VStack(spacing: 12) {
                                Text(translation.detectedEmotion.rawValue)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(translatorViewModel.getEmotionColor(translation.detectedEmotion))
                                
                                Text("Emotion Detected")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Confidence Meter
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Confidence")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Text(String(format: "%.0f%%", translation.confidence * 100))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        // Background track
                                        Rectangle()
                                            .fill(Color(.systemGray4))
                                            .frame(height: 10)
                                            .cornerRadius(5)
                                        
                                        // Progress bar
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color.green,
                                                        translation.confidence > 0.7 ? Color.green : 
                                                        translation.confidence > 0.5 ? Color.yellow : Color.red
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: geometry.size.width * CGFloat(translation.confidence), height: 10)
                                            .cornerRadius(5)
                                    }
                                    .cornerRadius(5)
                                }
                                .frame(height: 10)
                            }
                            
                            // Interpretation
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Interpretation")
                                    .font(.headline)
                                
                                Text(translation.interpretedMessage)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                            
                            // Suggested Action
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Suggested Action")
                                    .font(.headline)
                                
                                Text(translation.suggestedAction)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "text.bubble.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.secondary)
                            
                            Text("No analysis yet")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Record your pet's behavior to see emotional analysis")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("Translator")
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.05, green: 0.1, blue: 0.2), Color(red: 0.1, green: 0.2, blue: 0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
    }
}

struct WaveformView: View {
    @State private var amplitudes: [Double] = Array(repeating: 0.3, count: 20)
    @State private var timer: Timer?
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<amplitudes.count, id: \.self) { index in
                RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                    .fill(Color.blue)
                    .frame(height: CGFloat(amplitudes[index]) * 80)
            }
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            stopAnimation()
        }
    }
    
    private func startAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            // Generate random amplitudes for a dynamic waveform
            for i in 0..<amplitudes.count {
                amplitudes[i] = Double.random(in: 0.1...1.0)
            }
        }
    }
    
    private func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
}

struct TranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        TranslatorView()
    }
}