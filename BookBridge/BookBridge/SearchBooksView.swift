//
//  SearchBooksView.swift
//  BookBridge
//
//  Created by 노주영 on 1/30/24.
//

import SwiftUI

struct SearchBooksView: View {    
    @StateObject var viewModel = SearchBooksViewModel()
    
    var body: some View {
        VStack {
            //상단 네비 뷰
            HStack {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 20))
                
                Spacer()
                
                Text("희망도서")
                    .font(.system(size: 20, weight: .bold))
                
                Spacer()
                
                Button { } label: {
                    Text("확인")
                        .font(.system(size: 20))
                }
                
            }
            .padding(.top, 10)
            .padding(.bottom, 20)
            .padding(.horizontal)
            
            SearchBar(searchBooks: $viewModel.searchBooks, text: $viewModel.text)
                .frame(height: 36)
                .padding(.bottom, 20)
                .padding(.horizontal)
            
            if !viewModel.selectBooks.items.isEmpty {
                VStack {
                    HStack {
                        Text("선택항목 \(viewModel.selectBooks.items.count)권")
                            .font(.system(size: 17, weight: .semibold))
                        
                        Spacer()
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.selectBooks.items) { book in
                                ZStack {
                                    if let smallThumbnail = book.volumeInfo.imageLinks?.smallThumbnail {
                                        AsyncImage(url: URL(string: smallThumbnail)) {
                                            image in
                                            image
                                                .resizable()
                                                .frame(width: 60, height: 80)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 60, height: 80)
                                        }
                                    } else {
                                        Image("KaKaoLogo")
                                            .resizable()
                                            .frame(width: 60, height: 80)
                                    }
                                    
                                    Button {
                                        viewModel.deleteSelectBook(book: book)
                                    } label: {
                                        Image(systemName: "xmark")
                                            .frame(width: 15, height: 15)
                                    }
                                    .offset(x: 35, y: -40)
                                }
                                .frame(width: 80, height: 100)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
                .padding(.horizontal)
            }
            
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Text("검색 결과")
                            .font(.system(size: 17, weight: .semibold))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        ForEach(viewModel.searchBooks.items) { book in
                            HStack(alignment: .top) {
                                if let smallThumbnail = book.volumeInfo.imageLinks?.smallThumbnail {
                                    AsyncImage(url: URL(string: smallThumbnail)) {
                                        image in
                                        image
                                            .resizable()
                                            .frame(width: 60, height: 80)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 60, height: 80)
                                    }
                                } else {
                                    Image("KaKaoLogo")
                                        .resizable()
                                        .frame(width: 60, height: 80)
                                }
                                
                                
                                VStack(alignment: .leading) {
                                    Text(book.volumeInfo.title ?? "제목")
                                        .font(.system(size: 12, weight: .semibold))
                                        .padding(.bottom, 10)
                                    
                                    HStack {
                                        Text(book.volumeInfo.authors?[0] ?? "저자")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundStyle(Color.init(hex: "767676"))
                                            .padding(.trailing, 8)
                                        
                                        Text("(\(book.volumeInfo.publisher ?? "출판사 미상"))")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundStyle(Color.init(hex: "767676"))
                                    }
                                    .padding(.bottom, 8)
                                    
                                    HStack(alignment: .bottom) {
                                        Text(book.volumeInfo.publishedDate ?? "2022-2-2")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundStyle(Color.init(hex: "767676"))
                                            .padding(.bottom, 10)
                                        
                                        Spacer()
                                        
                                        Button {
                                            viewModel.doSelectBook(book: book)
                                        } label: {
                                            Text("선택")
                                                .font(.system(size: 12))
                                                .foregroundStyle(.white)
                                                .frame(width: 45, height: 20)
                                                .cornerRadius(10)
                                                .background(Color.init(hex: "6F6F70"))
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SearchBooksView()
}
