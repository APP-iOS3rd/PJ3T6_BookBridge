//
//  NoticeBoardTapView.swift
//  BookBridge
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct NoticeBoardTapView: View {
    @StateObject var viewModel: NoticeBoardViewModel
    
    var myPagePostTapType: MyPagePostTapType
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            switch myPagePostTapType {
            case .find:             //TODO: imageLinks 부분 받아오기
                ForEach(viewModel.findNoticeBoards) { element in
                    if element.hopeBook.isEmpty {
                        HomeListItemView(author: "", bookmark: true, date: element.date, id: element.id, imageLinks: [], isChange: element.isChange, locate: element.noticeLocation, title: element.noticeBoardTitle)
                    } else {
                        //TODO: 나중에 썸네일 이미지, 저자 바꾸기
                        HomeListItemView(author: element.hopeBook[0].volumeInfo.authors?[0] ?? "", bookmark: true, date: element.date, id: element.id, imageLinks: [element.hopeBook[0].volumeInfo.imageLinks?.smallThumbnail ?? ""], isChange: element.isChange, locate: element.noticeLocation, title: element.noticeBoardTitle)
                        
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
            case .change:
                ForEach(viewModel.changeNoticeBoards) { element in
                    HomeListItemView(author: "", bookmark: true, date: element.date, id: element.id, imageLinks: element.noticeImageLink, isChange: element.isChange, locate: element.noticeLocation, title: element.noticeBoardTitle)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
    }
}
