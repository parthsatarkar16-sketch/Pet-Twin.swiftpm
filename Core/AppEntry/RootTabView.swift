import SwiftUI

struct RootTabView: View {
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @State private var storage = LocalStorageService.shared
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView(isCompleted: Binding(
                    get: { hasCompletedOnboarding },
                    set: { 
                        hasCompletedOnboarding = $0
                        UserDefaults.standard.set($0, forKey: "hasCompletedOnboarding")
                    }
                ))
            } else if storage.currentPet == nil {
                PetProfileCreationView(storage: storage)
            } else {
                NavigationView {
                    HomeView()
                }
                .environment(storage)
            }
        }
    }
}
