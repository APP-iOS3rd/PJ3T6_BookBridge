//
//  PostContent.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI

struct PostContent: View {
    @Binding var noticeBoard: NoticeBoard
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(noticeBoard.noticeBoardTitle)
                    .font(.system(size: 25, weight: .bold))
                    .padding(.top)
                
                Spacer().frame(height: 5)
                
                Text("\(ConvertManager.getTimeDifference(from: noticeBoard.date))")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "767676"))
                    .padding(.bottom)
                
                Text(noticeBoard.noticeBoardDetail)
                    .font(.system(size: 18))
                
                Spacer()
            }
            Spacer()
        }
        .frame(minHeight: 200)
        .padding(.horizontal)
    }
        
}
