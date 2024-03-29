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
    @State private var showToast: Bool = false
    
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
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15))
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
            
            HStack{
                Text(noticeBoard.noticeLocationName)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "767676"))
                    .padding(.leading, 5)
                Image(systemName: "clipboard")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "767676"))
                    .padding(.leading, 5)
                    .onTapGesture {
                        UIPasteboard.general.string = noticeBoard.noticeLocationName
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
            }
        }
        .frame(height: 300)
        .padding(.bottom)
        .overlay(
            ToastMessageView(isShowing: $showToast)
                .padding(.bottom, 50) // Bottom padding
                .zIndex(1),
            alignment: .bottom
        )
    }
}

