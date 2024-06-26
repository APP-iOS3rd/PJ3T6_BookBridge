//
//  MyPostView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct MyPostView: View {
    @Binding var selectedTab : Int
    @EnvironmentObject private var pathModel: TabPathViewModel
    @StateObject var viewModel: MyPageViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("게시물 관리")
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 10)

            //            NavigationLink {
//                NoticeBoardView(selectedTab: $selectedTab, naviTitle: "내 게시물", noticeBoardArray: [], sortTypes: ["전체", "진행중", "예약중", "교환완료"])
//            }
            
             Button{
                 pathModel.paths.append(.noticeboard(naviTitel: "내 게시물", noticeBoardArray: [], sortType: ["전체", "진행중", "예약중", "교환완료"]))
            } label: {
                HStack(spacing: 10) {
                    Text("내 게시물")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("\(viewModel.myNoticeBoardCount)")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
            }
            Divider()
            
//            NavigationLink {
//                NoticeBoardView(selectedTab: $selectedTab, naviTitle: "요청 내역", noticeBoardArray: viewModel.userRequests, sortTypes: ["전체", "예약중", "교환완료"])
//            }
            
             Button{
                 pathModel.paths.append(.noticeboard(naviTitel: "요청내역", noticeBoardArray: viewModel.userRequests, sortType: ["전체","예약중","교환완료"]))
            } label: {
                HStack(spacing: 10) {
                    Text("요청 내역")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("\(viewModel.userRequests.count)")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
            }
            Divider()
            
            NavigationLink {                //관심목록 경로가 아직없음
                NoticeBoardView(selectedTab: $selectedTab, naviTitle: "관심목록", noticeBoardArray: viewModel.userBookMarks, sortTypes: ["전체", "진행중", "예약중", "교환완료"])
            } label: {
                HStack {
                    Text("관심목록")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
            }
            Divider()
        }
        .padding(.bottom, 20)
    }
}

