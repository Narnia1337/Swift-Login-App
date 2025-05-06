// SignUpView.swift

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var sessionManager: SessionManager

    @State private var email                  = ""
    @State private var password               = ""
    @State private var confirmPassword        = ""
    @State private var code                   = ""
    @State private var isPasswordVisible      = false
    @State private var isConfirmPasswordVisible = false
    @State private var showConfirmationFields = false
    @State private var isLoading              = false
    @State private var alertMessage           = ""

    // resend‐code timer
    @State private var timeRemaining   = 60
    @State private var timerActive     = false
    @State private var timer: Timer?   = nil

    var body: some View {
        ZStack {
            BackgroundGradient()
            ScrollView {
                VStack(spacing: 25) {
                    HeaderView(
                        title: showConfirmationFields ? "Verify Email" : "Create Account",
                        subtitle: showConfirmationFields
                            ? "Enter code sent to\n\(email)"
                            : "Sign up to get started"
                    )

                    // Email
                    CustomTextField(placeholder: "Email", text: $email, icon: "envelope.fill")

                    if !showConfirmationFields {
                        // Password
                        CustomSecureField(
                            placeholder: "Password",
                            text: $password,
                            isVisible: $isPasswordVisible
                        )

                        // Confirm password
                        CustomSecureField(
                            placeholder: "Re-enter Password",
                            text: $confirmPassword,
                            isVisible: $isConfirmPasswordVisible
                        )
                    } else {
                        // Verification code
                        CustomTextField(
                            placeholder: "Verification Code",
                            text: $code,
                            icon: "key.fill"
                        )

                        if timerActive {
                            Text("Resend code in \(timeRemaining)s")
                                .foregroundColor(.white.opacity(0.8))
                        } else {
                            Button("Resend Code") { sendSignUpCode() }
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }

                    // Signup / Confirm button
                    Button(showConfirmationFields ? "Confirm" : "Sign Up") {
                        showConfirmationFields ? confirmSignUp() : startSignUp()
                    }
                    .buttonStyle(RoundedButtonStyle())
                    .disabled(isLoading)
                    .alert(isPresented: .constant(!alertMessage.isEmpty)) {
                        Alert(
                            title: Text("Error"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK")) { alertMessage = "" }
                        )
                    }

                    NavigationLink(
                        "Already have an account? Sign In",
                        destination: LoginView().environmentObject(sessionManager)
                    )
                    .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            // nothing extra
        }
    }

    private func startSignUp() {
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            return
        }
        isLoading = true
        AuthService.signUp(email: email, username: email, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    showConfirmationFields = true
                    startTimer()
                case .failure(let err):
                    alertMessage = err.localizedDescription
                }
            }
        }
    }

    private func confirmSignUp() {
        isLoading = true
        AuthService.confirmSignUp(username: email, code: code) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AuthService.signIn(usernameOrEmail: email, password: password) { signInResult in
                        DispatchQueue.main.async {
                            isLoading = false
                            switch signInResult {
                            case .success(true):
                                sessionManager.update(user: email, signedIn: true)
                            case .success:
                                alertMessage = "Sign-in failed"
                            case .failure(let err):
                                alertMessage = err.localizedDescription
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

    private func sendSignUpCode() {
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
