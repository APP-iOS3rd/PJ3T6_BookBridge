//
//  PostBookListView.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI

enum BookType {
    case HoldBooks
    case WantBooks
}

struct PostBookListView: View {
    @Binding var postbooks: [Item]
      
    var body: some View {
        VStack(spacing: 10) {
            if postbooks.isEmpty {
                Text("책이 없어요...")
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading) // leading 정렬
                    .frame(minHeight: 50)
                    .foregroundColor(Color(hex: "767676"))
            } else {
                ForEach(postbooks.prefix(5)) { book in
                    if let bookTitle = book.volumeInfo.title {
                        Text(bookTitle)
                            .padding(.bottom, 5) // 위아래 간격 설정
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading) // leading 정렬
                            .foregroundColor(Color(hex: "#5b5b5b"))
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
