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
    // Email Certify
    @Published var email: String = ""
    @Published var userAuthCode: String = ""
    @Published var timeRemaining = 0
    @Published var timeLabel: String = ""
    @Published var isEmailWrong = false
    @Published var isEmailCertified = false
    
    // SignUp
    @Published var id: String = ""
    @Published var phoneNumer: String = ""
    @Published var nickname: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var pwdStatus: PwdError?
    
    // Error
    @Published var nicknameError: NicknameError?
    @Published var emailError: EmailError?
    @Published var phError: PhoneError?
    @Published var pwdError: PwdError?
    @Published var pwdConfirmError: PwdConfirmError?
    
    private var authCode: String?
    private let format = FormatValidator()
    private let redundant = RedundantValidator()
    let db = Firestore.firestore()
    
    let validator = Validator(signUpVM: SignUpViewModel())
    // var isCertiActive: Bool?
    var timer: Timer?
        
    func sendMail(completion: @escaping() -> Void) {
        let mail_to = Mail.User(name: "mail_to", email: email)
        authCode = createEmailCode()
        let mail = Mail(
            from: mail_from,
            to: [mail_to],
            subject: "북다리 이메일 인증번호",
            text: emailContent(code: authCode ?? "")
        )
        
        DispatchQueue.global(qos: .background).async {
            smtp.send(mail){ error in
                if let error = error {
                    print(error.localizedDescription)
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                } else {
                    DispatchQueue.main.async {
                        print("메일 전송에 성공하였습니다.")
                        self.userAuthCode = ""
                        self.isEmailWrong = false
                        withAnimation() {
                            self.isEmailCertified = true
                        }                        
                        self.showingTime()
                        completion()
                    }
                }
            }
        }
    }
    
// MARK: - 타이머
    
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
                self.isEmailWrong = false
                timer.invalidate()
            }
        }
    }
    
    func reset() {
        authCode = nil
        isEmailCertified = false
        isEmailWrong = false
        timerReset()
    }
    
    func timerReset() {
        self.timeLabel = ""
        self.timeRemaining = 30
        self.timer?.invalidate()
        self.timer = nil
    }
    
// MARK: - 유효성 검사
    
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
    
    func validEmail(completion: @escaping() -> Void) {
        redundant.isValidEmail(email: email) { success in
            if success {
                if self.format.isValidEmail(email: self.email) {
                    self.sendMail() {
                        DispatchQueue.main.async {
                            print("이메일 인증 성공")
                            self.emailError = .success
                            completion()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print("이메일 인증 실패")
                        self.emailError = .invalid
                        completion()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.emailError = .redundant
                    completion()
                }
            }
        }
    }
    
    func validNickname(completion: @escaping() -> Void) {
        redundant.isValidNickname(nickname: nickname) { success in
            if success {
                if self.format.isValidNickname(nickname: self.nickname) {
                    DispatchQueue.main.async {
                        print("닉네임 인증 성공")
                        self.nicknameError = .success
                        completion()
                    }
                } else {
                    DispatchQueue.main.async {
                        print("닉네임 인증 실패")
                        self.nicknameError = .invalid
                        completion()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.nicknameError = .redundant
                    completion()
                }
            }
        }
    }
    
    func validAuthCode(completion: @escaping(Bool) -> Void) {
        if userAuthCode == self.authCode {
            completion(true)
        } else {
            completion(false)
        }
    }
            
// MARK: - User 저장
    
    func signUp(completion: @escaping (Bool) -> Void) {
        if isValidPhone() && isValidPwd() && isValidPwdConfirm() {
            FirestoreSignUpManager.shared.register(email: self.email, password: self.password, nickname: self.nickname, phoneNumber: self.phoneNumer) {
                completion(true)
            }
                    
        } else {
            print("error")
            completion(false)
        }
    }
    
//    func convertUserModelToDictionary(user: UserModel) -> [String : Any] {
//        let userData = [
//            "id" : user.id ?? "",  // change these according to you model
//            "email": user.email ?? "",
//            "password": user.passsword ?? "",
//            "nickname": user.nickname ?? "",
//            "phoneNumber": user.phoneNumber ?? "",
//            "profileURL": user.profileURL ?? "person.fill",
//            "distance": user.distance ?? 1,
//            "joinDate": user.joinDate ?? "",
//            "dong": user.dong ?? ""
//        ] as [String : Any]
//        
//        return userData as [String : Any]
//    }
//    
//    func convertLocationToDictionary(location: Location) -> [String : Any] {
//        let locationData = [
//            "id": location.id ?? "",
//            "lat": location.lat ?? 37.49235,
//            "long": location.long ?? 127.0056634,
//        ] as [String : Any]
//        
//        return locationData as [String : Any]
//    }
//                
//    func addUser(id: String) {
//        let user = UserModel(
//            id: id,
//            email: email,
//            passsword: password,
//            nickname: nickname,
//            phoneNumber: phoneNumer,
//            profileURL: "person.fill", // 기본 system image
//            distance: 1,
//            joinDate: Date(),
//            dong: [LocationManager.shared.distriction]
//        )
//        let userData = convertUserModelToDictionary(user: user)
//              
//        db.collection("User").document(id).setData(userData)  { err in
//            if let err = err {
//                print(err.localizedDescription)
//            } else {
//                print("User has been saved!")
//            }
//        }
//    }
//                   
//    func addUserLocation(userId: String) {
//        let document = db.collection("User").document(userId).collection("Location").document()
//        let documentId = document.documentID
//        let location = Location (
//            id: documentId,
//            lat: LocationManager.shared.lat,
//            long: LocationManager.shared.long
//        )
//        let locationData = convertLocationToDictionary(location: location)
//        
//        document.setData(locationData, merge: false) { err in
//            if let err = err {
//                print(err.localizedDescription)
//            } else {
//                print("Location has been saved!")
//            }
//        }
//    }
    
    
                    
//    func register(completion: @escaping () -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                guard let user = result?.user else { return }
//                self.addUser(id: user.uid)
//                self.addUserLocation(userId: user.uid)
//                completion()
//            }
//        }
//    }
        
}
