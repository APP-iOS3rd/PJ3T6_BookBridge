//
//  HomeView.swift
//  BookBridge
//
//  Created by 노주영 on 2/6/24.
//

import SwiftUI
import FirebaseStorage

enum tapCategory : String, CaseIterable {
    case find = "구해요"
    case change = "바꿔요"
    case recommend = "추천도서"
}

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    @State private var isAnimating = false
    @State private var selectedPicker: tapCategory = .find
    @State private var rotation = 0.0
    
    @Namespace private var animation
    
    var body: some View {
        VStack {
            HStack{
                Button {
                    self.isAnimating.toggle()
                    
                } label: {
                    HStack{
                        Text("광교 2동")
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(isAnimating ? 180 : 360))
                            .animation(.linear(duration: 0.3), value: isAnimating)
                    }
                    .padding(.leading, 20)
                    .foregroundStyle(.black)
                    
                }
                Spacer()
            }
            tapAnimation()
            
            HomeTapView(viewModel: viewModel, tests: selectedPicker)
        }
        .onAppear {
            viewModel.gettingAllDocs()
        }
    }
    
    @ViewBuilder
    private func tapAnimation() -> some View {
        HStack {
            ForEach(tapCategory.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .font(.title3)
                        .frame(maxWidth: .infinity/3, minHeight: 50)
                        .foregroundColor(selectedPicker == item ? .black : .gray)

                    if selectedPicker == item {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "info", in: animation)
                            .padding(.bottom, 0)
                    }
                    
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255)), alignment: .bottom)
    }
}

struct HomeTapView: View {
    @StateObject var viewModel: HomeViewModel
    
    @State private var text = ""
    
    var tests : tapCategory
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.black)
                        .padding(5)
                    TextField(text: $text) {
                        Text("검색어를 입력해주세요")
                    }
                    .padding(5)
                }
                .background(Color(red: 233/255, green: 233/255, blue: 233/255))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Image(systemName: "xmark")
                    .foregroundStyle(.black)
                
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            switch tests {
            case .find:
                ForEach(viewModel.noticeBoards) { element in
                    if !element.isChange {
                        ListItem(id: element.id, imageLinks: element.hopeBook.isEmpty ? [] : [element.hopeBook[0].volumeInfo.imageLinks?.smallThumbnail ?? ""], title: element.noticeBoardTitle, author: "이순신", bookmark: true, date: element.date,  locate: element.noticeLocation, isChange: element.isChange)
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            case .change:
                ForEach(viewModel.noticeBoards) { element in
                    if element.isChange {
                        ListItem(id: element.id, imageLinks: element.noticeImageLink, title: element.noticeBoardTitle, author: "이순신", bookmark: true, date: element.date,  locate: element.noticeLocation, isChange: element.isChange)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            case .recommend:
                ForEach(viewModel.noticeBoards) { element in
                    ListItem(id: element.id, imageLinks: element.noticeImageLink, title: element.noticeBoardTitle, author: "이순신", bookmark: true, date: element.date,  locate: element.noticeLocation, isChange: element.isChange)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
        }
    }
}

struct ListItem: View {
    var id: String
    var imageLinks: [String]
    var title: String
    var author: String
    var bookmark: Bool
    var date: Date
    var locate: [Double]
    var isChange: Bool

    var storageManager = StorageManager.shared
    
    @State var url = URL(string: "")
    
    var body: some View {
        HStack {
            if imageLinks.isEmpty {
                Image("Character")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 100)
                    .foregroundStyle(.black)
                    .padding()
            } else {
                if isChange {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(width: 75, height: 100)
                            .foregroundStyle(.black)
                            .padding()
                    } placeholder: {
                        ProgressView()
                            .frame(width: 75, height: 100)
                            .padding()
                    }
                } else {
                    AsyncImage(url: URL(string: imageLinks[0])) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 100)
                            .foregroundStyle(.black)
                            .padding()
                    } placeholder: {
                        ProgressView()
                            .frame(width: 75, height: 100)
                            .padding()
                    }
                }
            }
            
            
            VStack(alignment: .leading, spacing: 0){
                Divider().opacity(0)
                Text("\(title)")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 10)
                    .lineLimit(2)
                
                Text("\(author)")
                    .font(.system(size: 10))
                    .padding(.top, 5)
                    .foregroundStyle(Color(red: 75/255, green: 75/255, blue: 75/255))
                
                Spacer()
                
                Text("무슨동 | \(date)")
                    .font(.system(size: 10))
                    .padding(.bottom, 10)
                    .foregroundStyle(Color(red: 75/255, green: 75/255, blue: 75/255))
            }
            Spacer()
            VStack{
                Image(systemName: "bookmark")
                    .font(.system(size: 20))
                    .padding()
                    .foregroundColor(.black)
                
                Spacer()
            }
        }
        .frame(height: 120, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .circular)
                .foregroundColor(Color(red: 230/255, green: 230/255, blue: 230/255))
        )
        .onAppear {
            if !imageLinks.isEmpty && isChange {
                Task {
                    try await storageManager.downloadImage(noticeiId: id, imageId: imageLinks[0]) { url in
                        self.url = url
                    }
                }
            }
        }
    }
    
}
