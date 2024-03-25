//
//  MessageItemView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI

struct MessageListView: View {
    @EnvironmentObject private var pathModel: TabPathViewModel
    @StateObject var viewModel: ChatMessageViewModel
    @State var showToast = false
    @State var isScrollToBottom = false
    
    @State var isAtBottom = false
    @State private var lowestMaxY: CGFloat = CGFloat.infinity
    
    var chatRoomPartner: ChatPartnerModel
    var uid: String
    
    static let emptyScrollToString = "Empty"
    
    var body: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                LazyVStack {
                    ForEach(viewModel.chatMessages) { chatMessage in
                        MessageItemView(
                            viewModel: viewModel,
                            chatLocation: chatMessage.location,
                            chatLocationTuple: (chatMessage.location[0],chatMessage.location[1]),
                            showToast: $showToast,
                            chatRoomPartner: chatRoomPartner,
                            messageModel: ChatMessageModel(date: chatMessage.date, imageURL: chatMessage.imageURL, location: chatMessage.location, message: chatMessage.message, sender: chatMessage.sender),
                            uid: uid
                        )
                    }
                    HStack{
                        // 숨겨진 뷰를 사용하여 최하단에 표시
                        Color.clear
                            .frame(width: 0, height: 0)
                            .id(Self.emptyScrollToString)
                    }


                }
                .rotationEffect(.degrees(180)).scaleEffect(x: -1, y: 1, anchor: .center)
                // 자동 스크롤
                .onReceive(viewModel.$count) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                    }
                }
                // 최하단 스크롤 버튼 기능
                .onChange(of: isScrollToBottom) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                    }
                }
                .background(
                   GeometryReader { geometry in
                       Color.clear.onAppear {
                           DispatchQueue.main.async {
                               lowestMaxY = geometry.frame(in: .global).maxY
                           }
                       }
                       .onChange(of: geometry.frame(in: .global).maxY) { newValue in
                           isAtBottom = newValue > lowestMaxY
                       }
                   }
               )
            }
        }
        .rotationEffect(.degrees(180)).scaleEffect(x: -1, y: 1, anchor: .center)
        .overlay(
            ToastMessageView(isShowing: $showToast)
                .zIndex(1),
            alignment: .bottom
        )
        // 최하단 스크롤
        .overlay(alignment: .bottomTrailing) {
            Button {
                withAnimation(.easeOut(duration: 0.5)) {
                    isScrollToBottom.toggle()
                }
            } label: {
                Image(systemName: "chevron.down.circle.fill")
                    .foregroundStyle(Color(.lightGray))
                    .font(.largeTitle)
                    .padding()
            }
            .opacity(isAtBottom ? 1 : 0)
        }
    }
}
