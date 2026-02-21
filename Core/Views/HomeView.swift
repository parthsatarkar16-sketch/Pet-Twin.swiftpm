import SwiftUI

struct HomeView: View {
    @Environment(LocalStorageService.self) var storage
    
    // Soft & Creamy Palette
    let bgColor = Color(red: 0.98, green: 0.97, blue: 0.94) // Warm Off-White/Cream
    let softAccent = Color(red: 0.95, green: 0.88, blue: 0.82) // Soft Sand/Beige
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20) // Muted Chocolate
    let warmPeach = Color(red: 0.98, green: 0.92, blue: 0.88)
    
    @State private var showingAddPet = false
    @State private var selectedStat = "ENERGY"
    
    var body: some View {
        let pet = storage.currentPet ?? Pet(name: "Pet", species: "Dog", breed: "Unknown", age: 0, gender: "Other", personality: "No bio yet")
        
        ZStack {
            // MARK: - Creamy Background
            bgColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    // MARK: - Minimalist Header with Pet Switcher
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Image("Logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .shadow(color: deepText.opacity(0.1), radius: 5, y: 2)
                            
                            Text("Your Companion")
                                .font(.system(size: 14, weight: .medium, design: .serif))
                                .foregroundColor(deepText.opacity(0.6))
                            
                            Menu {
                                ForEach(storage.allPets) { p in
                                    Button(action: { 
                                        withAnimation {
                                            storage.switchPet(to: p.id)
                                        }
                                    }) {
                                        HStack {
                                            Text(p.name)
                                            if p.id == storage.currentPetId {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                Button(action: { showingAddPet = true }) {
                                    Label("Add New Pet", systemImage: "plus.circle")
                                }
                            } label: {
                                HStack(spacing: 8) {
                                    Text(pet.name)
                                        .font(.system(size: 32, weight: .bold, design: .serif))
                                        .foregroundColor(deepText)
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(softAccent)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: { showingAddPet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(softAccent)
                                .background(Circle().fill(Color.white))
                                .shadow(color: deepText.opacity(0.05), radius: 10, y: 5)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .sheet(isPresented: $showingAddPet) {
                        PetProfileCreationView(storage: storage)
                    }

                    // MARK: - Soft Hero Gallery Card
                    ZStack(alignment: .bottomLeading) {
                        // Main Image with Soft Corners
                        Group {
                            if let data = pet.imageData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(pet.species == "Dog" ? "pet_profile_hero_pup" : "onboarding_playing_cat")
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        .frame(height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 48, style: .continuous))
                        .shadow(color: deepText.opacity(0.08), radius: 30, x: 0, y: 15)
                        
                        // Info Overlay
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Text(pet.breed)
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Capsule().fill(Color.white.opacity(0.9)))
                                    .foregroundColor(deepText)
                                
                                Image(systemName: pet.gender == "Male" ? "m.circle.fill" : "f.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color.white)
                            }
                            
                            Text("\(pet.age) Years Old")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 5)
                        }
                        .padding(32)
                    }
                    .padding(.horizontal, 24)

                    // MARK: - Vital Stats (Organic Bubbles)
                    HStack(spacing: 16) {
                        organicStatToggle(label: "ENERGY", icon: "bolt.fill", active: selectedStat == "ENERGY") {
                            withAnimation(.spring()) { selectedStat = "ENERGY" }
                        }
                        organicStatToggle(label: "HEALTH", icon: "heart.fill", active: selectedStat == "HEALTH") {
                            withAnimation(.spring()) { selectedStat = "HEALTH" }
                        }
                        organicStatToggle(label: "MOOD", icon: "face.smiling.fill", active: selectedStat == "MOOD") {
                            withAnimation(.spring()) { selectedStat = "MOOD" }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // MARK: - Dynamic Bio-Insight Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: selectedStat == "ENERGY" ? "bolt.shield.fill" : (selectedStat == "HEALTH" ? "heart.text.square.fill" : "face.dashed.fill"))
                                .font(.system(size: 20))
                                .foregroundColor(accentColor)
                            
                            Text("\(selectedStat) INSIGHT")
                                .font(.system(size: 12, weight: .black))
                                .kerning(1.2)
                                .foregroundColor(deepText.opacity(0.4))
                        }
                        
                        Text(insightText(for: selectedStat))
                            .font(.system(size: 16, weight: .medium, design: .serif))
                            .foregroundColor(deepText)
                            .lineSpacing(4)
                            .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
                            .id(selectedStat) // Force refresh animation
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(Color.white)
                            .shadow(color: deepText.opacity(0.04), radius: 20, y: 10)
                    )
                    .padding(.horizontal, 24)

                    // MARK: - Integrated Action Grid
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Discovery")
                            .font(.system(size: 18, weight: .black, design: .serif))
                            .foregroundColor(deepText)
                            .padding(.horizontal, 32)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            NavigationLink(destination: MedicationDashboardView()) {
                                luxuryActionCard(title: "Medication", sub: "Plan Active", icon: "pills.fill", color: softAccent)
                            }
                            NavigationLink(destination: VetDashboardView()) {
                                luxuryActionCard(title: "Vet Clinic", sub: "12 Nearby", icon: "cross.fill", color: Color.blue.opacity(0.4))
                            }
                            NavigationLink(destination: WeightTrackerView()) {
                                luxuryActionCard(title: "Weight Center", sub: "Annual Ledger", icon: "scalemass.fill", color: Color.orange.opacity(0.4))
                            }
                            NavigationLink(destination: DocumentsView()) {
                                luxuryActionCard(title: "Documents", sub: "Pet Records", icon: "folder.fill", color: Color.blue.opacity(0.6))
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // MARK: - Daily Routine (Soft Rounded Cards)
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Routine Updates")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundColor(deepText)
                            .padding(.horizontal, 32)
                        
                        VStack(spacing: 16) {
                            NavigationLink(destination: FeedingDashboardView()) {
                                routineRow(title: "Morning Feeding", sub: "Completed at 8:15 AM", icon: "fork.knife", color: Color(red: 0.9, green: 0.7, blue: 0.5))
                            }
                            NavigationLink(destination: WalkTrackerView()) {
                                routineRow(title: "Daily Stroll", sub: "Scheduled for 5:30 PM", icon: "figure.walk", color: Color(red: 0.6, green: 0.7, blue: 0.5))
                            }
                            NavigationLink(destination: MedicationDashboardView()) {
                                routineRow(title: "Medication", sub: "Active • Tracking", icon: "pill.fill", color: Color(red: 0.8, green: 0.6, blue: 0.6))
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 50)
                }
            }
        }
    }
    
    // MARK: - Soft Aesthetic Components
    
    private func insightText(for stat: String) -> String {
        switch stat {
        case "ENERGY":
            return "Metabolic levels are surging. Perfect time for a high-intensity session or a 20-minute walk."
        case "HEALTH":
            return "Cardiac and respiratory markers are stable. Resting vitals are within the top 5% of their breed."
        case "MOOD":
            return "Dopamine signals indicate a calm, receptive state. Ideal for training or social bonding activities."
        default:
            return "Analyzing biometric data flow..."
        }
    }
    
    // Updated property list for the toggle
    let accentColor = Color(red: 0.9, green: 0.7, blue: 0.5) // Muted Gold/Tan

    private func organicStatToggle(label: String, icon: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(active ? deepText : Color.white)
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .foregroundColor(active ? .white : softAccent)
                        .font(.system(size: 18))
                }
                .shadow(color: deepText.opacity(0.05), radius: 10, y: 5)
                
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(deepText.opacity(0.4))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(RoundedRectangle(cornerRadius: 30).fill(active ? warmPeach : Color.clear))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func routineRow(title: String, sub: String, icon: String, color: Color) -> some View {
        HStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(color.opacity(0.15))
                    .frame(width: 56, height: 56)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(deepText)
                Text(sub)
                    .font(.system(size: 13))
                    .foregroundColor(deepText.opacity(0.5))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(softAccent)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white)
                .shadow(color: deepText.opacity(0.03), radius: 15, x: 0, y: 8)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(sub)")
        .accessibilityHint("Tap to view details")
    }

    private func luxuryActionCard(title: String, sub: String, icon: String, color: Color) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(color.opacity(0.2))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 16))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(deepText)
                Text(sub)
                    .font(.system(size: 10))
                    .foregroundColor(deepText.opacity(0.5))
            }
            Spacer()
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.9)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) tracker")
        .accessibilityValue(sub)
    }
}
