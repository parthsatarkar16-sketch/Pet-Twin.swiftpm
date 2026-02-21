import SwiftUI

struct DocumentsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingUploadSheet = false
    @State private var uploadProgress: Double = 0
    
    let bgColor = Color(red: 0.98, green: 0.97, blue: 0.94)
    let accentColor = Color.blue
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
    
    var body: some View {
        ZStack(alignment: .top) {
            bgColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Header
                    HStack(spacing: 20) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(deepText)
                                .padding(12)
                                .background(Circle().fill(Color.white))
                                .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
                        }
                        .accessibilityLabel("Go back")
                        .accessibilityHint("Returns to the previous screen")
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Documents")
                                .font(.system(size: 34, weight: .bold, design: .serif))
                                .foregroundColor(deepText)
                            Text("Pet Records & Certificates")
                                .font(.system(size: 14))
                                .foregroundColor(deepText.opacity(0.5))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    
                    // Documents List
                    VStack(alignment: .leading, spacing: 20) {
                        Text("All Documents")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .padding(.horizontal, 30)
                        
                        VStack(spacing: 16) {
                            NavigationLink(destination: DocumentDetailView(title: "Insurance Policy", type: "PDF")) {
                                DocumentRow(title: "Insurance Policy", date: "Jan 12, 2026", type: "PDF")
                            }
                            NavigationLink(destination: DocumentDetailView(title: "Medical Record", type: "Certificate")) {
                                DocumentRow(title: "Medical Record", date: "Feb 05, 2026", type: "Certificate")
                            }
                            NavigationLink(destination: DocumentDetailView(title: "Birth Certificate", type: "Identity")) {
                                DocumentRow(title: "Birth Certificate", date: "Initial Entry", type: "Identity")
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 120)
                }
            }
            
            // Add Button
            VStack {
                Spacer()
                Button(action: { showingUploadSheet = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "doc.badge.plus")
                            .symbolEffect(.bounce, value: showingUploadSheet)
                        Text("Upload Document")
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 18)
                    .background(Color.blue)
                    .clipShape(Capsule())
                    .shadow(color: Color.blue.opacity(0.4), radius: 20, y: 10)
                }
                .accessibilityLabel("Upload new document")
                .accessibilityHint("Tap to add a new record or certificate")
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingUploadSheet) {
            DocumentUploadView()
                .presentationDetents([.medium, .large])
                .presentationCornerRadius(40)
        }
    }
}

struct DocumentRow: View {
    let title: String
    let date: String
    let type: String
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 50, height: 50)
                Image(systemName: "doc.fill")
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(deepText)
                Text("\(type) • \(date)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "eye")
                .foregroundColor(.blue.opacity(0.5))
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white))
        .shadow(color: Color.black.opacity(0.02), radius: 10, y: 5)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(type). dated \(date)")
        .accessibilityHint("Double tap to view document details")
        .accessibilityAddTraits(.isButton)
    }
}

struct DocumentDetailView: View {
    let title: String
    let type: String
    @Environment(\.dismiss) var dismiss
    let bgColor = Color(red: 0.98, green: 0.97, blue: 0.94)
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)

    var body: some View {
        ZStack(alignment: .top) {
            bgColor.ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(deepText)
                            .padding(12)
                            .background(Circle().fill(Color.white))
                    }
                    Spacer()
                    Text(type.uppercased())
                        .font(.system(size: 10, weight: .black))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Document Placeholder
                VStack(spacing: 24) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.05), radius: 20)
                        
                        VStack(spacing: 16) {
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 64))
                                .foregroundColor(.blue.opacity(0.2))
                            Text(title)
                                .font(.system(size: 24, weight: .bold, design: .serif))
                            Text("Document preview is not available in offline mode. Please download to view full content.")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                    }
                    .frame(height: 400)
                    
                    Button(action: { }) {
                        Label("Download \(type)", systemImage: "arrow.down.doc.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct DocumentUploadView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isUploading = false
    @State private var progress: Double = 0.0
    @State private var selectedType = "Medical"
    @State private var docName = ""
    
    let types = ["Medical", "Insurance", "Identity", "Other"]
    let accentColor = Color.blue
    let deepText = Color(red: 0.28, green: 0.24, blue: 0.20)
    
    var body: some View {
        VStack(spacing: 32) {
            Capsule()
                .fill(Color.secondary.opacity(0.2))
                .frame(width: 40, height: 6)
                .padding(.top, 12)
            
            Text("Secure Upload")
                .font(.system(size: 24, weight: .bold, design: .serif))
                .foregroundColor(deepText)
            
            if !isUploading {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("DOCUMENT NAME")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.secondary)
                        TextField("e.g. Annual Checkup 2026", text: $docName)
                            .padding(20)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black.opacity(0.03)))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("CATEGORY")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.secondary)
                        HStack(spacing: 12) {
                            ForEach(types, id: \.self) { type in
                                Button(action: { selectedType = type }) {
                                    Text(type)
                                        .font(.system(size: 13, weight: .bold))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(selectedType == type ? accentColor : Color.white)
                                        .foregroundColor(selectedType == type ? .white : .secondary)
                                        .cornerRadius(12)
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.05), lineWidth: 1))
                                }
                            }
                        }
                    }
                    
                    Button(action: { startUpload() }) {
                        VStack(spacing: 16) {
                            Image(systemName: "square.and.arrow.up.fill")
                                .font(.system(size: 40))
                                .foregroundColor(accentColor)
                                .symbolEffect(.pulse)
                            Text("Ready to Deposit")
                                .font(.headline)
                                .foregroundColor(deepText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .background(RoundedRectangle(cornerRadius: 32).strokeBorder(accentColor.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [8])).background(accentColor.opacity(0.02)))
                    }
                    .accessibilityLabel("Start encrypted upload")
                }
                .padding(.horizontal, 24)
            } else {
                VStack(spacing: 32) {
                    ZStack {
                        Circle().stroke(Color.black.opacity(0.05), lineWidth: 12).frame(width: 150, height: 150)
                        Circle().trim(from: 0, to: progress).stroke(accentColor, style: StrokeStyle(lineWidth: 12, lineCap: .round)).frame(width: 150, height: 150).rotationEffect(.degrees(-90))
                        VStack(spacing: 4) {
                            Text("\(Int(progress * 100))%").font(.system(size: 32, weight: .black))
                            Text("ENCRYPTING").font(.system(size: 8, weight: .black)).foregroundColor(.secondary)
                        }
                    }
                    Text("Securing pet's data...")
                        .font(.system(size: 16, weight: .medium, design: .serif))
                        .symbolEffect(.variableColor.iterative, options: .repeating)
                }
                .padding(.vertical, 60)
            }
            Spacer()
        }
    }
    
    private func startUpload() {
        withAnimation { isUploading = true }
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if progress < 1.0 { progress += 0.05 }
            else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { dismiss() }
            }
        }
    }
}
