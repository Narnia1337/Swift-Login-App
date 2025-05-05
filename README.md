# MyLoginApp

A SwiftUI iOS application demonstrating AWS Amplify–powered authentication flows:

- **Sign Up** with email verification  
- **Login** with “Remember Me” (Keychain storage)  
- **Password Reset** via email code  
- **Auto–Confirm & Auto–Sign In**  
- Clean, animated SwiftUI UI  

---

## 📋 Features

- **Sign Up**  
  - Enter email, password, re-enter password  
  - Receive & confirm verification code  
  - Automatically logs you in after confirmation  

- **Login**  
  - Enter email or username + password  
  - “Remember Me” saves credentials securely in Keychain  
  - Error alerts on invalid credentials  

- **Forgot Password**  
  - Send reset code to your email  
  - Enter code + new password + confirm password  
  - Auto–sign in after successful reset  

- **Reusable Components**  
  - `CustomTextField`, `CustomSecureField` with “eye” toggle  
  - `BackgroundGradient`, `HeaderView`, `RoundedButtonStyle`  

---

## ⚙️ Prerequisites

- **macOS 14+** with **Xcode 15+**  
- **Swift 5.7+**  
- **Node.js & npm** (for Amplify CLI)  
- **AWS Amplify CLI**


  
npm install -g @aws-amplify/cli

•	An AWS account & configured AWS CLI profile

amplify configure


⸻

🚀 Getting Started
	1.	Clone this repository
 
```
git clone https://github.com/Narnia1337/myloginapp.git
cd myloginapp/login
```


Install backend config

If you already have amplifyconfiguration.json and awsconfiguration.json, skip this.
Otherwise pull your Amplify environment:

```
amplify pull --appId YOUR_AMPLIFY_APP_ID --envName dev --restore
```

Replace YOUR_AMPLIFY_APP_ID with your Amplify App ID (found in the Amplify Console).

Open in Xcode

open Login.xcodeproj

or if you use a workspace:

open Login.xcworkspace

Resolve Swift Packages

In Xcode go to File → Swift Packages → Resolve Package Versions.

⸻

▶️ Running the App
	1.	Select a simulator or your device (e.g. iPhone 15).
	2.	Press ⌘R to build & run.
	3.	You’ll see the Login screen. From there you can:
	•	Sign Up → confirm code → auto-login
	•	Login → optionally “Remember Me”
	•	Forgot Password → reset flow → auto-login

⸻
```
🔧 Project Structure

login/
├─ Views/
│   ├─ LoginView.swift
│   ├─ SignUpView.swift
│   ├─ ConfirmSignUpView.swift
│   ├─ ForgotPasswordView.swift
│   └─ SharedComponents.swift
├─ Services/
│   ├─ AuthService.swift
│   ├─ SessionManager.swift
│   └─ KeychainHelper.swift
├─ amplifyconfiguration.json
├─ awsconfiguration.json
└─ Login.xcodeproj
```
	
 Views/ – All SwiftUI screens & shared UI components	
 Services/ – Amplify wrapper, session management, keychain helper
 Amplify config – Backend settings for Cognito

⸻

🔑 Amplify & AWS Setup
	1.	In your app’s @main struct, initialize Amplify:
 ```

import Amplify
import AWSCognitoAuthPlugin

@main
struct LoginApp: App {
  init() {
    do {
      try Amplify.add(plugin: AWSCognitoAuthPlugin())
      try Amplify.configure()
      print("Amplify configured")
    } catch {
      print("Failed to configure Amplify: \(error)")
    }
  }

  var body: some Scene {
    WindowGroup {
      LoginView()
        .environmentObject(SessionManager())
    }
  }
}
```


Push backend changes whenever you modify amplify/backend:

```
amplify push
```


⸻

🤝 Contributing
	1.	Fork the repo
	2.	Create a feature branch: git checkout -b feature/my-feature
	3.	Commit your changes: git commit -m "Add my feature"
	4.	Push to your branch: git push origin feature/my-feature
	5.	Open a Pull Request

⸻

📄 License

This project is open source under the MIT License.

