//
//  SearchResultView.swift
//  BookBridge
//
//  Created by 노주영 on 1/31/24.
//

import SwiftUI

struct SearchResultView: View {
    @StateObject var viewModel: SearchBooksViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("검색 결과")
                        .font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.searchBooks.items) { book in
                            HStack(alignment: .top) {
                                if let smallThumbnail = book.volumeInfo.imageLinks?.smallThumbnail {
                                    AsyncImage(url: URL(string: smallThumbnail)) {
                                        image in
                                        image
                                            .resizable()
                                            .frame(width: 60, height: 80)
                                            .cornerRadius(5)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 60, height: 80)
                                    }
                                } else {
                                    Image("imageNil")
                                        .resizable()
                                        .frame(width: 60, height: 80)
                                        .cornerRadius(5)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(book.volumeInfo.title ?? "제목 미상")
                                        .font(.system(size: 12, weight: .semibold))
                                        .padding(.bottom, 10)
                                    
                                    HStack {
                                        Text(book.volumeInfo.authors?[0] ?? "저자 미상")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundStyle(Color.init(hex: "767676"))
                                            .padding(.trailing, 8)
                                        
                                        Text("(\(book.volumeInfo.publisher ?? "출판사 미상"))")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundStyle(Color.init(hex: "767676"))
                                    }
                                    .padding(.bottom, 8)
                                    
                                    HStack(alignment: .bottom) {
                                        Text(book.volumeInfo.publishedDate ?? "출판 날짜 미상")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundStyle(Color.init(hex: "767676"))
                                            .padding(.bottom, 10)
                                        
                                        Spacer()
                                        
                                        Button {
                                            if viewModel.selectBooks.items.contains(where: { $0.id == book.id }) {
                                                viewModel.deleteSelectBook(book: book)
                                            } else {
                                                viewModel.doSelectBook(book: book)
                                            }
                                            
                                        } label: {
                                            Text(viewModel.selectBooks.items.contains(where: { $0.id == book.id }) ? "취소" : "선택")
                                                .font(.system(size: 12))
                                                .foregroundStyle(.white)
                                                .frame(width: 45, height: 20)
                                                .background( viewModel.selectBooks.items.contains(where: { $0.id == book.id }) ? Color.init(hex: "EE5050") : Color.init(hex: "59AAE0")
                                                )
                                        }
                                        .cornerRadius(5)
                                    }
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                        }
                        
                        if !viewModel.isFinish {
                            ProgressView()
                                .onAppear {
                                    viewModel.callBookApi(isProgress: true)
                                }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
