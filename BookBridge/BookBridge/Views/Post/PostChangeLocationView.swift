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
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top)
                
                Spacer()
                
                
                NavigationLink(destination: PostMapDetailView(noticeBoard: $noticeBoard)
                    .navigationBarBackButtonHidden()
                ) {
                    HStack {
                        Text("\(noticeBoard.noticeLocationName)")                            
                        Image(systemName: "chevron.right")
                            .frame(width: 5)
                    }
                    .foregroundStyle(Color(red: 153/255, green: 153/255, blue: 153/255))
                }
                .padding(.horizontal)
                .padding(.top)
            }
            
            if noticeBoard.noticeLocation.count >= 2 {
                PostMapView(
                    lat: $noticeBoard.noticeLocation[0],
                    lng: $noticeBoard.noticeLocation[1],
                    isDetail: false
                )
            }
        }
        .frame(height: 300)
        .padding(.bottom, 100)
    }
}
