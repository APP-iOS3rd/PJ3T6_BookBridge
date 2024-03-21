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
    @StateObject var viewModel = ChatMessageViewModel()
    @State private var showExchangeReview = false
    @State private var showResultReview = false
    @State var selectedPartner: ChatPartnerModel?
    @State var id: String = ""
    
    var body: some View {
        VStack {
//            if notificationViewModel.notifications.isEmpty {
//                Text("아직 받은 알림이 없어요.")
//                    .foregroundColor(.secondary)
//                    .font(.headline)
//                    .padding()
//            } else {
                List {
                    ForEach(notificationViewModel.notifications) { notification in
                        Button {
                            self.selectedPartner = ChatPartnerModel(
                                nickname: notification.nickname,
                                noticeBoardId: notification.noticeBoardId,
                                partnerId: notification.partnerId,
                                partnerImage: UIImage(named: "DefaultImage")!,
                                partnerImageUrl: notification.partnerImageUrl,
                                reviews: [0, 0, 0],
                                style: "칭호 미아"
                            )
                            id = notification.id
                            print("Showing ExchangeReview")
                            self.showExchangeReview = true
                            notificationViewModel.updateIsRead(notificationId: notification.id)
                        }
                        label: {
                            VStack{
                                NotificationItemView(notificationModel: notification)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            notificationViewModel.deleteNotification(id: notificationViewModel.notifications[index].id)
                        }
                    })
                }
                .listStyle(.plain)                
                .sheet(isPresented: $showExchangeReview) {
                    // 옵셔널 바인딩을 사용하여 selectedPartner가 nil이 아닌 경우에만 ExchangeReview를 표시
                    if let partner = selectedPartner {
                        ExchangeReview(notificationViewModel: notificationViewModel, chatMessageViewModel: viewModel, id: id, chatRoomPartner: partner)
                            .presentationDetents([.fraction(0.65),])
                    }
                }
            }
//        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
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
        .sheet(isPresented: $showExchangeReview) {
            // 옵셔널 바인딩을 사용하여 selectedPartner가 nil이 아닌 경우에만 ExchangeReview를 표시
            if let partner = selectedPartner {
                ExchangeReview(notificationViewModel: notificationViewModel, chatMessageViewModel: viewModel, id: id, chatRoomPartner: partner)
                    .presentationDetents([.fraction(0.65),])
            }
        }
    }
}
