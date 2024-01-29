//
//  Storage.swift
//  GoogleSignInSwift
//
//  Created by Josh Kowarsky on 10/5/20.
//

public protocol GoogleSignInStorage {
    func get() -> GoogleSignIn.Auth?
    func get() -> GoogleSignIn.User?
    func set(auth: GoogleSignIn.Auth?)
    func set(user: GoogleSignIn.User?)
    func clear() -> Bool
}

public extension GoogleSignIn {
    struct DefaultStorage: GoogleSignInStorage {
        public enum Key: String, CaseIterable {
            case auth = "googlesignin.auth"
            case user = "googlesignin.user"
        }
        private let userdefaults = UserDefaults.standard

        public init() {}

        public func get() -> Auth? {
            guard let data = userdefaults.data(forKey: Key.auth.rawValue) else {
                return nil
            }
            return try? JSONDecoder().decode(Auth.self, from: data)
        }

        public func get() -> User? {
            guard let data = userdefaults.data(forKey: Key.user.rawValue) else {
                return nil
            }
            return try? JSONDecoder().decode(User.self, from: data)
        }

        public func set(auth: Auth?) {
            guard let auth = auth else { return }
            let data = try? JSONEncoder().encode(auth)
            userdefaults.setValue(data, forKey: Key.auth.rawValue)
        }

        public func set(user: User?) {
            guard let user = user else { return }
            let data = try? JSONEncoder().encode(user)
            userdefaults.setValue(data, forKey: Key.user.rawValue)
        }

        @discardableResult
        public func clear() -> Bool {
            for key in Key.allCases {
                userdefaults.removeObject(forKey: key.rawValue)
            }
            return true
        }
    }
}
