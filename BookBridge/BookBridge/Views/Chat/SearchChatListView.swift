//
//  SearchChatListView.swift
//  BookBridge
//
//  Created by 이현호 on 2/14/24.
//

import SwiftUI

struct SearchChatListView: View {
    @State var isEditing = false
    @State private var text = ""
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(.leading, 8)
                .foregroundStyle(.gray)
            
            TextField("검색어를 입력해주세요", text: $text)
                .padding(7)
                .onChange(of: text) { _ in
                    if text != "" {
                        isEditing = true
                    } else {
                        isEditing = false
                    }
                }
            
            if isEditing {
                Button {
                    isEditing = false
                    text = ""
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
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        )
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    SearchChatListView()
}
