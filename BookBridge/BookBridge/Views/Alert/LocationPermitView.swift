//
//  LocationPermitView.swift
//  BookBridge
//
//  Created by 이민호 on 3/4/24.
//

import SwiftUI

struct LocationPermitView: View {
    @State var offset: CGFloat = 230
    @Binding var isShowingText: Bool
    
    private var animation: Animation {
        .easeInOut(duration: 0.5)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(
                """
                현재위치를 사용하기 위해
                설정 - 개인정보 보호 및 보안 - 위치서비스에서
                BookBridge의 위치권한을 변경해주세요
                """
            )
            .font(.system(size: 15))
            .foregroundStyle(Color(hex: "73706F"))
            .padding()
            .background(Color(hex: "F3F0EF").opacity(1.0))
            .cornerRadius(10)
            
            
            Button {
                withAnimation(animation) {
                    isShowingText.toggle()
                }
            } label: {
                Image(systemName: "multiply")
                    .resizable() // 이미지 크기 조절 가능하도록 설정
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color(hex: "73706F"))
            }
            .padding(.top, 10)
            .padding(.trailing, 10)
        }
        .offset(y: offset) // Y축 위치를 offset 변수로 지정
        .opacity(isShowingText ? 1 : 0) // 투명도 조절
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 { // 아래로 스와이프하는 동안에만 동작
                        offset = max(value.translation.height + offset, offset) // Y축 이동량을 제한하여 화면에서 사라지지 않도록 함
                    }
                }
                .onEnded { value in
                    if value.translation.height > 50 { // 스와이프한 거리가 일정 값 이상이면
                        withAnimation(animation) {
                            isShowingText = false // LocationPermitView를 숨김
                        }
                    } else {
                        offset = 230 // 스와이프한 거리가 일정 값 이상이 아니면 LocationPermitView를 원래 위치로 복귀
                    }
                }
        )
    }
}

//#Preview {
//    LocationPermitView()
//}
