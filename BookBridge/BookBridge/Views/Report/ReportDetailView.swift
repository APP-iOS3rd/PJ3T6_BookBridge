//
//  ReportDetailView.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/13.
//

import SwiftUI

struct ReportDetailView: View {
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var pathModel: TabPathViewModel
    @ObservedObject var reportVM: ReportViewModel
    
    @FocusState var isShowKeyboard: Bool

    @State private var text: String = ""
    @State private var showAlert: Bool = false
    @State private var isTargetView = false
    
    let title: Report.ReportReason
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            //키보드 제스처 관련
            ClearBackground(
                isFocused: $isShowKeyboard
            )
            .onTapGesture {
                isShowKeyboard = false
            }
            
            VStack (alignment: .leading) {
                Text("신고 내용")
                    .bold()
                ZStack (alignment: .topLeading) {
                    
                    Rectangle()
                        .foregroundStyle(Color(hex: "F4F4F4"))
                        .cornerRadius(10)
                        .frame(maxHeight: .infinity)
                    
                    TextField("신고 내용을 입력해주세요.", text: $text, axis: .vertical)
                        .padding()
                        .frame(maxHeight: .infinity, alignment: .topLeading)
                        .onChange(of: text, perform: {
                            text = String($0.prefix(300)) // 텍스트 글자수 제한
                        })
                }
                HStack {
                    Spacer()
                    CounterView(text: $text)
                        .bold()
                        .frame(alignment: .leading)
                }
                .padding(.bottom, 20)
                
                Button {
                    reportVM.report.additionalComments = text
                    reportVM.report.reporterUserId = UserManager.shared.uid
                    reportVM.report.reason = title
                    reportVM.saveReportToFirestore(report: reportVM.report)
                    
                    showAlert = true
                } label: {
                    Text("신고하기")
                        .font(.system(size: 17))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "59AAE0"))
                        .cornerRadius(5.0)
                }
                .alert(isPresented: $showAlert){
                    Alert(
                        title: Text("신고 접수 완료"),
                        message: Text("신고 내용은 24시간 이내 조치됩니다."),
                        dismissButton: .default(Text("확인")) {
                            pathModel.paths.removeAll()
                            text = ""
                        }
                    )
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle(title.rawValue, displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼 숨기기
        
    }
}

// 글자수 카운트
struct CounterView: View {
    @Binding var text: String
    var counter: Int = 0
    
    init(text: Binding<String>) {
        self._text = text
        counter = self._text.wrappedValue.count
    }
    
    var body: some View {
        Text("\(counter) / 300")
            .font(.caption)
            .foregroundStyle(.black)
    }
}
