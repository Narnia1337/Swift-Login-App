// SignUpView.swift

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var sessionManager: SessionManager

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var showConfirm = false
    @State private var isLoading = false
    @State private var alertMessage = ""

    // Animation
    @State private var fieldOffset: CGFloat = 30
    @State private var buttonOffset: CGFloat = 60
    @State private var opacity: Double = 0

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundGradient()
                ScrollView {
                    VStack(spacing: 25) {
                        HeaderView(title: "Create Account",
                                   subtitle: "Sign up to get started")

                        VStack(spacing: 20) {
                            CustomTextField(
                                placeholder: "Email",
                                text: $email,
                                icon: "envelope.fill"
                            )
                            .offset(y: fieldOffset)
                            .opacity(opacity)

                            CustomSecureField(
                                placeholder: "Password",
                                text: $password,
                                isVisible: $isPasswordVisible
                            )
                            .offset(y: fieldOffset)
                            .opacity(opacity)

                            if !showConfirm {
                                CustomSecureField(
                                    placeholder: "Re-enter Password",
                                    text: $confirmPassword,
                                    isVisible: $isConfirmPasswordVisible
                                )
                                .offset(y: fieldOffset)
                                .opacity(opacity)
                            }

                            if showConfirm {
                                CustomTextField(
                                    placeholder: "Verification Code",
                                    text: $confirmPassword, // reuse or separate code var
                                    icon: "key.fill"
                                )
                                .offset(y: fieldOffset)
                                .opacity(opacity)
                            }

                            Button(action: signUpOrConfirm) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .frame(height: 56)
                                    if isLoading {
                                        ProgressView().scaleEffect(1.5)
                                    } else {
                                        Text(showConfirm ? "Confirm" : "Sign Up")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(Color(red: 0.925, green: 0.235, blue: 0.102))
                                    }
                                }
                            }
                            .disabled(isLoading)
                            .offset(y: buttonOffset)
                            .opacity(opacity)
                            .alert(isPresented: .constant(!alertMessage.isEmpty)) {
                                Alert(
                                    title: Text("Error"),
                                    message: Text(alertMessage),
                                    dismissButton: .default(Text("OK")) { alertMessage = "" }
                                )
                            }

                            NavigationLink("Already have an account? Sign In",
                                           destination: LoginView())
                                .offset(y: buttonOffset)
                                .opacity(opacity)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 25)
                    }
                    .padding(.bottom, 50)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    opacity = 1
                    fieldOffset = 0
                    buttonOffset = 0
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func signUpOrConfirm() {
        // your existing sign-up & confirm logic
    }
}
