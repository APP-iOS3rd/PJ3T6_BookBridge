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

class SMSAuthViewModel: ObservableObject, FirestoreFindable, FirebaseAuth, Changable {
    @Published var email = ""
    
    
    @Published var emailStatusText: EmailError?
    
    
    
    private var cancellables = Set<AnyCancellable>()
    private var fomatValidator = FormatValidator()
                                
    
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
            .store(in: &cancellables)
    }
    
    func verifyEmailEmpty() -> Bool {
        if emailStatusText != .success {
            emailStatusText = .incomplete
            return false
        }
        return true
    }
    
   
    
    
    
        
}
