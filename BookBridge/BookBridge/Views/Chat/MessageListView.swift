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
    @State var scrollViewHeight: CGFloat = 0
    @State var scrollBottomOffset: CGFloat = 0
    @State private var lowestMaxY: CGFloat = CGFloat.infinity
    @State private var keyboardHeight: CGFloat = 0
    
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
                    HStack {
                        Spacer()
                    }
                    .id(Self.emptyScrollToString)
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
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                        let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                        let height = value?.height ?? 0
                        keyboardHeight = height
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        keyboardHeight = 0
                    }
                }
                .onDisappear {
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                }
                .background(
                   GeometryReader { geometry in
                       Color.clear.onAppear {
                           DispatchQueue.main.async {
                               scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                           }
                       }
                       .onChange(of: geometry.frame(in: .global).maxY) { newValue in
                           let scrollViewHeight = geometry.size.height
                           let threshold = scrollViewHeight - keyboardHeight
                           
                           print("scrollViewHeight: \(scrollViewHeight)")
                           print("newValue: \(newValue)")
                           print("threshold: \(threshold)")
                           isAtBottom = newValue > threshold
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
                    .foregroundStyle(.blue.opacity(0.8))
                    .font(.largeTitle)
                    .padding()
            }
            .opacity(isAtBottom ? 1 : 0)
        }
    }
}
