//
//  SearchChatListView.swift
//  BookBridge
//
//  Created by 이현호 on 2/14/24.
//

import SwiftUI

struct SearchChatListView: View {
    @StateObject var viewModel: ChatRoomListViewModel
    
    @State var isEditing = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(.leading, 8)
                .foregroundStyle(.gray)
            
            TextField("검색어를 입력해주세요", text: $viewModel.searchText)
                .padding(7)
                .onChange(of: viewModel.searchText) { _ in
                    if viewModel.searchText != "" {
                        isEditing = true
                    } else {
                        isEditing = false
                    }
                }
            
            if isEditing {
                Button {
                    isEditing = false
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 8)
                }
                .padding(.trailing, 8)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
