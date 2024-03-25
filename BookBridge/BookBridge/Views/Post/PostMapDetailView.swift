//
//  PostMapSeeMoreView.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/15.
//

import SwiftUI

struct PostMapDetailView: View {
    @Binding var noticeBoard: NoticeBoard

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        PostMapView(lat: $noticeBoard.noticeLocation[0], lng: $noticeBoard.noticeLocation[1], isDetail: true)
            .navigationTitle(noticeBoard.isChange ? "바꿔요" : "구해요")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16))
                            .foregroundStyle(.black)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .edgesIgnoringSafeArea(.bottom)
    }
}
