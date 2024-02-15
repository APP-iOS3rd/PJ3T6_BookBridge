//
//  noticeBoardChatView.swift
//  BookBridge
//
//  Created by 이현호 on 2/14/24.
//

import SwiftUI

struct noticeBoardChatView: View {
    @StateObject var viewModel: ChatMessageViewModel
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "book.closed.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 41)
                    .padding(.trailing, 4)
                
                VStack(alignment:.leading) {
                    Text(viewModel.noticeBoardInfo.noticeBoardTitle)
                        .bold()
                        .padding(.bottom, 1)
                        .multilineTextAlignment(.leading)
                    Text(viewModel.noticeBoardInfo.noticeBoardTitle)
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                }
                .padding(.trailing)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.noticeBoardInfo.state = 1
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(viewModel.noticeBoardInfo.state == 1 ? Color.blue : Color(.lightGray))
                        .frame(width: 60, height: 30)
                    Text("예약중")
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }
            
            Button(action: {
                viewModel.noticeBoardInfo.state = 2
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(viewModel.noticeBoardInfo.state == 2 ? Color.green : Color(.lightGray))
                        .frame(width: 60, height: 30)
                    Text("교환완료")
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal)
        
        Divider()
    }
}

