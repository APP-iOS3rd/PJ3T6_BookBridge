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
                
                Spacer()
                    .frame(height: 20)
                
                
                BookSearchBar(text: $searchText, placeholder: searchBarPlaceholder)
                
                
                Spacer()
                    .frame(height: 20)
                
                BookView(selectedBook: $selectedBook, tap: selectedPicker)
                    .environmentObject(viewModel)
                    .sheet(item: $selectedBook) { book in
                                BookDetailView(book: book)
                                    .navigationTitle("도서정보")
                            }
                
            }
            .padding(20)
            
            AddBookBtnView(showingSheet: $showingSheet)
                            .padding(.trailing, 20)
                            .padding(.bottom, 50)
                            .sheet(isPresented: $showingSheet) {
                                SearchBooksView()
                            }
        }
        
    }
}





