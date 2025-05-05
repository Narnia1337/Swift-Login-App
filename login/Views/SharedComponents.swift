import SwiftUI

// MARK: - Shared UI Components

/// Background gradient used across multiple views
struct BackgroundGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.925, green: 0.235, blue: 0.102),
                Color(red: 0.969, green: 0.78,  blue: 0.345)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

/// Header with icon, title, and subtitle
struct HeaderView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "lock.shield.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
            Text(title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            Text(subtitle)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.top, 50)
        .padding(.bottom, 30)
    }
}

/// Custom text field with icon and placeholder styling
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 20)
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.15)))
        .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1))
    }
}

/// Custom secure field with visibility toggle
struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool

    var body: some View {
        HStack {
            Image(systemName: "lock.fill")
                .foregroundColor(.white)
                .frame(width: 20)
            Group {
                if isVisible {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
            }
            .foregroundColor(.white)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            Button(action: { isVisible.toggle() }) {
                Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.15)))
        .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1))
    }
}

/// Social login button style
struct SocialLoginButton: View {
    var icon: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.925, green: 0.235, blue: 0.102))
                .frame(width: 60, height: 60)
                .background(Circle().fill(Color.white))
        }
    }
}

/// Checkbox toggle style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .white : .white.opacity(0.7))
                .font(.system(size: 16, weight: .semibold))
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
    }
}

struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.925, green: 0.235, blue: 0.102))
            )
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

/// Placeholder modifier for overlay text
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
