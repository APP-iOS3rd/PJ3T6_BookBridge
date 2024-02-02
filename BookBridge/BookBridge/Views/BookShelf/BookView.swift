//
//  BookView.swift
//  BookBridge
//
//  Created by 김건호 on 2/2/24.
//

import SwiftUI

struct BookView: View {
    @EnvironmentObject var viewModel: BookShelfViewModel
    @Binding var selectedBook: Item?
    
    var tap: tapInfo
    
    var books: [Item] {
        switch tap {
        case .wish:
            return viewModel.wishBooks.flatMap { $0.items }
        case .hold:
            return viewModel.holdBooks.flatMap { $0.items }
        }
    }
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(books, id: \.id) { book in
                    VStack {
                        if let urlString = book.volumeInfo.imageLinks?.smallThumbnail, let url = URL(string: urlString) {
                            AsyncImage(url: url)
                                .frame(width: (UIScreen.main.bounds.width - 60) / 3, height: 164)
                                .cornerRadius(8)
                                .onTapGesture{
                                    selectedBook = book
                                }
                        }
                        Text(book.volumeInfo.title ?? "Unknown Title")
                            .frame(maxWidth: .infinity, alignment: .center) // 텍스트 뷰 크기 조정
                    }
                    .frame(width: (UIScreen.main.bounds.width - 60) / 3) // VStack에 대한 프레임 설정
                }
            }
        }
    }
}

