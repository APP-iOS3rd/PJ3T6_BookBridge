//
//  ReportDetailView.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/13.
//

import SwiftUI

struct ReportDetailView: View {
    
    @ObservedObject var reportVM: ReportViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    @State private var showAlert: Bool = false
    @State private var isTargetView = false
    let title: String
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationStack{
                ZStack(alignment: .topLeading){
                    
                        TextField("신고하는 이유를 추가 설명해 주세요.", text: $text, axis: .vertical)
                        .padding(.horizontal, 10) // 여기에 원하는 만큼의 패딩 값을 추가
                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height * 0.5)
                            .cornerRadius(5) // 모서리 둥글게
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.15) // 상단
                            .padding(.top, geometry.safeAreaInsets.top) //
                    

                    Button {
                        reportVM.report.additionalComments = text
                        reportVM.report.reporterUserId = UserManager.shared.uid
                        
                        reportVM.saveReportToFirestore(report: reportVM.report)
                        
                        showAlert = true
                    } label: {
                        Text("신고하기")
                            .font(.system(size: 17))
                            .foregroundStyle(.white)
                            .frame(width: geometry.size.width * 0.88, height: 50)
                            .background(Color(hex: "59AAE0"))
                            .cornerRadius(5.0)
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6) // 하단에 위치
                    .padding(.bottom, geometry.safeAreaInsets.bottom) // 하단 세이프 에어리어만큼 패딩 추가
                }
                .alert(isPresented: $showAlert){
                    Alert(
                        title: Text("신고 접수가 완료되었습니다."),
                        dismissButton: .default(Text("확인")) {
                            isTargetView = true
                        }
                    )
                }
                .navigationDestination(isPresented: $isTargetView){
                    HomeView()
                }
                
            }

        }
        .navigationBarTitle(title, displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼 숨기기
        
        
    }
}
