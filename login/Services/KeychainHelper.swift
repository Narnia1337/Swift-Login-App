import SwiftUI
import Foundation
import Combine
import Amplify
import Security

class KeychainHelper {
    static let standard = KeychainHelper()
    private let service = "LoginAppAuth"

    /// Save credentials to keychain.
    func save(username: String, password: String) {
        let creds = ["u": username, "p": password]
        guard let data = try? JSONEncoder().encode(creds) else { return }

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecValueData: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    /// Retrieve credentials from keychain.
    func retrieve() -> (u: String, p: String)? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecReturnData: true
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data,
              let dict = try? JSONDecoder().decode([String:String].self, from: data),
              let u = dict["u"], let p = dict["p"]
        else {
            return nil
        }
        return (u, p)
    }
}
