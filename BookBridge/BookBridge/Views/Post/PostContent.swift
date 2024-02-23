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
        VStack(alignment: .leading) {
            Text(noticeBoard.noticeBoardTitle)
                .font(.system(size: 25))
                .padding(.top)
                
            
            Text("\(ConvertManager.getTimeDifference(from: noticeBoard.date))")
                .foregroundStyle(Color(red: 153/255, green: 153/255, blue: 153/255))
                .font(.system(size: 10))
                .padding(.bottom)
                
            
            Text(noticeBoard.noticeBoardDetail)
                .font(.system(size: 15))
                
        }
        .padding(.horizontal)
        .frame(
            minWidth: UIScreen.main.bounds.width,
            minHeight: 200,
            alignment: Alignment.topLeading
        )
    }
        
}
