//
//  MessageItemView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI

struct MessageItemView: View {
    @StateObject var viewModel: ChatMessageViewModel

    var messageModel: ChatMessageModel
    var partnerId: String
    var partnerImage: UIImage
    var uid: String
    
    var body: some View {
        VStack {
            if messageModel.sender == uid {
                if messageModel.imageURL == "" {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Spacer()
                            Text(messageModel.timeAgo)
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text(messageModel.message)
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(hex:"59AAE0"))
                        .cornerRadius(10)
                    }
                } else {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Spacer()
                            Text(messageModel.timeAgo)
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        Image(uiImage: viewModel.chatImages[messageModel.imageURL] ?? UIImage(named: "DefaultImage")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                    }
                }
                
            } else {
                if messageModel.imageURL == "" {
                    HStack {
                        Image(uiImage: partnerImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .clipped()
                            .cornerRadius(15)
                        
                        HStack {
                            Text(messageModel.message)
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(hex:"767676"))
                        .cornerRadius(10)
                        
                        VStack {
                            Spacer()
                            Text(messageModel.timeAgo)
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                    }
                } else {
                    HStack {
                        Image(uiImage: partnerImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .clipped()
                            .cornerRadius(15)
                        
                        
                        Image(uiImage: viewModel.chatImages[messageModel.imageURL] ?? UIImage(named: "DefaultImage")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                        
                        
                        VStack {
                            Spacer()
                            Text(messageModel.timeAgo)
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .onAppear {
            if self.messageModel.imageURL != "" {
                viewModel.getChatImage(urlString: messageModel.imageURL)
            }
        }
    }
}


#Preview {
    ChatRoomListView(uid: "lee")
}
