import SwiftUI

struct OnboardingTheme {
    let backgroundColor: Color
    let accentColor: Color
    let textColor: Color
    let splitBackgroundColor: Color?
}

struct OnboardingScreen: Identifiable {
    let id = UUID()
    let topText: String
    let subHeadline: String
    let headline: String
    let footerText: String
    let imageName: String
    let verticalTitle: String
    let theme: OnboardingTheme
}

let onboardingScreens = [
    OnboardingScreen(
        topText: "VIRTUAL TWIN",
        subHeadline: "Meet your pet's\ndigital shadow",
        headline: "A real-time health mirror that tracks every heartbeat and habit.",
        footerText: "Say Hello",
        imageName: "onboarding_sleeping_dog", // Make sure this exists or use systemName
        verticalTitle: "TWIN",
        theme: OnboardingTheme(
            backgroundColor: Color(red: 0.98, green: 0.96, blue: 0.94),
            accentColor: Color(red: 0.95, green: 0.88, blue: 0.82),
            textColor: Color(red: 0.28, green: 0.24, blue: 0.20),
            splitBackgroundColor: nil
        )
    ),
    OnboardingScreen(
        topText: "PRECISION CARE",
        subHeadline: "Predict before\nthey feel it",
        headline: "Advanced medical tracking that detects patterns before they become problems.",
        footerText: "Explore Tech",
        imageName: "onboarding_playing_cat",
        verticalTitle: "CARE",
        theme: OnboardingTheme(
            backgroundColor: Color(red: 0.94, green: 0.92, blue: 1.0),
            accentColor: Color(red: 0.85, green: 0.80, blue: 0.95),
            textColor: Color(red: 0.20, green: 0.15, blue: 0.35),
            splitBackgroundColor: Color(red: 0.88, green: 0.85, blue: 1.0)
        )
    ),
    OnboardingScreen(
        topText: "BONDED LIFE",
        subHeadline: "Happiness in\nevery pixel",
        headline: "Manage routines, medications, and vet visits in one luxury console.",
        footerText: "Get Started",
        imageName: "onboarding_sleeping_dog",
        verticalTitle: "LIFE",
        theme: OnboardingTheme(
            backgroundColor: Color(red: 1.0, green: 0.94, blue: 0.94),
            accentColor: Color(red: 0.95, green: 0.85, blue: 0.85),
            textColor: Color(red: 0.45, green: 0.25, blue: 0.25),
            splitBackgroundColor: Color(red: 1.0, green: 0.88, blue: 0.88)
        )
    )
]

// Breeds for the picker
let dogBreeds = ["Golden Retriever", "German Shepherd", "French Bulldog", "Beagle", "Poodle", "Labrador", "Chihuahua", "Husky", "Other"]
let catBreeds = ["Persian", "Maine Coon", "Siamese", "Ragdoll", "Bengal", "Sphynx", "British Shorthair", "Other"]
