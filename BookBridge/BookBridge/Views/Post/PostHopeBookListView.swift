//
//  PostHopeBookListView.swift
//  BookBridge
//
//  Created by 이현호 on 2/26/24.
//

import SwiftUI
import Kingfisher

struct PostHopeBookListView: View {
    @StateObject var viewModel: PostViewModel
    @Binding var hopeBooks: [Item]
    
    @State var selectedPicker: tapInfo = .wish
    @State private var isShowBookDetail = false
    
    var id: String
//    var selectedBook: [Item]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("희망도서 목록")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, 5)
                    .padding(.horizontal)
                
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack(alignment: .top) {
                    ForEach(hopeBooks.indices, id: \.self) { index in
                        let bookTitle = hopeBooks[index].volumeInfo.title ?? ""
                        let bookPublisher = hopeBooks[index].volumeInfo.publisher ?? ""
                        VStack(alignment: .leading) {
                            if let urlString = hopeBooks[index].volumeInfo.imageLinks?.smallThumbnail, let url = URL(string: urlString) {
                                KFImage(url)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 75, height: 100) // 이미지 크기 설정
                                    .cornerRadius(10)
                                    .padding(.trailing, 5)
                                    .padding(.leading)
                                    .foregroundStyle(.black)
                                    .shadow(color: .gray, radius: 3, x: 0, y: 1)
                                    .onTapGesture {
//                                        selectedBook = index
                                        isShowBookDetail = true
                                    }
                                
                            } else {
                                Image("imageNil")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 75, height: 100) // 이미지 크기 설정
                                    .cornerRadius(10)
                                    .padding(.trailing, 5)
                                    .padding(.leading)
                                    .foregroundStyle(.black)
                                    .shadow(color: .gray, radius: 3, x: 0, y: 1)
                                    .onTapGesture {
//                                        selectedBook = index
                                        isShowBookDetail = true
                                    }
                            }
                                                        
                            Text(bookTitle)
                                .font(.system(size: 12))
                                .padding(.trailing, 5)
                                .padding(.top, 5)
                                .padding(.leading)
                                .frame(width: 100, alignment: .leading)
                                .lineLimit(2)
                            
                            Text(bookPublisher)
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .padding(.trailing, 5)
                                .padding(.top, 1)
                                .padding(.leading)
                                .frame(width: 100, alignment: .leading)
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
        .padding(.vertical)

        .sheet(isPresented: $isShowBookDetail, onDismiss: {
            
        }) {
//            BookDetailView(selectedPicker: $selectedPicker, book: selectedBook)
        }
    }
}
