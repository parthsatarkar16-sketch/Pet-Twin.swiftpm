import SwiftUI

struct CircularIconView: View {
    let icon: String
    let badgeIcon: String?
    let colors: [Color]
    
    var body: some View {
        ZStack {
            // Background Blobs - Softer and more "watercolor" style
            Circle()
                .fill(colors.first?.opacity(0.1) ?? .clear)
                .frame(width: 260, height: 260)
                .offset(x: -30, y: -20)
                .blur(radius: 30)
            
            Circle()
                .fill(colors.first?.opacity(0.08) ?? .clear)
                .frame(width: 240, height: 240)
                .offset(x: 40, y: 10)
                .blur(radius: 25)
            
            // Central White Card
            Circle()
                .fill(Color.white)
                .frame(width: 200, height: 200)
                .shadow(color: Color.black.opacity(0.05), radius: 25, x: 0, y: 12)
                .overlay(
                    ZStack {
                        Image(systemName: icon)
                            .font(.system(size: 70, weight: .regular))
                            .foregroundColor(colors.first)
                        
                        if let badge = badgeIcon {
                            Image(systemName: badge)
                                .font(.system(size: 24, weight: .bold))
                                .padding(10)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 5)
                                .offset(x: 50, y: -50)
                                .foregroundColor(colors.first)
                        }
                    }
                )
        }
    }
}
