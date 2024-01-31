//
//  SearchBar.swift
//  BookBridge
//
//  Created by 노주영 on 1/30/24.
//

import SwiftUI
 
struct SearchBar: View {
    @Binding var searchBooks: Book
    @Binding var text: String
    
    @State var isEditing = false
    
    var bookApiManger = BookAPIManger()
 
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.leading, 8)
                
                TextField("검색어를 입력해주세요", text: $text)
                    .padding(7)
                    .onChange(of: text) { _ in
                        if text != "" {
                            isEditing = true
                        }
                        
                        bookApiManger.getData(text: text) { book in
                            searchBooks = book
                        }
                    }
                
                if isEditing {
                    Button {
                        isEditing = false
                        text = ""
                        searchBooks.items.removeAll()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 8)
                    }
                    .padding(.trailing, 8)
                }
            }
            .frame(width: geometry.size.width)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}
