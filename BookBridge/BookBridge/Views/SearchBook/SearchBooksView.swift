//
//  SearchBooksView.swift
//  BookBridge
//
//  Created by 노주영 on 1/30/24.
//

import SwiftUI

struct SearchBooksView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = SearchBooksViewModel()
    
    var body: some View {
        VStack {
            //상단 네비 뷰
            /*
            ZStack {
                Text("희망도서")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("확인")
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                    }
                    
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                .padding(.horizontal)
            }
            */
            SearchBarView(viewModel: viewModel)
                .frame(height: 36)
                .padding(.vertical, 20)
                .padding(.horizontal)
            
            if !viewModel.selectBooks.items.isEmpty {
                SelectBooksView(viewModel: viewModel)
            }
            
            SearchResultView(viewModel: viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .navigationTitle("희망도서")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Text("확인")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    SearchBooksView()
}
