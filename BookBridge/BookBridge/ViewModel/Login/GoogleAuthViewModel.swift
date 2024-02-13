//
//  GoogleAuthViewModel.swift
//  BookBridge
//
//  Created by 이민호 on 2/1/24.
//

import Foundation

final class GoogleAuthViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = GoogleSignManager()
        let tokens = try await helper.signIn()
        try await GoogleAuthManager.shared.signInWithGoogle(tokens: tokens)
    }
    
}
