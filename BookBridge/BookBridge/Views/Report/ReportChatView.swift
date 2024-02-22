//
//  ReportChatView.swift
//  BookBridge
//
//  Created by 이현호 on 2/21/24.
//

import Foundation
import SwiftUI

struct ReportChatView: View {
    
    @State private var isTitleHidden: Bool = false
    @StateObject var reportVM: ReportViewModel
    @Environment(\.dismiss) private var dismiss
    
    var nickname: String
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack (spacing: 1) {
                    Image("Character")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(.trailing, -6)
                    
                    Text("\'\(nickname)\'")
                        .bold()
                        .font(.system(size: 18))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 21)
                .padding(.top, 15)
                
                Text("사용자를 신고하는 이유를 알려주세요.")
                    .bold()
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 21)
                    .padding(.bottom, 15)
                
                Divider()
                
                List {
                    ForEach(Report.ReportReason.allCases, id: \.self) { reason in
                        NavigationLink(destination: ReportDetailView(reportVM: reportVM, title: reason.rawValue)){
                            Text(reason.rawValue)
                                .onDisappear() {
                                    reportVM.updateReportReason(reason: reason)
                                    reportVM.report.targetType = .chat
                                }
                        }
                    }
                }
                .listStyle(.plain)
                
                Spacer()
            }
        }
        .navigationBarTitle("사용자 신고", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼 숨기기
    }
}
