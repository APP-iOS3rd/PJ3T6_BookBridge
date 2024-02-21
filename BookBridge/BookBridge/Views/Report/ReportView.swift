//
//  ReportView.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/13.
//

import Foundation


import SwiftUI

struct ReportView: View {

    @State private var isTitleHidden: Bool = false
    @StateObject var reportVM: ReportViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                    Text("게시물 제목란:")
                    .bold()
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 21)
                    .padding(.top, 15)


                Text("해당 게시글을 신고하는 이유를 알려주세요.")
                .bold()
                .font(.system(size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 21)
                .padding(.bottom, 15)
                
                Divider()
                
                ForEach(Report.ReportReason.allCases, id: \.self){ reason in
                    NavigationLink(destination: ReportDetailView(reportVM: reportVM, title: reason.rawValue)){
                        ReportCellView(contents: reason.rawValue)
                            .onDisappear(){
                                reportVM.updateReportReason(reason: reason)
                                reportVM.report.targetType = .post //임시로 게시물로 해놓음
                            }
                    }
                    
                }

                Spacer()
            }
        }.navigationBarTitle("\(Report.TargetType.post.rawValue) 신고", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼 숨기기

    }
}

//종현님 신고하기 버튼 개발시 연동 필요
struct TestView1: View {
    var body: some View {
        NavigationStack{
            VStack{
                NavigationLink(destination: ReportView(reportVM: ReportViewModel())){
                    VStack{
                        Text("신고하기")
                    }
                }
            }
        }

    }
}
