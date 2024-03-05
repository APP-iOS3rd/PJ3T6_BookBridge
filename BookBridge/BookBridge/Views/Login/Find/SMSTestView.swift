//
//  SMSTestView.swift
//  BookBridge
//
//  Created by 이민호 on 3/5/24.
//

import SwiftUI

struct SMSTestView: View {
    @StateObject var smsAuthVM = SMSAuthViewModel()
    var body: some View {
        VStack {
            TextField("휴대폰번호 입력", text: $smsAuthVM.phoneNumber)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Button {
                smsAuthVM.pushVerificationNumber()
            } label: {
                Text("전송")
            }
            
            TextField("인증번호 입력", text: $smsAuthVM.certificationNum)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Button {
                smsAuthVM.verifyLogin()
            } label: {
                Text("확인")
            }
        }
        
        
            
    }
}

#Preview {
    SMSTestView()
}
