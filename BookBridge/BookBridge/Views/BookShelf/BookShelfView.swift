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
    @State private var selectedPicker: tapInfo = .wish
    @StateObject private var viewModel = BookShelfViewModel()
    
    @State private var searchText = ""
    
    var searchBarPlaceholder: String {
            switch selectedPicker {
            case .wish:
                return "희망도서 이름을 검색해 주세요"
            case .hold:
                return "보유도서 이름을 검색해 주세요"
            }
        }
    
    var body: some View {
        VStack {
            Picker("선택", selection: $selectedPicker) {
                ForEach(tapInfo.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            Spacer()
                .frame(height: 20)


            SearchBar(text: $searchText, placeholder: searchBarPlaceholder)
            
            
            Spacer()
                .frame(height: 20)
            
                BookView(tap: selectedPicker)
                    .environmentObject(viewModel)
            
        }
        .padding(20)
        
    }
}
struct BookView: View {
    @EnvironmentObject var viewModel: BookShelfViewModel
    var tap: tapInfo

    var books: [Item] {
        switch tap {
        case .wish:
            return viewModel.wishBooks.flatMap { $0.items }
        case .hold:
            return viewModel.holdBooks.flatMap { $0.items }
        }
    }

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(books, id: \.id) { book in
                    VStack {
                        if let urlString = book.volumeInfo.imageLinks?.smallThumbnail, let url = URL(string: urlString) {
                            AsyncImage(url: url)
                                .frame(width: (UIScreen.main.bounds.width - 60) / 3, height: 164)
                                .cornerRadius(8)
                        }
                        Text(book.volumeInfo.title ?? "Unknown Title")
                            .frame(maxWidth: .infinity, alignment: .center) // 텍스트 뷰 크기 조정
                    }
                    .frame(width: (UIScreen.main.bounds.width - 60) / 3) // VStack에 대한 프레임 설정
                }
            }
        }
    }
}


struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            TextField("\(placeholder)", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if text != "" {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    })
        }
    }
}
