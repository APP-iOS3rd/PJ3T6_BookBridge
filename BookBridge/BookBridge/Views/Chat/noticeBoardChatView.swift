//
//  noticeBoardChatView.swift
//  BookBridge
//
//  Created by 이현호 on 2/14/24.
//

import SwiftUI

struct noticeBoardChatView: View {
    
    @State var isReserved = false
    @State var isExchanged = false
    
    var body: some View {
        HStack {
            Image(systemName: "book.closed.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 41)
                .padding(.trailing, 4)
            VStack(alignment:.leading) {
                Text("난중일지와 교환해봅니다")
                    .bold()
                    .padding(.bottom, 1)
                    .multilineTextAlignment(.leading)
                Text("광교 2동")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
            .padding(.trailing)
            
            Spacer()
            
            Button(action: {
                isReserved.toggle()
                if isReserved {
                    isExchanged = false
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(isReserved ? Color.blue : Color(.lightGray))
                        .frame(width: 60, height: 30)
                    Text("예약중")
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }
            
            Button(action: {
                isExchanged.toggle()
                if isExchanged {
                    isReserved = false
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(isExchanged ? Color.green : Color(.lightGray))
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

#Preview {
    noticeBoardChatView()
}
