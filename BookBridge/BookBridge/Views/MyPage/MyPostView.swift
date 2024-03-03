//
//  MyPostView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct MyPostView: View {

    @StateObject var viewModel: MyPageViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("나의 게시물")
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 10)
            
            NavigationLink {
                NoticeBoardView(naviTitle: "내 게시물", noticeBoardArray: [], sortTypes: ["전체", "진행중", "예약중", "교환완료"])
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
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
                )
            }
            
            NavigationLink {                        //요청내역 경로가 아직없음
                NoticeBoardView(naviTitle: "요청 내역", noticeBoardArray: viewModel.userRequests, sortTypes: ["전체", "예약중", "교환완료"])
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
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
                )
            }
        }
        .padding(.bottom, 20)
    }
}

