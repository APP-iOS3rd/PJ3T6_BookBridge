//
//  Presenter.swift
//  GoogleSignInSwift
//
//  Created by Josh Kowarsky on 10/10/20.
//

import AuthenticationServices

extension GoogleSignIn {
    class Presenter: NSObject, ASWebAuthenticationPresentationContextProviding {
        var window: ASPresentationAnchor?
        public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
            return window!
        }
    }
}
