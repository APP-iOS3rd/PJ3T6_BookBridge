//
//  SelectBooksView.swift
//  BookBridge
//
//  Created by 노주영 on 1/31/24.
//

import SwiftUI

struct SelectBooksView: View {
    @StateObject var viewModel: SearchBooksViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("선택항목 \(viewModel.selectBooks.items.count)권")
                        .font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                }
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.selectBooks.items) { book in
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
                                
                                Button {
                                    viewModel.deleteSelectBook(book: book)
                                    
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(.black)
                                }
                                .padding(.top, -9)
                                .padding(.leading, -7)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }
                
                Rectangle()
                    .frame(width: geometry.size.width - 32, height: 2)
                    .foregroundStyle(Color.init(hex: "B3B3B3"))
            }
            .padding(.horizontal)
        }
        .frame(height: 150)
    }
}
