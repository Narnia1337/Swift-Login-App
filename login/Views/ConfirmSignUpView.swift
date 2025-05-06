// ConfirmSignUpView.swift

import SwiftUI

struct ConfirmSignUpView: View {
    let email: String
    let password: String

    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.presentationMode) var presentationMode

    @State private var code        = ""
    @State private var isLoading   = false
    @State private var alertMessage = ""
    @State private var timeRemaining = 60
    @State private var timerActive   = true
    @State private var timer: Timer? = nil

    var body: some View {
        ZStack {
            BackgroundGradient()
            ScrollView {
                VStack(spacing: 25) {
                    HeaderView(
                        title: "Verify Email",
                        subtitle: "A code was sent to\n\(email)"
                    )

                    CustomTextField(placeholder: "Verification Code", text: $code, icon: "key.fill")

                    Button("Confirm") { confirm() }
                        .buttonStyle(RoundedButtonStyle())
                        .disabled(isLoading)
                        .alert(isPresented: .constant(!alertMessage.isEmpty)) {
                            Alert(
                                title: Text("Error"),
                                message: Text(alertMessage),
                                dismissButton: .default(Text("OK")) { alertMessage = "" }
                            )
                        }

                    if timerActive {
                        Text("Resend code in \(timeRemaining)s")
                            .foregroundColor(.white.opacity(0.8))
                            .onAppear(perform: startTimer)
                    } else {
                        Button("Resend Code") { resendCode() }
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
    }

    private func confirm() {
        isLoading = true
        AuthService.confirmSignUp(username: email, code: code) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AuthService.signIn(usernameOrEmail: email, password: password) { signInResult in
                        DispatchQueue.main.async {
                            isLoading = false
                            if case .success(true) = signInResult {
                                sessionManager.update(user: email, signedIn: true)
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                alertMessage = "Sign-in failed"
                            }
                        }
                    }
                case .failure(let err):
                    isLoading = false
                    alertMessage = err.localizedDescription
                }
            }
        }
    }

    private func resendCode() {
        isLoading = true
        AuthService.resendSignUpCode(username: email) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    startTimer()
                case .failure(let err):
                    alertMessage = err.localizedDescription
                }
            }
        }
    }

    private func startTimer() {
        timeRemaining = 60
        timerActive   = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerActive = false
                t.invalidate()
            }
        }
    }
}
