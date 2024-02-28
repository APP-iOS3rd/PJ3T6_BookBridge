//
//  InquiryDetailView.swift
//  BookBridge
//
//  Created by 이현호 on 2/27/24.
//

import SwiftUI

struct InquiryView: View {
    @ObservedObject var inquiryVM: InquiryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    @State private var showAlert: Bool = false
    @State private var selectedCategory: Inquiry.InquiryCategory = .accountInquiry
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            VStack (alignment: .leading) {
                Text("문의 유형")
                    .bold()
                VStack {
                    HStack {
                        Picker("Choose a category", selection: $selectedCategory) {
                            ForEach(Inquiry.InquiryCategory.allCases, id: \.self) { category in
                                Text(category.rawValue)
                            }
                        }
                        .tint(.black)
                        
                        Spacer()
                    }
                    .pickerStyle(.menu)

                    Rectangle()
                        .fill(Color(hex: "B5B5B5"))
                        .frame(height: 1)
                }
                .padding(.bottom, 20)
                
                Text("문의 내용")
                    .bold()
                ZStack (alignment: .topLeading) {
                    Rectangle()
                        .foregroundStyle(Color(hex: "F4F4F4"))
                        .cornerRadius(10)
                        .frame(height: 300)
                    TextField("문의 내용을 입력해주세요.", text: $text, axis: .vertical)
                        .padding()
                        .frame(height: 300, alignment: .topLeading)
                        .onChange(of: text, perform: {
                            text = String($0.prefix(1000)) // 텍스트 글자수 제한
                        })
                }
                HStack {
                    Spacer()
                    InquiryCounterView(text: $text)
                        .bold()
                        .frame(alignment: .leading)
                }
                .padding(.bottom, 20)
                
                Button {
                    // 뷰모델 연결
                    inquiryVM.inquiry.inquiryComments = text
                    inquiryVM.inquiry.inquiryUserId = UserManager.shared.uid
                    inquiryVM.inquiry.category = selectedCategory
                    inquiryVM.saveInquiryToFirestore(inquiry: inquiryVM.inquiry)
                    
                    showAlert = true
                } label: {
                    Text("문의하기")
                        .font(.system(size: 17))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "59AAE0"))
                        .cornerRadius(5.0)
                }
                .alert(isPresented: $showAlert){
                    Alert(
                        title: Text("문의가 접수되었습니다."),
                        dismissButton: .default(Text("확인")) {
                            text = ""
                        }
                    )
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("문의 및 건의사항", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼 숨기기
    }
}

// 글자수 카운트
struct InquiryCounterView: View {
    @Binding var text: String
    var counter: Int = 0
    
    init(text: Binding<String>) {
        self._text = text
        counter = self._text.wrappedValue.count
    }
    
    var body: some View {
        Text("\(counter) / 1000")
            .font(.caption)
            .foregroundStyle(.black)
    }
}
