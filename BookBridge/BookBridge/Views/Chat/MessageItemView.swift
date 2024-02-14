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
    var uid: String
    
    var body: some View {
        VStack {
            if messageModel.sender == uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(messageModel.message)
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color(hex:"59AAE0"))
                    .cornerRadius(10)
                }
            } else {
                HStack {
                    HStack {
                        Text(messageModel.message)
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color(hex:"767676"))
                    .cornerRadius(10)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}
