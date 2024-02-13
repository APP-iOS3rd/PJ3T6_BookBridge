//
//  HomeRecentSearchView.swift
//  BookBridge
//
//  Created by 김건호 on 2/7/24.
//

import SwiftUI

struct HomeRecentSearchView: View {
    @State private var recentSearches = ["Search 1", "Search 2", "Search 3"]

    var body: some View {
        VStack {
            HStack {
                Text("최근 검색")
                    .font(.system(size: 20))
                    .font(.headline)
                    .padding(.leading)

                Spacer()

                Button(action: {
                    recentSearches.removeAll()
                }, label: {
                    Text("전체삭제")
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "999999"))
                        .underline()
                })
                .padding(.trailing)
            }
            .padding(.vertical, 5)

            List {
                ForEach(recentSearches, id: \.self) { search in
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(Color(hex: "999999"))
                        Text(search)
                            .foregroundColor(Color(hex: "999999"))
                        Spacer()
                        Button(action: {
                            if let index = recentSearches.firstIndex(of: search) {
                                recentSearches.remove(at: index)
                            }
                        }) {
                            Image(systemName: "multiply")
                                .foregroundColor(Color(hex: "999999"))
                        }
                        .buttonStyle(PlainButtonStyle()) // 버튼 스타일 변경
                    }
                }
            }
            .listStyle(.inset)
        }
        .background(Color.white)
    }
}

struct HomeRecentSearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeRecentSearchView()
    }
}
