//
//  BookShelfView.swift
//  BookBridge
//
//  Created by 김건호 on 2/1/24.
//

import SwiftUI






struct BookShelfView: View {
    @StateObject private var viewModel = BookShelfViewModel()
    @State private var selectedPicker: tapInfo = .wish
    @State private var showingSheet = false // 시트 표시 여부를 위한 상태 변수
    @State private var searchText = ""
    @State private var selectedBook: Item?
    @State private var hopeBooks: [Item] = []
    
    var userId : String?
    
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
                
                Text("UserId: \(userId ?? "Unknown")")
                     .foregroundColor(.gray)
                     .font(.caption)
                     .padding(.top, 5)
                
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
                            .environmentObject(viewModel)
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
                .fullScreenCover(isPresented: $showingSheet, onDismiss: {
                    // MARK: hopebook 처리 할 예정
                    //취소 클릭시 아닐경우 나눈후 아닐경우 중복 처리후 wishbook에 입력 취소시 배열 초기화
                    if hopeBooks.isEmpty {
                        // 취소눌렀을 경우
                    }
                    else {
                        // 확인 눌렀을 경우
                        if selectedPicker == .wish {
                            viewModel.wishBooks.removeAll { item in
                                hopeBooks.contains(where: { $0.id == item.id })
                            }
                            viewModel.wishBooks.append(contentsOf: hopeBooks)
                            viewModel.fetchBooks(for: .wish)
                        }
                        else {
                            viewModel.holdBooks.removeAll { item in
                                hopeBooks.contains(where: { $0.id == item.id })
                            }
                            viewModel.holdBooks.append(contentsOf: hopeBooks)
                            viewModel.fetchBooks(for: .hold)
                        }
                        hopeBooks.removeAll()
                    }
                }, content: {
                    
                    
                    SearchBooksView(hopeBooks: $hopeBooks, isWish: selectedPicker)
                    
                    
                })
            
            
        }
        
    }
}





