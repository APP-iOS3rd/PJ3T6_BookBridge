# GoogleSignInSwift

[![CI Status](https://img.shields.io/travis/J0shK/GoogleSignInSwift.svg?style=flat)](https://travis-ci.org/J0shK/GoogleSignInSwift)
[![Version](https://img.shields.io/cocoapods/v/GoogleSignInSwift.svg?style=flat)](https://cocoapods.org/pods/GoogleSignInSwift)
[![License](https://img.shields.io/cocoapods/l/GoogleSignInSwift.svg?style=flat)](https://cocoapods.org/pods/GoogleSignInSwift)
[![Platform](https://img.shields.io/cocoapods/p/GoogleSignInSwift.svg?style=flat)](https://cocoapods.org/pods/GoogleSignInSwift)

`GoogleSignInSwift` uses OAuth 2.0 to to obtain a users Google authentication credentials and/or their profile information. `GoogleSignInSwift` is written 100% in Swift. You can find more information about Google OAuth 2.0 sign in protocol [here](https://developers.google.com/identity/protocols/oauth2)

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
GoogleSignIn.shared.presentingWindow = view.window
GoogleSignIn.shared.signIn()
```
listen for completion by conforming to `GoogleSignInDelegate`
```swift
func googleSignIn(didSignIn auth: GoogleSignIn.Auth?, user: GoogleSignIn.User?, error: Error?) {
    if let error = error {
        print("Error signing in: \(error)")
        return
    }
    // Route user to app
}
```
### Use Access Token
Although you can access the token via `GoogleSignIn.shared.auth?.accessToken` it is recommended you use `GoogleSignIn.shared.refreshingAccessToken`. If the token is expired, this method will refresh and return a new valid token.
```swift
GoogleSignIn.shared.refreshingAccessToken { token, _ in
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
note: this is done for you once by default when user logs in.
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
