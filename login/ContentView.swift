import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: SessionManager

    var body: some View {
        NavigationView {
            Group {
                if sessionManager.isSignedIn {
                    VStack(spacing: 20) {
                        Text("Welcome, \(sessionManager.username)")
                        Button("Sign Out") {
                            sessionManager.signOut()
                        }
                    }
                } else {
                    LoginView()
                }
            }
            .navigationTitle("Login")
        }
    }
}
