//
//  BookShelfView.swift
//  BookBridge
//
//  Created by 김건호 on 2/1/24.
//

import SwiftUI

struct BookShelfView: View {
    @StateObject var viewModel: BookShelfViewModel
    @State var selectedPicker: tapInfo
    @State private var showingSheet = false // 시트 표시 여부를 위한 상태 변수
    @State private var searchText = ""
    @State private var selectedBook: Item?
    @State private var hopeBooks: [Item] = []
    @State private var isEditing = false
    @State private var userName: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var isOwnShelf: Bool = true
    @State var ismore : Bool
    var isBack : Bool?
    var userId : String?
    let pickerItems : [tapInfo] = [.wish, .hold]
    
    @GestureState private var dragOffset = CGSize.zero
    
    init(userId: String?, initialTapInfo: tapInfo, isBack: Bool, ismore : Bool) {
        _viewModel = StateObject(wrappedValue: BookShelfViewModel(userId: userId))
        self.userId = userId
        _selectedPicker = State(initialValue: initialTapInfo)
        self.isBack = isBack
        _ismore = State(initialValue: ismore)
    }
    
    var searchBarPlaceholder: String {
        switch selectedPicker {
        case .wish:
            return "희망도서 이름을 검색해 주세요"
        case .hold:
            return "보유도서 이름을 검색해 주세요"
        case .search:
            return "희망도서 이름을 검색해 주세요"
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    if isBack == false {
                        
                        Text("내 책장")
                            .font(.system(size: 16))
                        
                        HStack {
                            Spacer()
                            
                            if userId == UserManager.shared.uid || userId == nil {
                                Button {
                                    isEditing.toggle()
                                } label: {
                                    Text(isEditing ? "확인" :  "편집")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                    }
                }
                .padding(.top,8)
                .padding(.horizontal)
                
                Picker("선택", selection: $selectedPicker) {
                    ForEach(pickerItems, id: \.self) { item in
                        Text(item.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: selectedPicker) { newValue in
                    viewModel.fetchBooks(for: newValue)
                }
                
                Spacer()
                    .frame(height: 20)
                
                VStack {
                    BookSearchBar(text: $searchText, placeholder: searchBarPlaceholder)
                        .padding(.horizontal)
                        .onChange(of: searchText) { newValue in
                            viewModel.filterBooks(for: selectedPicker, searchText: newValue)
                        }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    BookView(selectedBook: $selectedBook, isEditing: $isEditing, ismore: $ismore, tap: selectedPicker )
                        .environmentObject(viewModel)
                        .sheet(item: $selectedBook,onDismiss: {viewModel.fetchBooks(for: selectedPicker)}) { book in
                            BookDetailView(selectedPicker: $selectedPicker, isButton: true, book: book )
                                .environmentObject(viewModel)
                                .presentationDetents([.large])
                                .presentationDragIndicator(.visible)
                        }
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .onAppear{
                viewModel.fetchBooks(for: selectedPicker)
            }
            
            if userId == UserManager.shared.uid || userId == nil {
                AddBookBtnView(showingSheet: $showingSheet)
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
                    .fullScreenCover(isPresented: $showingSheet, onDismiss: {
                        // MARK: hopebook 처리 할 예정
                        //취소 클릭시 아닐경우 나눈후 아닐경우 중복 처리후 wishbook에 입력 취소시 배열 초기화
                        if hopeBooks.isEmpty {
                            // 취소눌렀을 경우
                        } else {
                            // 확인 눌렀을 경우
                            if selectedPicker == .wish {
                                viewModel.wishBooks.removeAll { item in
                                    hopeBooks.contains(where: { $0.id == item.id })
                                }
                                viewModel.wishBooks.append(contentsOf: hopeBooks)
                                viewModel.saveBooksToFirestore(books: hopeBooks, collection: "wishBooks")
                                viewModel.fetchBooks(for: .wish)
                            } else {
                                viewModel.holdBooks.removeAll { item in
                                    hopeBooks.contains(where: { $0.id == item.id })
                                }
                                viewModel.holdBooks.append(contentsOf: hopeBooks)
                                viewModel.saveBooksToFirestore(books: hopeBooks, collection: "holdBooks")
                                viewModel.fetchBooks(for: .hold)
                                
                            }
                            hopeBooks.removeAll()
                        }
                    }, content: {
                        SearchBooksView(hopeBooks: $hopeBooks, isWish: selectedPicker)
                    })
            }
        }
        .onAppear{
            if userId != nil {
                viewModel.gettingUserInfo(userId: self.userId ?? "")
            }
        }
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    let horizontalTranslation = value.translation.width
                    let threshold: CGFloat = 100 // 드래그로 이동할 최소한의 거리
                    if horizontalTranslation > threshold {
                        // 오른쪽으로 드래그되었을 때
                        if let currentIndex = pickerItems.firstIndex(of: selectedPicker), currentIndex > 0 {
                            selectedPicker = pickerItems[currentIndex - 1]
                        }
                    } else if horizontalTranslation < -threshold {
                        // 왼쪽으로 드래그되었을 때
                        if let currentIndex = pickerItems.firstIndex(of: selectedPicker), currentIndex < pickerItems.count - 1 {
                            selectedPicker = pickerItems[currentIndex + 1] 
                        }
                    }
                }
        )
    }
}





