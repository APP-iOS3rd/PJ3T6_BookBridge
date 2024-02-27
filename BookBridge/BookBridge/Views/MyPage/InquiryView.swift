//
//  SwiftUIView.swift
//  BookBridge
//
//  Created by 이현호 on 2/27/24.
//

import SwiftUI

struct InquiryView: View {
    @State private var isTitleHidden = false
//    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("문의 유형을 선택해주세요!")
                    .bold()
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 21)
                    .padding(.bottom, 15)
                    .padding(.top, 15)
                
                Divider()
                
                ForEach(Inquiry.InquiryCategory.allCases, id: \.self){ reason in
                    NavigationLink(destination: InquiryDetailView()) {
                        ReportCellView(contents: reason.rawValue)
                    }
                }
                
                Spacer()
            }
        }
//        .navigationBarTitle("문의 및 건의사항", displayMode: .inline)
//        .navigationBarItems(leading: CustomBackButtonView())
//        .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼 숨기기
        
    }
}
