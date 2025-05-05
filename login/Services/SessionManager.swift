import Foundation
import Combine
import Amplify

class SessionManager: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var username: String = ""

    init() {
        checkSession()
    }

    func checkSession() {
        Task {
            do {
                let session = try await Amplify.Auth.fetchAuthSession()
                if session.isSignedIn {
                    // retrieve the user
                    let user = try await Amplify.Auth.getCurrentUser()
                    await MainActor.run {
                        self.isSignedIn = true
                        self.username = user.username
                    }
                } else {
                    await MainActor.run {
                        self.isSignedIn = false
                        self.username = ""
                    }
                }
            } catch {
                await MainActor.run {
                    self.isSignedIn = false
                    self.username = ""
                }
            }
        }
    }

    func update(user: String, signedIn: Bool) {
        Task { @MainActor in
            self.username = user
            self.isSignedIn = signedIn
        }
    }

    func signOut() {
        Task {
            // signOut is async but doesn’t throw
            _ = await Amplify.Auth.signOut()
            await MainActor.run {
                self.isSignedIn = false
                self.username = ""
            }
        }
    }
}
