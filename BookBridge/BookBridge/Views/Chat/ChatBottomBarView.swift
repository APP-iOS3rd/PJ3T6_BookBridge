//
//  ChatBottomBarView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI

struct ChatBottomBarView: View {
    @StateObject var viewModel: ChatMessageViewModel
    @State var chatTextArr: [Substring] = []
    @State var isPlusBtn = true
    
    var chatRoomListId: String
    var partnerId: String
    var uid: String
    
    var body: some View {
        HStack (spacing: 12) {
            Button {
                isPlusBtn.toggle()
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 23, height: 23)
                    .rotationEffect(.degrees(isPlusBtn ? 0 : 45))
                    .foregroundStyle(Color(.darkGray))
            }
            
            ZStack {
                HStack {
                    Text("내용을 입력해주세요")
                        .foregroundColor(Color(.gray))
                        .font(.system(size: 17))
                        .padding(.leading, 10)
                    Spacer()
                }
                
                TextEditor(text: $viewModel.chatText)
                    .opacity(viewModel.chatText.isEmpty ? 0.5 : 1)
                    .padding(.leading, 6)
                    .padding(.trailing, 6)
                    .frame(minHeight: 40, maxHeight: 120)
                    .fixedSize(horizontal: false, vertical: true)
                    .onChange(of: viewModel.chatText) { _ in
                        withAnimation {
                            chatTextArr = viewModel.chatText.split{ $0 == " " || $0 == "\n"}
                        }
                    }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.gray, lineWidth: 1)
            )
            
            Button {
                if !chatTextArr.isEmpty {
                    viewModel.handleSend(uid: uid, partnerId: partnerId, chatRoomListId: chatRoomListId)
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(chatTextArr.isEmpty ? Color.gray : Color(hex:"59AAE0"))
            }
            .disabled(chatTextArr.isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    ChatRoomListView(uid: "lee")
}
