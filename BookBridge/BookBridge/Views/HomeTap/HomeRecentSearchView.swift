//
//  HomeRecentSearchView.swift
//  BookBridge
//
//  Created by 김건호 on 2/7/24.
//

import SwiftUI

struct HomeRecentSearchView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding  var isInsideXmark: Bool
    @Binding  var isOutsideXmark: Bool
    @Binding  var text : String
    
    
    var body: some View {
        VStack {
            HStack {
                Text("최근 검색")
                    .font(.system(size: 20))
                    .font(.headline)
                    .padding(.leading)
                
                Spacer()
                
                Button(action: {
                    viewModel.recentSearchDeleteAll(user: UserManager.shared.uid)
                }, label: {
                    Text("전체삭제")
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "999999"))
                        .underline()
                })
                .padding(.trailing)
            }
            .padding(.vertical, 5)
            
            
            if viewModel.recentSearch.isEmpty {
                Text("최근 검색 기록이 없습니다")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                List {
                    ForEach(viewModel.recentSearch, id: \.self) { search in
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(Color(hex: "999999"))

                            Text(search)
                                .foregroundColor(Color(hex: "999999"))
                            
                            Spacer()

                            Button(action: {
                                viewModel.deleteRecentSearch(user: UserManager.shared.uid, search: search)
                            }, label : {
                                Image(systemName: "multiply")
                                    .foregroundColor(Color(hex: "999999"))
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.addRecentSearch(user: UserManager.shared.uid, text: search, category: viewModel.currentTapCategory)
                            viewModel.filterNoticeBoards(with: search)
                            isOutsideXmark = false
                            isInsideXmark = false
                            text = search
                        }
                    }
                }
                .listStyle(.inset)
            }
            
            
        }
        .onAppear{
            viewModel.fetchRecentSearch(user: UserManager.shared.uid)
        }
        .background(Color.white)
        
    }
}

//struct HomeRecentSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeRecentSearchView()
//    }
//}
