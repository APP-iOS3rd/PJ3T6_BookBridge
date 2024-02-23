//
//  PostChangeLocationView.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI

struct PostChangeLocationView: View {
    @StateObject var postViewModel: PostViewModel
    @Binding var noticeBoard: NoticeBoard
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("교환 희망 장소")
                    .font(.system(size: 18, weight: .bold))
                
                Spacer()
            
                NavigationLink {
                    PostMapDetailView(noticeBoard: $noticeBoard)
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack {
                        Text("\(noticeBoard.noticeLocationName)")
                            .font(.system(size: 15))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 15))
                    }
                    .foregroundStyle(Color(hex: "767676"))
                }
            }
            .padding(.top)
            .padding(.horizontal)
            
            if noticeBoard.noticeLocation.count >= 2 {
                PostMapView(
                    lat: $noticeBoard.noticeLocation[0],
                    lng: $noticeBoard.noticeLocation[1],
                    isDetail: false
                )
            }
        }
        .frame(height: 300)
        .padding(.bottom)
    }
}
