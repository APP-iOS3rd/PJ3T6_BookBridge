//
//  PostMenuBtnsView.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI

struct PostMenuBtnsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var postViewModel: PostViewModel
    @StateObject var reportVM: ReportViewModel
    @State private var showingDeleteAlert = false
    @Binding var isPresented: Bool
    @Binding var noticeBoard: NoticeBoard
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    if isPresented {
                        if UserManager.shared.uid != noticeBoard.userId {
                            Button {
                                if UserManager.shared.isLogin {
                                    postViewModel.bookMarkToggle(id: noticeBoard.id)
                                }
                                isPresented.toggle()
                            } label: {
                                Text( postViewModel.bookMarks.contains(noticeBoard.id) ? "관심목록 삭제" : "관심목록 추가")
                                    .modifier(MenuBtnText())
                            }
                            
                            Divider()
                                .padding(1)
                            
                            NavigationLink {
                                ReportView(reportVM: reportVM)
                            } label: {
                                Text("신고하기")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.red)
                                    .padding(1)
                                    .onAppear{
                                        reportVM.report.targetID = noticeBoard.id
                                        reportVM.report.targetType = .post
                                    }
                            }
                            
                        } else {
                            NavigationLink {
                                if noticeBoard.isChange {
                                    ChangePostingModifyView(noticeBoard: $noticeBoard)
                                        .navigationBarBackButtonHidden()
                                } else {
                                    FindPostingModifyView(noticeBoard: $noticeBoard)
                                        .navigationBarBackButtonHidden()
                                }
                            } label: {
                                Text("수정하기")
                                    .modifier(MenuBtnText())
                            }
                            
                            Divider()
                                .padding(1)
                            
                            Button {
                                showingDeleteAlert = true
                            } label: {
                                Text("삭제하기")
                                    .modifier(MenuBtnText())
                                    .foregroundStyle(Color.red)
                            }
                            .alert("게시물을 삭제하시겠습니까?",isPresented: $showingDeleteAlert){
                                Button("삭제", role: .destructive) {
                                    postViewModel.deletePost(noticeBoardId: noticeBoard.id)
                                    dismiss()
                                }
                                Button("취소", role: .cancel) {}                            }
                        }
                    }
                }
                .frame(width: 110, height: isPresented ? 80 : 0)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .circular)
                        .foregroundColor(Color(red: 230/255, green: 230/255, blue: 230/255))
                )
                .padding(.trailing)
            }
            
            Spacer()
        }
    }
}

extension PostMenuBtnsView {
    struct MenuBtnText: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.system(size: 14))
                .padding(1)
        }
    }
}
