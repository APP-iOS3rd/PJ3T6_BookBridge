//
//  GoogleSignIn.swift
//  GoogleSignInSwift
//
//  Created by Josh Kowarsky on 10/5/20.
//

/// Delegate to receive authentication, user and/or error generated during sign in process.
public protocol GoogleSignInDelegate: AnyObject {
    /**
     The sign in process occures in web. This method contains a custom URL to be launched by the application. The user be presented with their Google accounts and select which one they would like to sign into your app with and then is redirected back to your app.

     ~~~
     // example usage:
     func googleSignIn(shouldOpen url: URL) {
         if #available(iOS 10.0, *) {
             UIApplication
                 .shared
                 .open(url, options: [:])
         } else {
             UIApplication.shared.openURL(url)
         }
     }
     ~~~

     - Parameters:
         - url: `URL` to open.
     */
    func googleSignIn(shouldOpen url: URL)

    /**
     Called when sign in process completes.

     - Parameters:
         - auth: `Auth` object on success.
         - user: `User` object on success if requested.
         - error: `Error` on failure.
     */
    func googleSignIn(didSignIn auth: GoogleSignIn.Auth?, user: GoogleSignIn.User?, error: Error?)
}

/**
 GoogleSignIn is a helper class for logging a user in and obtaining their Google auth credentials and/or their Google user info
 */
public class GoogleSignIn {
    /// Google Sign In Error.
    public enum Error: Swift.Error {
        /// No client ID provided.
        case noClientId
        /// No scope provided.
        case noScope
        /// No refresh token.
        case noRefreshToken
        /// No access token.
        case noAccessToken
        /// Not signed in.
        case notSignedIn
        /// Error decoding JSON.
        case jsonDecodeError
        /// No user.
        case noUser
    }
    /// Completion block used when refreshing auth.
    public typealias RefreshBlock = (Auth?, Swift.Error?) -> Void
    /// Completion block used for `refreshingAccessToken`.
    public typealias RefreshingTokenBlock = (String?, Swift.Error?) -> Void
    /// Completion block used for fetching profile.
    public typealias ProfileBlock = (User?, Swift.Error?) -> Void

    /// Shared instance of `GoogleSignIn`
    public static let shared = GoogleSignIn()

    /// Delegate for recieving sign in completion notification.
    public weak var delegate: GoogleSignInDelegate?

    /// Storage object for storing auth credentials and/or user. Replace with your own Storage conforming to `GoogleSignInStorage`.
    public var storage: GoogleSignInStorage

    /// Google app client ID
    public var clientId: String = ""
    /// Google API scopes
    public var scopes: [String] {
        var set = Set(privateScopes)
        if profile {
            set.insert("profile")
        }
        if email {
            set.insert("email")
        }
        return Array(set)
    }
    private var privateScopes = Set<String>()
    /// Should fetch users profile. Default is `true`.
    public var profile = true
    /// Should fetch users email. Default is `false`.
    public var email = false

    /// Signed in users `Auth` object.
    public var auth: Auth? {
        get {
            return storage.get()
        }
        set {
            storage.set(auth: newValue)
        }
    }
    /// Signed in users `User` object.
    public var user: User? {
        get {
            return storage.get()
        }
        set {
            storage.set(user: newValue)
        }
    }

    /// Redirect URI generated from `clientId`.
    public var redirectURI: String {
        return clientId.components(separatedBy: ".").reversed().joined(separator: ".")
    }
    /// Is user signed in.
    public var isSignedIn: Bool {
        return auth != nil
    }

    private var api: GoogleSignInAPI

    /**
     Manual instantiation is generally used for testing.

     - Parameters:
        - api: API conforming to `GoogleSignInAPI`.
        - storage: Storage conforming to `GoogleSignInStorage`.
     */
    public init(api: GoogleSignInAPI = API(), storage: GoogleSignInStorage = DefaultStorage()) {
        self.api = api
        self.storage = storage
    }

    /// Add Google API scope.
    public func addScope(_ scope: String) {
        privateScopes.insert(scope)
    }

    /// Add multiple Google API scopes.
    public func addScopes(_ scopes: [String]) {
        for scope in scopes {
            addScope(scope)
        }
    }

    /// Remove Google API scope.
    public func removeScope(_ scope: String) {
        privateScopes.remove(scope)
    }

    /// Remove multiple Google API scopes.
    public func removeScopes(_ scopes: [String]) {
        for scope in scopes {
            removeScope(scope)
        }
    }

    /**
     Handle incoming URLs.

     - Parameters:
        - url: URL to handle
    - Returns: `true` if handled.
     */
    @discardableResult
    public func handleURL(_ url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), components.scheme == redirectURI else {
            return false
        }
        guard let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            return false
        }
        authenticate(with: code)
        return true
    }

    public func signInURL() throws -> URL {
        return try Request.auth(clientId: clientId, scopes: scopes, redirectURI: redirectURI).asURL()
    }

    /// Begin process of signing into Google.
    public func signIn() {
        guard !clientId.isEmpty else {
            delegate?.googleSignIn(didSignIn: nil, user: nil, error: Error.noClientId)
            return
        }
        guard !scopes.isEmpty else {
            delegate?.googleSignIn(didSignIn: nil, user: nil, error: Error.noScope)
            return
        }
        do {
            let url = try signInURL()
            delegate?.googleSignIn(shouldOpen: url)
        } catch {
            delegate?.googleSignIn(didSignIn: nil, user: nil, error: error)
        }
    }

    /**
     Sign out.
     Clears users information and authentication credentials.

     - Returns: `true` if successfully signed out.
     */
    @discardableResult
    public func signOut() -> Bool {
        return storage.clear()
    }

    /**
     Refresh users credentials.
     - Parameters:
        - completion: Completion block containing `Auth` oject or an error.
     */
    public func refreshToken(completion: RefreshBlock? = nil) {
        guard !clientId.isEmpty else {
            completion?(nil, Error.noClientId)
            return
        }
        guard let auth = auth, let refreshToken = auth.refreshToken else {
            completion?(nil, Error.noRefreshToken)
            return
        }
        api.request(Request.refreshToken(clientId: clientId, refreshToken: refreshToken)) { [weak self] result in
            switch result {
            case .error(let error):
                completion?(nil, error)
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom(Auth.dateDecodingStrategy)
                guard let auth = try? decoder.decode(Auth.self, from: data) else {
                    completion?(nil, Error.jsonDecodeError)
                    return
                }
                if let oldAuth = self?.auth {
                    self?.auth = oldAuth + auth
                } else {
                    self?.auth = auth
                }

                completion?(self?.auth, nil)
            }
        }
    }

    /**
     Best way to use access token. Refreshing it if necessary.
     - Parameters:
        - completion: Completion block containing fresh access token or error.
     */
    public func refreshingAccessToken(completion: @escaping RefreshingTokenBlock) {
        guard let auth = auth else {
            completion(nil, Error.notSignedIn)
            return
        }
        guard Date().timeIntervalSince(auth.expiresAt) > 0 else {
            completion(auth.accessToken, nil)
            return
        }

        refreshToken { auth, error in
            completion(auth?.accessToken, error)
        }
    }

    private func authenticate(with code: String) {
        guard !clientId.isEmpty else {
            delegate?.googleSignIn(didSignIn: nil, user: nil, error: Error.noClientId)
            return
        }
        api.request(Request.token(code: code, clientId: clientId, redirectURI: redirectURI)) { [weak self] completion in
            switch completion {
            case .error(let error):
                self?.delegate?.googleSignIn(didSignIn: nil, user: nil, error: error)
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom(Auth.dateDecodingStrategy)
                guard let auth = try? decoder.decode(Auth.self, from: data) else {
                    self?.delegate?.googleSignIn(didSignIn: nil, user: nil, error: Error.jsonDecodeError)
                    return
                }
                self?.auth = auth
                self?.getProfile { user, error in
                    if let error = error {
                        self?.delegate?.googleSignIn(didSignIn: auth, user: nil, error: error)
                        return
                    }
                    guard let user = user else {
                        self?.delegate?.googleSignIn(didSignIn: auth, user: nil, error: Error.noUser)
                        return
                    }
                    self?.delegate?.googleSignIn(didSignIn: auth, user: user, error: nil)
                }
            }
        }
    }

    /**
     Fetch the current signed in users profile information.
     - Parameters:
        - completion: Completion block containing `User` object or error.
     */
    public func getProfile(completion: @escaping ProfileBlock) {
        guard let accessToken = auth?.accessToken else {
            completion(nil, Error.noAccessToken)
            return
        }
        guard profile || email else {
            completion(nil, Error.noScope)
            return
        }
        api.request(Request.getProfile(accessToken: accessToken)) { [weak self] result in
            switch result {
            case .error(let error):
                completion(nil, error)
            case .success(let data):
                guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                    completion(nil, Error.jsonDecodeError)
                    return
                }
                self?.user = user
                completion(user, nil)
            }
        }
    }
}
