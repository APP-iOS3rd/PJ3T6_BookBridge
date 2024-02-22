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
    @ObservedObject var reportVM: ReportViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{

                Text("해당 \(reportVM.report.targetType.rawValue)을 신고하는 이유를 알려주세요.")
                .bold()
                .font(.system(size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 21)
                .padding(.bottom, 15)
                .padding(.top, 15)
                
                Divider()
                
                ForEach(Report.ReportReason.allCases, id: \.self){ reason in
                    NavigationLink(destination: ReportDetailView(reportVM: reportVM, title: reason)){
                        ReportCellView(contents: reason.rawValue)
                    }
                    
                }

                Spacer()
            }
        }.navigationBarTitle("\(reportVM.report.targetType.rawValue) 신고", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼 숨기기

    }
}

