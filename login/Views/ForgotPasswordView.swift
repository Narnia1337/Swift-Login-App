// ForgotPasswordView.swift

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var sessionManager: SessionManager

    @State private var email           = ""
    @State private var code            = ""
    @State private var newPassword     = ""
    @State private var confirmPassword = ""
    @State private var isNewPasswordVisible    = false
    @State private var isConfirmPasswordVisible = false
    @State private var step            = 0  // 0=send code, 1=reset
    @State private var isLoading       = false
    @State private var alertMessage    = ""
    @State private var timeRemaining   = 60
    @State private var timerActive     = false
    @State private var timer: Timer?   = nil

    var body: some View {
        ZStack {
            BackgroundGradient()
            ScrollView {
                VStack(spacing: 25) {
                    HeaderView(
                        title: step == 0 ? "Forgot Password" : "Reset Password",
                        subtitle: step == 0
                            ? "Enter your email to receive a code"
                            : "Enter code and new password"
                    )

                    CustomTextField(placeholder: "Email", text: $email, icon: "envelope.fill")

                    if step == 1 {
                        CustomTextField(placeholder: "Verification Code", text: $code, icon: "key.fill")

                        CustomSecureField(
                            placeholder: "New Password",
                            text: $newPassword,
                            isVisible: $isNewPasswordVisible
                        )

                        CustomSecureField(
                            placeholder: "Confirm Password",
                            text: $confirmPassword,
                            isVisible: $isConfirmPasswordVisible
                        )

                        if timerActive {
                            Text("Resend code in \(timeRemaining)s")
                                .foregroundColor(.white.opacity(0.8))
                        } else {
                            Button("Resend Code") { sendResetCode() }
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }

                    Button(step == 0 ? "Send Code" : "Confirm Reset") {
                        step == 0 ? sendResetCode() : confirmReset()
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
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            if step == 1 { startTimer() }
        }
    }

    private func sendResetCode() {
        isLoading = true
        AuthService.resetPassword(for: email) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    step = 1
                    startTimer()
                case .failure(let err):
                    alertMessage = err.localizedDescription
                }
            }
        }
    }

    private func confirmReset() {
        guard newPassword == confirmPassword else {
            alertMessage = "Passwords do not match"
            return
        }
        isLoading = true
        AuthService.confirmResetPassword(
            for: email,
            newPassword: newPassword,
            confirmationCode: code
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    AuthService.signIn(usernameOrEmail: email, password: newPassword) { signInResult in
                        DispatchQueue.main.async {
                            if case .success(true) = signInResult {
                                sessionManager.update(user: email, signedIn: true)
                            } else {
                                alertMessage = "Sign-in failed"
                            }
                        }
                    }
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
