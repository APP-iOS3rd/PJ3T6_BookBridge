//
//  SMSAuthViewModel.swift
//  BookBridge
//
//  Created by 이민호 on 3/5/24.
//

import Foundation
import FirebaseAuth
import FirebaseMessaging
import Combine
import SwiftUI

class SMSAuthViewModel: ObservableObject, FirestoreFindable {
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var certificationNum = ""
    @Published var verificationID: String?
    
    @Published var emailStatusText: EmailError?
    @Published var phoneNumberStatusText: PhoneError?
    @Published var certificationNumStatusText: CertificationError?
    
    private var cancellables = Set<AnyCancellable>()
        
    func pushVerificationNumber() {
        let ph = "+82\(phoneNumber)"
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(ph, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print("pushVerficationNumber Error: \(error.localizedDescription)")
                    return
                } else {
                    print("SMS 전송 완료")
                }
                
                if let verificationID = verificationID {
                    self.verificationID = verificationID
                }
            }
    }
    
    func verifyLogin() {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: self.verificationID ?? "",
            verificationCode: certificationNum
        )
        
        Auth.auth().signIn(with: credential) { (success, error) in
              if let error = error {
                print("SMS 인증 실패: \(error.localizedDescription)")
                
              } else {
                print("SMS 인증 성공")
                  
              }
            }
    }
    
    func verifyEmail(isLoading: Binding<Bool>) {
        isLoading.wrappedValue = true
        
        checkEmailExists(email: email)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    isLoading.wrappedValue = false
                    print("Email 검증 완료")
                case .failure(let error):
                    isLoading.wrappedValue = false
                    print("Email 검증 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { exists in
                if exists {
                    print("이메일이 존재합니다.")
                    self.emailStatusText = .success
                } else {
                    print("이메일이 존재하지 않습니다.")
                    self.emailStatusText = EmailError.none
                }
            })
            .store(in: &cancellables) // Combine subscription을 관리하기 위해 저장
    }
    
    
}
