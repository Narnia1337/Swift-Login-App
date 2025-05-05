// LoginView.swift

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var rememberMe: Bool = false
    @State private var isLoading: Bool = false
    @State private var alertMessage: String = ""
    @State private var showForgotFlow = false

    // Animation states
    @State private var emailFieldOffset: CGFloat = 30
    @State private var passwordFieldOffset: CGFloat = 60
    @State private var buttonsOffset: CGFloat = 90
    @State private var opacity: Double = 0

    @EnvironmentObject var sessionManager: SessionManager

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundGradient()
                ScrollView {
                    VStack(spacing: 25) {
                        // Header
                        VStack(spacing: 15) {
                            Image(systemName: "lock.shield.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white)
                            Text("Welcome Back")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            Text("Sign in to continue")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 50)
                        .padding(.bottom, 30)

                        // Form
                        VStack(spacing: 20) {
                            CustomTextField(
                                placeholder: "Email",
                                text: $email,
                                icon: "envelope.fill"
                            )
                            .offset(y: emailFieldOffset)
                            .opacity(opacity)

                            CustomSecureField(
                                placeholder: "Password",
                                text: $password,
                                isVisible: $isPasswordVisible
                            )
                            .offset(y: passwordFieldOffset)
                            .opacity(opacity)

                            HStack {
                                Toggle("Remember me", isOn: $rememberMe)
                                    .toggleStyle(CheckboxToggleStyle())
                                    .foregroundColor(.white)
                                Spacer()
                                Button("Forgot Password?") {
                                    showForgotFlow = true
                                }
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            }
                            .offset(y: buttonsOffset)
                            .opacity(opacity)
                            .padding(.horizontal, 5)

                            Button(action: signIn) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .frame(height: 56)
                                    if isLoading {
                                        ProgressView()
                                            .scaleEffect(1.5)
                                    } else {
                                        Text("Sign In")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(Color(red: 0.925, green: 0.235, blue: 0.102))
                                    }
                                }
                            }
                            .disabled(isLoading)
                            .offset(y: buttonsOffset)
                            .opacity(opacity)
                            .padding(.top, 10)
                            .alert(isPresented: .constant(!alertMessage.isEmpty)) {
                                Alert(
                                    title: Text("Error"),
                                    message: Text(alertMessage),
                                    dismissButton: .default(Text("OK")) { alertMessage = "" }
                                )
                            }

                            HStack(spacing: 5) {
                                Text("Don't have an account?")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                                NavigationLink("Sign Up", destination: SignUpView())
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .offset(y: buttonsOffset)
                            .opacity(opacity)
                            .padding(.top, 20)
                        }
                        .padding(.horizontal, 25)
                    }
                    .padding(.bottom, 50)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    opacity = 1
                    emailFieldOffset = 0
                    passwordFieldOffset = 0
                    buttonsOffset = 0
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showForgotFlow) {
                ForgotPasswordView(email: email)
                    .environmentObject(sessionManager)
            }
        }
    }

    private func signIn() {
        isLoading = true
        AuthService.signIn(usernameOrEmail: email, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let signedIn) where signedIn:
                    if rememberMe {
                        KeychainHelper.standard.save(username: email, password: password)
                    }
                    sessionManager.update(user: email, signedIn: true)
                case .success:
                    alertMessage = "Sign in not completed."
                case .failure(let error):
                    alertMessage = error.localizedDescription
                }
            }
        }
    }
}
