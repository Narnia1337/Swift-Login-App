// ForgotPasswordView.swift

import SwiftUI

struct ForgotPasswordView: View {
    @State var email: String
    @State private var code = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var isNewPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var step = 0
    @State private var isLoading = false
    @State private var alertMessage = ""
    @State private var timeRemaining = 60
    @State private var timerActive = false
    @State private var timer: Timer? = nil

    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
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

                        if step == 0 {
                            CustomTextField(
                                placeholder: "Email",
                                text: $email,
                                icon: "envelope.fill"
                            )
                            Button("Send Code") { sendCode() }
                                .buttonStyle(RoundedButtonStyle())
                                .disabled(isLoading)
                        } else {
                            CustomTextField(
                                placeholder: "Verification Code",
                                text: $code,
                                icon: "key.fill"
                            )
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
                            Button("Reset Password") { confirmReset() }
                                .buttonStyle(RoundedButtonStyle())
                                .disabled(isLoading)

                            if timerActive {
                                Text("Resend code in \(timeRemaining)s")
                                    .foregroundColor(.white.opacity(0.8))
                                    .onAppear(perform: startTimer)
                            } else {
                                Button("Resend Code") { sendCode() }
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }

                        if !alertMessage.isEmpty {
                            Text(alertMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 50)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func sendCode() { /* ... */ }
    private func confirmReset() { /* ... */ }
    private func startTimer() { /* ... */ }
}
