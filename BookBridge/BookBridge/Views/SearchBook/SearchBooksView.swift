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
            
            SearchBarView(viewModel: viewModel)
                .frame(height: 36)
                .padding(.bottom, 20)
                .padding(.horizontal)
            
            if !viewModel.selectBooks.items.isEmpty {
                SelectBooksView(viewModel: viewModel)
            }
            
            SearchResultView(viewModel: viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SearchBooksView()
}
