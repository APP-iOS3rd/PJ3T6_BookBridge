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
            return viewModel.wishBooks
        case .hold:
            return viewModel.holdBooks
        }
    }
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.filteredBooks, id: \.id) { book in
                    VStack {
                        if let urlString = book.volumeInfo.imageLinks?.smallThumbnail, let url = URL(string: urlString) {
                            AsyncImage(url: url){
                                image in
                                image
                                    .frame(width: (UIScreen.main.bounds.width - 60) / 3, height: 164)
                                    .cornerRadius(8)
                                    .onTapGesture{
                                        selectedBook = book
                                    }
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 60, height: 80)
                            }
                        } else {
                            Image("imageNil")
                                .resizable()
                                .frame(width: (UIScreen.main.bounds.width - 60) / 3, height: 164)
                                .cornerRadius(5)
                                .onTapGesture{
                                    selectedBook = book
                                }
                        }
                        
                        
                    }
                    .frame(width: (UIScreen.main.bounds.width - 60) / 3) // VStack에 대한 프레임 설정
                }
            }
        }
    }
}

