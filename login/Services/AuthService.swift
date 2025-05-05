import Amplify
import AWSPluginsCore

/// A simple wrapper around Amplify.Auth calls.
enum AuthService {
    // MARK: - Sign Up
    
    /// Register a new user. On success, a confirmation code is sent to email.
    static func signUp(
        email: String,
        username: String,
        password: String,
        completion: @escaping (Result<Void, AuthError>) -> Void
    ) {
        Task {
            do {
                // Correctly initialize userAttributes with AuthUserAttribute(.email, value: email)
                let userAttributes = [AuthUserAttribute(.email, value: email)]
                let _ = try await Amplify.Auth.signUp(
                    username: username,
                    password: password,
                    options: .init(userAttributes: userAttributes)
                )
                completion(.success(()))
            } catch let authError as AuthError {
                completion(.failure(authError))
            } catch {
                completion(.failure(.unknown("Unexpected error: \(error)")))
            }
        }
    }
    
    /// Confirm the sign-up with the verification code.
    static func confirmSignUp(
        username: String,
        code: String,
        completion: @escaping (Result<Void, AuthError>) -> Void
    ) {
        Task {
            do {
                let _ = try await Amplify.Auth.confirmSignUp(
                    for: username,
                    confirmationCode: code
                )
                completion(.success(()))
            } catch let authError as AuthError {
                completion(.failure(authError))
            } catch {
                completion(.failure(.unknown("Unexpected error: \(error)")))
            }
        }
    }
    
    // MARK: - Sign In
    
    /// Sign in with username/email and password.
    static func signIn(
        usernameOrEmail: String,
        password: String,
        completion: @escaping (Result<Bool, AuthError>) -> Void
    ) {
        Task {
            do {
                let result = try await Amplify.Auth.signIn(
                    username: usernameOrEmail,
                    password: password
                )
                completion(.success(result.isSignedIn))
            } catch let authError as AuthError {
                completion(.failure(authError))
            } catch {
                completion(.failure(.unknown("Unexpected error: \(error)")))
            }
        }
    }
    
    // MARK: - Resend Sign-Up Code
    
    /// Resend the sign-up confirmation code.
    static func resendSignUpCode(
        username: String,
        completion: @escaping (Result<AuthCodeDeliveryDetails, AuthError>) -> Void
    ) {
        Task {
            do {
                let details = try await Amplify.Auth.resendSignUpCode(for: username)
                completion(.success(details))
            } catch let authError as AuthError {
                completion(.failure(authError))
            } catch {
                completion(.failure(.unknown("Unexpected error: \(error)")))
            }
        }
    }
    
    // MARK: - Password Reset
    
    /// Send a reset-password code to the user's email.
    static func resetPassword(
        for username: String,
        completion: @escaping (Result<Void, AuthError>) -> Void
    ) {
        Task {
            do {
                _ = try await Amplify.Auth.resetPassword(for: username)
                completion(.success(()))
            } catch let authError as AuthError {
                completion(.failure(authError))
            } catch {
                completion(.failure(.unknown("Unexpected error: \(error)")))
            }
        }
    }
    
    /// Confirm the reset-password code and set a new password.
    static func confirmResetPassword(
        for username: String,
        newPassword: String,
        confirmationCode: String,
        completion: @escaping (Result<Void, AuthError>) -> Void
    ) {
        Task {
            do {
                try await Amplify.Auth.confirmResetPassword(
                    for: username,
                    with: newPassword,
                    confirmationCode: confirmationCode
                )
                completion(.success(()))
            } catch let authError as AuthError {
                completion(.failure(authError))
            } catch {
                completion(.failure(.unknown("Unexpected error: \(error)")))
            }
        }
    }
    
    // MARK: - Session Check & Sign Out
    
    /// Fetch the current auth session and tell you if the user is signed in.
    static func fetchSession(
        completion: @escaping (Bool) -> Void
    ) {
        Task {
            do {
                let session = try await Amplify.Auth.fetchAuthSession()
                completion(session.isSignedIn)
            } catch {
                completion(false)
            }
        }
    }
    
    /// Sign out the current user.
    static func signOut(
        completion: @escaping (Result<Void, AuthError>) -> Void
    ) {
        Task {
            do {
                _ = try await Amplify.Auth.signOut()
                completion(.success(()))
            } catch let authError as AuthError {
                completion(.failure(authError))
            } catch {
                completion(.failure(.unknown("Unexpected error: \(error)")))
            }
        }
    }
}
