//
//  FindPasswordViewModel.swift
//  BookBridge
//
//  Created by 이민호 on 3/7/24.
//

import Foundation
import FirebaseAuth
import FirebaseMessaging
import Combine
import SwiftUI

class FindPasswordViewModel: ObservableObject, FirestoreFindable {
    @Published var email = ""
    @Published var emailStatusText: EmailError?
    
    private var reservedEmail = ""
    private var cancellables = Set<AnyCancellable>()
    
    func verifyEmail(isLoading: Binding<Bool>, isComplete: Binding<Bool>) {
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
            }, receiveValue: {[weak self] exists in
                if exists {
                    print("이메일이 존재합니다.")
                    self?.sendPasswordReset(isLoading: isLoading, isComplete: isComplete)
                    
                } else {
                    print("이메일이 존재하지 않습니다.")
                    self?.emailStatusText = EmailError.none
                }
            })
            .store(in: &cancellables)
    }
    
    func sendPasswordReset(isLoading: Binding<Bool>, isComplete: Binding<Bool>) {
        
        Auth.auth().sendPasswordReset(withEmail: email) {[weak self] error in
            guard let error = error else {
                isLoading.wrappedValue = false
                isComplete.wrappedValue = true
                self?.emailStatusText = .success
                self?.resetEmail()
                print("메세지 보내기 성공")
                return
            }
            let nsError : NSError = error as NSError
            switch nsError.code {
            case 17011:
                isLoading.wrappedValue = false
                self?.emailStatusText = .invalid
                print("존재하지 않는 이메일 입니다")
            default:
                isLoading.wrappedValue = false
                self?.emailStatusText = .abnomal
                break
            }
        }
    }
    
    func resetEmail() {
        self.reservedEmail = email
        self.email = ""
        self.emailStatusText = nil
        cancellables.removeAll()
    }
    
    func resetReservedEmail() {
        self.reservedEmail = ""
    }
    
    func getReservedEmail() {
        self.email = reservedEmail
    }
}


