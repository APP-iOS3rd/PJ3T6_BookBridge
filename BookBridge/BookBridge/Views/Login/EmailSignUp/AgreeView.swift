//
//  AgreeView.swift
//  BookBridge
//
//  Created by 김건호 on 3/18/24.
//
import SwiftUI

struct AgreeView: View {
    @Binding  var showingTermsSheet : Bool
    @State private var agreeToAll: Bool = false
    @State private var agreeToTerms: Bool = false
    @State private var ageSelection: AgeSelection? = nil
    @State private var termsExpanded = false
    @State private var showAlert: Bool = false
    
    var isContinueButtonEnabled: Bool {
        agreeToTerms && ageSelection != nil
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            //            Button {
            //                agreeToAll.toggle()
            //            } label: {
            //                HStack {
            //                    Image(systemName: agreeToAll ? "checkmark.circle.fill" : "circle")
            //                        .resizable()
            //                        .aspectRatio(contentMode: .fit)
            //                        .frame(width: 30, height: 30)
            //                        .foregroundColor(Color(hex: "59AAE0"))
            //                    Text("모두 동의")
            //                        .bold()
            //                        .foregroundColor(.black)
            //                }
            //            }
            //            .padding(.bottom,20)
            //
            //            Divider()
            
            HStack {
                Button {
                    agreeToTerms.toggle()
                } label: {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(agreeToTerms ? Color(hex: "59AAE0") : .gray)
                    Text("(필수) 책다리 약관 및 동의 사항")
                        .foregroundColor(.black)
                }
                Spacer()
                Button {
                    termsExpanded.toggle()
                } label: {
                    Image(systemName: termsExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            
            if termsExpanded {
                VStack(alignment: .leading) {
                    // Ensure the leading alignment matches the parent VStack
                    HStack{
                        Image(systemName: "")
                            .frame(width: 25)
                        Link(destination: URL(string: "https://internal-nest-08f.notion.site/39360863e97647e796cbe7a2788dcaea?pvs=4")!, label: {
                            Text("(필수) 서비스 이용약관")
                                .foregroundColor(.black)
                                .underline()
                        })
                        
                    }
                    HStack{
                        Image(systemName: "")
                            .frame(width: 25)
                        Link(destination: /*@START_MENU_TOKEN@*/URL(string: "https://www.apple.com")!/*@END_MENU_TOKEN@*/, label: {
                            Text("(필수) 개인정보 수집 및 이용")
                                .foregroundColor(.black)
                                .underline()
                        })
                    }
                    HStack{
                        Image(systemName: "")
                            .frame(width: 25)
                        Link(destination: URL(string: "https://internal-nest-08f.notion.site/4817aab9cde548e39b456fa3e7daf2a0?pvs=4")!, label: {
                            Text("(필수) 위치 정보 수집 및 이용")
                                .foregroundColor(.black)
                                .underline()
                        })
                    }
                }
            }
            
            Divider()
            
            Text("최소 연령 확인")
                .bold()
                .padding(.top,20)
            
            AgeCheckButton(isOn: ageSelection == .adult, title: "만 14세 이상이에요") {
                ageSelection = .adult
            }
            AgeCheckButton(isOn: ageSelection == .notAdult, title: "만 14세 미만이에요") {
                ageSelection = .notAdult
                
            }
            
            Spacer()
            
            Button {
                if ageSelection == .notAdult {
                    // 만 14세 미만 선택 시 경고창 먼저 표시
                    showAlert = true
                } else if isContinueButtonEnabled {
                    // 나머지 조건 충족 시 계속하기 로직 실행
                    showingTermsSheet = false
                }
            } label: {
                Text("계속하기")
                    .foregroundColor(.white)
                    .font(.system(size: 20).bold())
                    .frame(width: 353, height: 50)
                    .background(isContinueButtonEnabled ? Color(hex: "59AAE0") : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!isContinueButtonEnabled)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("알림"),
                    message: Text("만 14세 이하는 가입할 수 없습니다."),
                    dismissButton: .default(Text("확인"), action: {                        
                        showingTermsSheet = false
                    })
                )
            }

            
            
        }
        .padding(20)
        
        
    }
}

struct AgeCheckButton: View {
    var isOn: Bool
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(hex: "59AAE0"))
                Text(title)
                    .foregroundColor(.black)
                Spacer()
            }
        }
    }
}

enum AgeSelection {
    case adult, notAdult
}
