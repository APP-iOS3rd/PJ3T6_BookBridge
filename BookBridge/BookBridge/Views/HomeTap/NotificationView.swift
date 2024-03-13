//
//  AlarmView.swift
//  BookBridge
//
//  Created by 김건호 on 3/12/24.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var pathModel: TabPathViewModel
    @StateObject var notificationViewModel: NotificationViewModel
    @StateObject var viewModel: ChatMessageViewModel
    @State private var showExchangeReview = false
    
    var chatRoomPartner: ChatPartnerModel
    
    var body: some View {
           List {
               ForEach(notificationViewModel.notifications) { notification in
                   Button {
                       showExchangeReview = true
                   } label: {
                       VStack{
                           NotificationItemVIew(notificationModel: notification)
                       }
                   }
                   
               }
           }
           .navigationTitle("알림")
           .navigationBarTitleDisplayMode(.inline)
           .listStyle(.plain)
           .toolbar {
               ToolbarItem(placement: .topBarLeading) {
                   Button {
                       dismiss()
                   } label: {
                       Image(systemName: "chevron.left")
                           .foregroundStyle(.black)
                   }
               }
           }
           .onAppear {
               // 실시간 알림 감지 시작
               notificationViewModel.startNotificationListener()
           }
           .fullScreenCover(isPresented: $showExchangeReview) {
               ExchangeReview(notificationViewModel: notificationViewModel, chatMessageViewModel: viewModel, chatRoomPartner: chatRoomPartner)
           }
       }
   }
