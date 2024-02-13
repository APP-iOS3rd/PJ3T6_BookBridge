# GoogleSignInSwift

[![CI Status](https://img.shields.io/travis/J0shK/GoogleSignInSwift.svg?style=flat)](https://travis-ci.org/J0shK/GoogleSignInSwift)
[![Version](https://img.shields.io/cocoapods/v/GoogleSignInSwift.svg?style=flat)](https://cocoapods.org/pods/GoogleSignInSwift)
[![License](https://img.shields.io/cocoapods/l/GoogleSignInSwift.svg?style=flat)](https://cocoapods.org/pods/GoogleSignInSwift)
[![Platform](https://img.shields.io/cocoapods/p/GoogleSignInSwift.svg?style=flat)](https://cocoapods.org/pods/GoogleSignInSwift)

`GoogleSignInSwift` uses OAuth 2.0 to to obtain a users Google authentication credentials and/or their profile information. `GoogleSignInSwift` is written 100% in Swift and requires **ZERO** dependencies. It uses fast-app-switching with `Safari` to securely and conveniently sign the user in. You can find more information about Google OAuth 2.0 sign in protocol [here](https://developers.google.com/identity/protocols/oauth2)

## Installation

`GoogleSignInSwift` is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GoogleSignInSwift'
```
# Usage

### Setup
Provide `GoogleSignIn` with your apps [Google API Client ID](https://console.developers.google.com/apis/credentials) and any [Google API scope](https://developers.google.com/identity/protocols/oauth2/scopes)
```swift
GoogleSignIn.shared.clientId = "<Google API Client ID>"
GoogleSignIn.shared.addScope("<Google API Scope>")
```
### Sign in
```swift
GoogleSignIn.shared.delegate = self
GoogleSignIn.shared.signIn()
```
for the process to continue, you must implement `googleSignIn(shouldOpen url:)` and launch provided `URL`.
```swift
func googleSignIn(shouldOpen url: URL) {
    if #available(iOS 10.0, *) {
        UIApplication
            .shared
            .open(url, options: [:])
    } else {
        UIApplication.shared.openURL(url)
    }
}
```
listen for completion by implementing
```swift
func googleSignIn(didSignIn auth: GoogleSignIn.Auth?, user: GoogleSignIn.User?, error: Error?) {
    if let error = error {
        print("Error signing in: \(error)")
        return
    }
    // Route user to app
}
```
### Handle Sign in
After user signs into Google account in Safari, it will redirect to your app. Implement this to capture the results.
```swift
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let urlContext = URLContexts.first else { return }
    GoogleSignIn.shared.handleURL(url)
}
```
or
```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return GoogleSignIn.shared.handleURL(url)
}
```
### Use Access Token
Although you can access the token via `GoogleSignIn.shared.auth?.accessToken` it is recommended you use `GoogleSignIn.shared.refreshingAccessToken`. If the token is expired, this method will refresh and return a new valid token.
```swift
GoogleSignIn.shared.refreshingAccessToken { [weak self] token, _ in
    guard token != nil else {
        return
    }
    // Use token
}
```
### Sign out
```swift
GoogleSignIn.shared.signOut()
```
#### Fetch profile
```swift
GoogleSignIn.shared.getProfile { user, error in
    //
}
```
#### Get user email with sign in
To get a users email, make sure that you set this before sign in.
```swift
GoogleSignIn.shared.email = true
```
You can also disable `profile` (default `true`)
#### Auth status
```swift
GoogleSignIn.shared.isSignedIn
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

[J0shK](https://github.com/J0shK)

## License

GoogleSignInSwift is available under the MIT license. See the LICENSE file for more info.
