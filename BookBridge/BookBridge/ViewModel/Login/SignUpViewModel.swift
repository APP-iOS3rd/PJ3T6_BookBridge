//
//  SignUpVM.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import Foundation
import SwiftUI
import Firebase
import SwiftSMTP
import FirebaseFirestore

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var userAuthCode: String = ""
    @Published var timeRemaining = 0
    @Published var timeLabel: String = ""
    @Published var isCertiClear: CertiResult?
    
    @Published var id: String = ""
    @Published var phoneNumer: String = ""
    @Published var nickname: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var pwdStatus: PwdError?
    
    @Published var phError: PhoneError?
    @Published var pwdError: PwdError?
    @Published var pwdConfirmError: PwdConfirmError?
    
    private var authCode: String?
    private let format = FormatValidator()
    let db = Firestore.firestore()
    
    let validator = Validator()
    var isCertiActive = false
    var timer: Timer?
    
    func sendMail() {
        let mail_to = Mail.User(name: "mail_to", email: email)
        authCode = createEmailCode()
        let mail = Mail(
            from: mail_from,
            to: [mail_to],
            subject: "북다리 이메일 인증번호",
            text: emailContent(code: authCode ?? "")
        )
        self.userAuthCode = ""
        self.isCertiClear = nil
        self.isCertiActive = true
        smtp.send(mail)
        showingTime()
    }
    
    func showingTime() {
        timerReset()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            self.timeRemaining -= 1
            
            let min = self.timeRemaining / 60
            let sec = self.timeRemaining % 60
            
            if self.timeRemaining > 0 {
                self.timeLabel = "\(min)분 \(sec)초 남음"
            } else {
                self.authCode = nil
                self.timeLabel = "인증시간만료"
                self.isCertiClear = .timeOut
                timer.invalidate()
            }
        }
    }
    
    func timerReset() {
        self.timeRemaining = 30
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func isValid(type: ValidType) -> Bool {
        switch type {
        case .email:
            return validator.validate(type: .email, value: self.email)
            
        case .id:
            return validator.validate(type: .id, value: self.id)
            
        case .nickname:
            return validator.validate(type: .nickname, value: self.nickname)
        }
    }
            
    func isValidPhone() -> Bool {
        if self.phoneNumer == "" {
            print("휴대폰번호를 입력해주세요")
            print(self.phoneNumer)
            self.phError = .empty
            return false
        }
        
        if !format.isValidPhoneNum(ph: self.phoneNumer) {
            print("휴대폰번호를 입력형식이 맞지 않아요")
            self.phError = .invalid
            return false
        }
                    
        return true
    }
    
    func isValidPwd() -> Bool {
        if self.password.isEmpty {
            print("비밀번호를 입력해주세요")
            self.pwdError = .empty
            return false
        }
        
        return true
    }
    
    func isValidPwdConfirm() -> Bool {
        if self.passwordConfirm.isEmpty {
            print("비밀번호를 한번더 입력해주세요")
            self.pwdConfirmError = .empty
            return false
        }
        
        if self.password != self.passwordConfirm {
            print("비밀번호확인이 맞지 않아요")
            self.pwdConfirmError = .wrong
            return false
        }
        
        if !format.isValidPwd(pwd: self.password) {
            print("핸드폰 입력형식이 맞지 않아요")
            self.pwdConfirmError = .invalid
            return false
        }
        
        return true
    }
    
    
    
    func isCertiCode() {
        if userAuthCode == self.authCode {
            self.isCertiClear = .right
        } else {
            self.isCertiClear = .wrong
        }
    }
    
    func convertUserModelToDictionary(user: UserModel) -> [String : Any] {

        let userData = [
            "id" : user.id,  // change these according to you model
            "email": user.email,
            "password": user.passsword,
            "nickname": user.nickname,
            "phoneNumber": user.phoneNumber,
        ]
        
        return userData as [String : Any]
    }
    
    func userSave(id: String) {
        let user = UserModel(id: id, email: email, passsword: password, nickname: nickname, phoneNumber: phoneNumer)
        let userData = convertUserModelToDictionary(user: user)
        
        db.collection("User").document(id).setData(userData)  { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("User has been saved!")
            }
        }
    }
    
    func signUp(completion: @escaping (Bool) -> Void) {
        if isValidPhone() && isValidPwd() && isValidPwdConfirm() {
            register {
                completion(true)
            }
        } else {
            print("error")
            completion(false)
        }
    }
    
    func register(completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let user = result?.user else { return }
                self.userSave(id: user.uid)
                print("Authentication 저장완료!")
                completion()
            }
        }
    }
        
}
