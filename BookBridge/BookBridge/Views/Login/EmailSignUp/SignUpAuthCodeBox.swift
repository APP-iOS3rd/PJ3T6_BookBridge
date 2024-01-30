//
//  SignUpAuthCodeView.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import SwiftUI

struct SignUpAuthCodeBox: View {
    @StateObject var signUpVm: SignUpVM    
    @State var status: Bool?
    
    var body: some View {
        VStack {
            HStack {
                Text("인증번호")
                    .font(.system(size: 10))
                    .foregroundStyle(Color(hex: "999999"))
                                            
                if signUpVm.timeLabel != "" {
                    Text(signUpVm.timeLabel)
                        .font(.system(size: 10))
                        .foregroundStyle(Color(hex: "FF0000"))
                }
                
                Spacer()
            }
                        
            HStack {
                TextField("인증번호를 입력해주세요", text: $signUpVm.userAuthCode)
                    .padding()
                    .foregroundColor(Color(hex: "3C3C43"))
                    .frame(height: 36)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "F7F8FC"))
                    .cornerRadius(5.0)
                
                if signUpVm.userAuthCode == "" {
                    ResendBtn()
                } else {
                    AuthConfirmBtn()
                }
            }
            
            if let status = status {
                if status {
                    StatusText(text: "올바른 인증번호 입니다.", color: "0A84FF")
                } else {
                    StatusText(text: "잘못된 인증번호 입니다.", color: "F80B0B")
                }
            }
        }
    }
    
    @ViewBuilder
    func AuthConfirmBtn() -> some View {
        Button {
            if signUpVm.isCertiCode() {
                status = true
            } else {
                status = false
            }
        } label: {
            Text("인증완료")
                .font(.system(size: 17))
                .foregroundStyle(.white)
                .frame(width: 100, height: 36)
                .background(Color(hex: "59AAE0"))
                .cornerRadius(5.0)
        }
    }
    
    @ViewBuilder
    func ResendBtn() -> some View {
        Button {
            signUpVm.sendMail()
        } label: {
            Text("재전송")
                .font(.system(size: 17))
                .foregroundStyle(Color(hex: "59AAE0"))
                .frame(width: 100, height: 36)
                .border(Color(hex: "59AAE0"), width: 2)
                .background(.white)
                .cornerRadius(5.0)
        }
    }
}

#Preview {
    SignUpAuthCodeBox(signUpVm: SignUpVM())
}
