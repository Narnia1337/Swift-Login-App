import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct loginApp: App {
    @StateObject private var sessionManager = SessionManager()

    init() {
        configureAmplify()
    }

    func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("✅ Amplify configured")
        } catch {
            print("⚠️ Amplify failed: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionManager)
        }
    }
}
