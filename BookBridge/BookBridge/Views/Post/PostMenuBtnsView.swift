//
//  PostMenuBtnsView.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI

struct PostMenuBtnsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var pathModel: TabPathViewModel
    @Binding var isPresented: Bool
    @Binding var noticeBoard: NoticeBoard
  
    @ObservedObject var postViewModel: PostViewModel
  
    @State private var showingDeleteAlert = false
    @State var isBlockAlert = false
    
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
                                Text(postViewModel.bookMarks.contains(noticeBoard.id) ? "관심목록 삭제" : "관심목록 추가")
                                    .modifier(MenuBtnText())
                                    .foregroundStyle(.black)
                            }
                            
                            Divider()
                                .padding(1)
                            
                            Button {
                                pathModel.paths.append(.report(ischat: false, targetId: noticeBoard.id))
                            } label: {
                                Text("신고하기")
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color.red)
                                    .padding(1)
                            }.simultaneousGesture(TapGesture().onEnded {
                                isPresented.toggle()
                            })
                            
                            Divider()
                                .padding(1)
                            
                            Button {
                                isBlockAlert.toggle()
                            } label: {
                                Text("차단하기")
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color.red)
                                    .padding(1)
                            }
                            .alert("해당 사용자를 차단합니다", isPresented: $isBlockAlert) {
                                Button("취소", role: .cancel) {
                                    isBlockAlert.toggle()
                                }
                                Button("차단하기", role: .destructive) {
                                    postViewModel.blockUser(userId: noticeBoard.userId)
                                    dismiss()
                                }
                            } message: {
                                Text("차단하면 사용자의 게시글과 채팅을 볼 수 없어요")
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
                                    .foregroundStyle(.black)
                            }.simultaneousGesture(TapGesture().onEnded {
                                isPresented.toggle()
                            })                            
                            Divider()
                                .padding(1)
                            
                            Button {
                                showingDeleteAlert = true
                                isPresented.toggle()
                            } label: {
                                Text("삭제하기")
                                    .modifier(MenuBtnText())
                                    .foregroundStyle(Color.red)
                            }
                        }
                    }
                }
                .frame(width: 110, height: isPresented ? UserManager.shared.uid != noticeBoard.userId ? 120 : 80 : 0)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .circular)
                        .foregroundColor(Color(uiColor: .systemGray6))
                )
                .padding(.trailing)
                .padding(.top, noticeBoard.isChange ? 100 : 0)
                .alert("게시물을 삭제하시겠습니까?", isPresented: $showingDeleteAlert, actions: {
                    Button("삭제", role: .destructive) {
                        postViewModel.deletePost(noticeBoardId: noticeBoard.id)
                        dismiss()
                    }
                    
                    Button("취소", role: .cancel) {
                        showingDeleteAlert = false
                    }
                }, message: {
                    Text("삭제하면 게시물 내용이 모두 삭제되고 게시물 목록에서도 삭제됩니다.")
                        .font(.system(size: 10))
                })
            }
            Spacer()
        }
    }
}

extension PostMenuBtnsView {
    struct MenuBtnText: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.system(size: 15, weight: .medium))
                .padding(1)
        }
    }
}
