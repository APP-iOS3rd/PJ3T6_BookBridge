//
//  SignUpVM.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import Foundation
import Firebase

class SignUpVM: ObservableObject {
    @Published var email: String = ""
    @Published var userAuthCode: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    var AuthCode: Int?
    
    func register(completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
}
