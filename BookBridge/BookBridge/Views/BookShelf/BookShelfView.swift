//
//  BookShelfView.swift
//  BookBridge
//
//  Created by 김건호 on 2/1/24.
//

import SwiftUI




enum tapInfo: String, CaseIterable {
    case wish = "희망도서"
    case hold = "보유도서"
    
}

struct BookShelfView: View {
    @StateObject private var viewModel = BookShelfViewModel()
    @State private var selectedPicker: tapInfo = .wish
    @State private var showingSheet = false // 시트 표시 여부를 위한 상태 변수
    @State private var searchText = ""
    @State private var selectedBook: Item?
    
    var searchBarPlaceholder: String {
        switch selectedPicker {
        case .wish:
            return "희망도서 이름을 검색해 주세요"
        case .hold:
            return "보유도서 이름을 검색해 주세요"
        }
    }
    
    
    
    var body: some View {
        ZStack{
            VStack {
                Picker("선택", selection: $selectedPicker) {
                    ForEach(tapInfo.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedPicker) { newValue in
                    viewModel.fetchBooks(for: newValue)
                }
                Spacer()
                    .frame(height: 20)
                
                
                BookSearchBar(text: $searchText, placeholder: searchBarPlaceholder)
                    .onChange(of: searchText) { newValue in
                        viewModel.filterBooks(for: selectedPicker, searchText: newValue)
                    }
                
                
                Spacer()
                    .frame(height: 20)
                
                BookView(selectedBook: $selectedBook, tap: selectedPicker)
                    .environmentObject(viewModel)
                    .sheet(item: $selectedBook) { book in
                        
                            BookDetailView(book: book)
                            .presentationDetents([.large])
                                
                        
                        
                    }
                
                
            }
            .padding(20)
            .onAppear{
                viewModel.fetchBooks(for: .wish)
            }
            AddBookBtnView(showingSheet: $showingSheet)
                .padding(.trailing, 20)
                .padding(.bottom, 50)
                .sheet(isPresented: $showingSheet) {
                    SearchBooksView()
                }
        }
        
    }
}





