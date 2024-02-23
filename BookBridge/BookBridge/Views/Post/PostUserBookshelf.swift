//
//  PostUserBookshelf.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI

struct PostUserBookshelf: View {
    @StateObject var postViewModel: PostViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(postViewModel.user.nickname ?? "책벌레")님의 책장")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .padding()
                        
            BookshelfHeaderView(postViewModel: postViewModel, bookTypeName: "보유도서")
            
            
            PostBookListView(postbooks:$postViewModel.holdBooks)
           
            BookshelfHeaderView(postViewModel: postViewModel, bookTypeName: "희망도서")
            
            PostBookListView(postbooks: $postViewModel.wishBooks)
        }
    }
}




    
    
    
//    struct BookListView: View {
//        @StateObject var postViewModel: PostViewModel
//        
//        var body: some View {
//            VStack(spacing: 5) {
//                ForEach(postViewModel.holdBooks) { element in
//                    if let bookTitle = element.volumeInfo.title {
//                        Text(bookTitle)
//                            .padding(.bottom, 5) // 위아래 간격 설정
//                            .frame(maxWidth: .infinity, alignment: .leading) // leading 정렬
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//    }

