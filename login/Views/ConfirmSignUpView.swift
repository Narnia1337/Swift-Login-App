// ConfirmSignUpView.swift

import SwiftUI

struct ConfirmSignUpView: View {
    let email: String
    let password: String

    @State private var code = ""
    @State private var isLoading = false
    @State private var alertMessage = ""
    @State private var timeRemaining = 60
    @State private var timerActive = true
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
                            title: "Verify Email",
                            subtitle: "A code was sent to\n\(email)"
                        )

                        CustomTextField(
                            placeholder: "Verification Code",
                            text: $code,
                            icon: "key.fill"
                        )
                        .padding(.top, 20)

                        Button(action: confirm) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .frame(height: 56)
                                if isLoading {
                                    ProgressView().scaleEffect(1.5)
                                } else {
                                    Text("Confirm")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(red: 0.925, green: 0.235, blue: 0.102))
                                }
                            }
                        }
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
                            Button("Resend Code") {
                                resendCode()
                            }
                            .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 50)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func startTimer() { /* ... */ }
    private func resendCode() { /* ... */ }
    private func confirm() { /* ... */ }
}
