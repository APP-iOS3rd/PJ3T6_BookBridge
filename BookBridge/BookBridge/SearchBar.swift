//
//  SearchBar.swift
//  BookBridge
//
//  Created by 노주영 on 1/30/24.
//

import SwiftUI
 
struct SearchBar: View {
    @StateObject var viewModel: SearchBooksViewModel
    
    @State var isEditing = false
 
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.leading, 8)
                
                TextField("검색어를 입력해주세요", text: $viewModel.text)
                    .padding(7)
                    .onChange(of: viewModel.text) { _ in
                        viewModel.saveText = viewModel.text
                        viewModel.searchBooks.totalItems = 0
                        viewModel.searchBooks.items.removeAll()
                        viewModel.firstToTalCount = 0
                        viewModel.isFinish = true
                        viewModel.startIndex = 0
                        
                        if viewModel.text != "" {
                            isEditing = true
                            viewModel.callBookApi()
                        } else {
                            isEditing = false
                        }
                    }
                
                if isEditing {
                    Button {
                        isEditing = false
                        viewModel.firstToTalCount = 0
                        viewModel.isFinish = true
                        viewModel.startIndex = 0
                        viewModel.searchBooks.items.removeAll()
                        viewModel.text = ""
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
