//
//  MessageItemView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI

struct MessageItemView: View {
       
    var messageModel: ChatMessageModel
    var partnerId: String
    var partnerImage: UIImage
    var uid: String
    
    var body: some View {
        VStack {
            if messageModel.sender == uid {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("오전 12:30")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    HStack {
                        Text(messageModel.message)
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(hex:"59AAE0"))
                    .cornerRadius(10)
                }
                
            } else {
                HStack {
                    Image(uiImage: partnerImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipped()
                        .cornerRadius(15)
                    
                    HStack {
                        Text(messageModel.message)
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(hex:"767676"))
                    .cornerRadius(10)
                    
                    VStack {
                        Spacer()
                        Text("오전 12:30")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}


#Preview {
    ChatRoomListView(uid: "lee")
}
