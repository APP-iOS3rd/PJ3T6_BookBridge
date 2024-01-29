//
//  SignUpVM.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import Foundation

class SignUpVM: ObservableObject {
    @Published var email: String = ""
    @Published var userAuthCode: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    var AuthCode: Int?
}
