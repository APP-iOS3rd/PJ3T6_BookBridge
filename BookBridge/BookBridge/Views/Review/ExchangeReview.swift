//
//  ExchangeReview.swift
//  BookBridge
//
//  Created by 이현호 on 3/11/24.
//

import SwiftUI
import Kingfisher

struct ExchangeReview: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var notificationViewModel: NotificationViewModel
    @StateObject var chatMessageViewModel: ChatMessageViewModel
    
    @State var isSatisfied = false
    @State var isSoso = false
    @State var isUnsatisfied = false
    
    var chatRoomPartner: ChatPartnerModel
    
    var body: some View {
        VStack {
            KFImage(URL(string: chatRoomPartner.partnerImageUrl))
                .placeholder{
                    Image("Character")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(40)
                        .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color(hex: "D9D9D9"), lineWidth: 1)
                        )
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(40)
                .padding()
            
            HStack {
                Text(chatRoomPartner.nickname)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color(hex: "B04848"))
                Text("님과의")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding(.bottom, 5)
            
            Text("교환은 어땠나요?")
                .font(.system(size: 30, weight: .bold))
                .padding(.bottom, 30)
            
            HStack(spacing: 20) {
                Button {
                    self.isSatisfied.toggle()
                    isSoso = false
                    isUnsatisfied = false
                    
                } label: {
                    VStack {
                        Text("😃")
                            .font(.system(size: 50))
                            .opacity(isSatisfied ? 1 : 0.4)
                        Text("만족해요")
                            .font(.system(size: 15))
                            .foregroundStyle(.black)
                            .opacity(isSatisfied ? 1 : 0.4)
                    }
                }
                
                Button {
                    self.isSoso.toggle()
                    isSatisfied = false
                    isUnsatisfied = false
                } label: {
                    VStack {
                        Text("😐")
                            .font(.system(size: 50))
                            .opacity(isSoso ? 1 : 0.4)
                        Text("보통이에요")
                            .font(.system(size: 15))
                            .foregroundStyle(.black)
                            .opacity(isSoso ? 1 : 0.4)
                    }
                }
                
                Button {
                    self.isUnsatisfied.toggle()
                    isSatisfied = false
                    isSoso = false
                } label: {
                    VStack {
                        Text("😮‍💨")
                            .font(.system(size: 50))
                            .opacity(isUnsatisfied ? 1 : 0.4)
                        Text("별로에요")
                            .font(.system(size: 15))
                            .foregroundStyle(.black)
                            .opacity(isUnsatisfied ? 1 : 0.4)
                    }
                }
            }
            .padding(.bottom, 30)
            
            Button {
                var reviewIndex: Int?
                var reviewText: String?
                
                if isSatisfied {
                    reviewIndex = 0
                    reviewText = "만족해요"
                } else if isSoso {
                    reviewIndex = 1
                    reviewText = "보통이에요"
                } else if isUnsatisfied {
                    reviewIndex = 2
                    reviewText = "별로에요"
                } else { return }
                
                guard let index = reviewIndex, let text = reviewText else { return }
                 
                // 프로필 리뷰정보 업데이트
                notificationViewModel.updatePartnerReview(partnerId: chatRoomPartner.partnerId, reviewIndex: index)
                
                // 알림 정보를 Firebase에 저장
                let notification = NotificationModel(userId: chatRoomPartner.partnerId, noticeBoardId: chatMessageViewModel.noticeBoardInfo.id, partnerId: UserManager.shared.uid, partnerImageUrl: UserManager.shared.user?.profileURL ?? "" ,noticeBoardTitle: chatMessageViewModel.noticeBoardInfo.noticeBoardTitle, nickname: UserManager.shared.user?.nickname ?? "", review: text, date: Date())
                
                notificationViewModel.saveNotification(notification: notification)
                
                dismiss()
            } label: {
                Text("평가하기")
                    .font(.system(size: 17))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(hex: "59AAE0"))
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
    }
}
