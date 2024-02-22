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
            ForEach(postbooks.prefix(5)) { book in
                if let bookTitle = book.volumeInfo.title {
                    Text(bookTitle)
                        .padding(.bottom, 5) // 위아래 간격 설정
                        .frame(maxWidth: .infinity, alignment: .leading) // leading 정렬
                        .foregroundColor(Color(hex: "#5b5b5b"))
                }
            }
        }
        .padding(.horizontal)
    }
}
