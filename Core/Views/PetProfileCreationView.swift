import SwiftUI
import PhotosUI

struct PetProfileCreationView: View {
    var storage: LocalStorageService
    @State private var name = ""
    @State private var species = "Dog"
    @State private var breed = ""
    @State private var age = 1
    @State private var gender = "Male"
    @State private var personality = ""
    
    // Luxury Palette
    let bgColor = Color(red: 0.98, green: 0.97, blue: 0.94) // Warm Off-White/Cream
    let accentColor = Color(red: 0.9, green: 0.7, blue: 0.5) // Muted Gold/Tan
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20) // Deep Mocha
    
    // Photo Picker States
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var previewImage: Image? = nil
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Background
            bgColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(accentColor.opacity(0.1))
                                .frame(width: 80, height: 80)
                            Image(systemName: "sparkles")
                                .font(.system(size: 30))
                                .foregroundColor(accentColor)
                        }
                        .scaleEffect(animate ? 1 : 0.8)
                        
                        VStack(spacing: 8) {
                            Text("Pet Profile")
                                .font(.system(size: 36, weight: .bold, design: .serif))
                                .foregroundColor(deepText)
                            
                            Text("Design your pet's digital soul")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(deepText.opacity(0.4))
                                .kerning(1)
                                .textCase(.uppercase)
                        }
                    }
                    .padding(.top, 40)
                    
                    // Main Creative Card
                    VStack(spacing: 32) {
                        
                        // Image Picker (Premium Style)
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            ZStack(alignment: .bottomTrailing) {
                                Group {
                                    if let previewImage {
                                        previewImage
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        ZStack {
                                            Color.black.opacity(0.03)
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 30))
                                                .foregroundColor(deepText.opacity(0.1))
                                        }
                                    }
                                }
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.05), radius: 15, y: 10)
                                .overlay(Circle().stroke(Color.white, lineWidth: 6))
                                
                                // Floating Action Button
                                ZStack {
                                    Circle()
                                        .fill(accentColor)
                                        .frame(width: 38, height: 38)
                                    Image(systemName: previewImage == nil ? "plus" : "pencil")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .shadow(color: accentColor.opacity(0.4), radius: 8, y: 4)
                                .offset(x: -2, y: -2)
                            }
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                    if let uiImage = UIImage(data: data) {
                                        previewImage = Image(uiImage: uiImage)
                                    }
                                }
                            }
                        }
                        
                        // Interaction Fields
                        VStack(alignment: .leading, spacing: 24) {
                            luxuryInputField(label: "PET NAME", text: $name, placeholder: "e.g. Luna")
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("SPECIES")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(deepText.opacity(0.4))
                                    .kerning(1)
                                
                                HStack(spacing: 12) {
                                    luxuryChoiceButton(label: "Dog", icon: "dog.fill", isSelected: species == "Dog") { species = "Dog"; breed = "" }
                                    luxuryChoiceButton(label: "Cat", icon: "cat.fill", isSelected: species == "Cat") { species = "Cat"; breed = "" }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("BREED")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(deepText.opacity(0.4))
                                    .kerning(1)
                                
                                Menu {
                                    ForEach(species == "Dog" ? dogBreeds : catBreeds, id: \.self) { b in
                                        Button(b) { breed = b }
                                    }
                                } label: {
                                    HStack {
                                        Text(breed.isEmpty ? "Select Breed" : breed)
                                            .foregroundColor(breed.isEmpty ? deepText.opacity(0.3) : deepText)
                                            .font(.system(size: 15, weight: .medium))
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(accentColor)
                                    }
                                    .padding(18)
                                    .background(Color.black.opacity(0.02))
                                    .cornerRadius(18)
                                }
                            }
                            
                            HStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("AGE (YRS)")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(deepText.opacity(0.4))
                                        .kerning(1)
                                    
                                    HStack(spacing: 12) {
                                        Text("\(age)")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(deepText)
                                            .frame(minWidth: 30)
                                        
                                        Stepper("", value: $age, in: 0...30)
                                            .labelsHidden()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.black.opacity(0.02))
                                    .cornerRadius(18)
                                }
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("GENDER")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(deepText.opacity(0.4))
                                        .kerning(1)
                                    
                                    HStack(spacing: 8) {
                                        luxuryChoiceButton(label: "Male", icon: "m.circle", isSelected: gender == "Male", small: true) { gender = "Male" }
                                        luxuryChoiceButton(label: "Female", icon: "f.circle", isSelected: gender == "Female", small: true) { gender = "Female" }
                                    }
                                }
                            }
                            
                            luxuryInputField(label: "BIO", text: $personality, placeholder: "Describe their personality...", isLarge: true)
                        }
                    }
                    .padding(32)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.03), radius: 30, y: 15)
                    )
                    .padding(.horizontal, 24)
                    
                    // Final Action Button
                    Button(action: saveProfile) {
                        HStack(spacing: 12) {
                            Text("Initialize Life")
                                .font(.system(size: 18, weight: .bold))
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 22)
                        .background(name.isEmpty || breed.isEmpty ? Color.gray.opacity(0.2) : accentColor)
                        .cornerRadius(24)
                        .shadow(color: accentColor.opacity(0.3), radius: 15, y: 8)
                    }
                    .disabled(name.isEmpty || breed.isEmpty)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                animate = true
            }
        }
    }
    
    // MARK: - Components
    
    private func luxuryInputField(label: String, text: Binding<String>, placeholder: String, isLarge: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(label)
                .font(.system(size: 10, weight: .black))
                .foregroundColor(deepText.opacity(0.4))
                .kerning(1)
            
            Group {
                if isLarge {
                    TextEditor(text: text)
                        .frame(height: 100)
                        .padding(14)
                } else {
                    TextField(placeholder, text: text)
                        .padding(18)
                }
            }
            .background(Color.black.opacity(0.02))
            .cornerRadius(18)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(deepText)
        }
    }
    
    private func luxuryChoiceButton(label: String, icon: String, isSelected: Bool, small: Bool = false, action: @escaping () -> Void = {}) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if !small { Image(systemName: icon) }
                Text(label)
                    .font(.system(size: 14, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isSelected ? accentColor : Color.black.opacity(0.02))
            .foregroundColor(isSelected ? .white : deepText)
            .cornerRadius(16)
        }
    }
    
    @Environment(\.dismiss) var dismiss
    
    private func saveProfile() {
        let newPet = Pet(
            name: name,
            species: species,
            breed: breed,
            age: age,
            gender: gender,
            personality: personality,
            imageData: selectedImageData
        )
        withAnimation(.spring()) {
            storage.addPet(newPet)
            dismiss()
        }
    }
}
