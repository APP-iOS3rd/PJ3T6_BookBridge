//
//  AuthenticationManager.swift
//  BookBridge
//
//  Created by 이민호 on 1/25/24.
//

import Foundation
import FirebaseAuth


final class GoogleAuthManager {
    static let shared = GoogleAuthManager()
    private init() { }
    
    
}

extension GoogleAuthManager {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignResultModel) async throws -> GoogleAuthModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> GoogleAuthModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return GoogleAuthModel(user: authDataResult.user)
    }
    
    
}
