//
//  AlarmSettingView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/5/24.
//

import SwiftUI

struct AlarmSettingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var isNoticeBoardAlarm: Bool = true
    @State var isNewsAlarm: Bool = true
    @State var isMarketingAlarm: Bool = false
    
    @AppStorage("isAlarmEnabled") private var isChattingAlarm = true

    var body: some View {
        VStack {
            HStack {
                Text("채팅 알림")
                    .padding(.vertical, 10)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
                Spacer()
                Toggle("", isOn: $isChattingAlarm)
            }
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
            )
            .padding(.top, 10)
            
            HStack {
                Text("관심 게시물 알림")
                    .padding(.vertical, 10)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
                Spacer()
                Toggle("", isOn: $isNoticeBoardAlarm)
            }
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
            )
            
            HStack {
                Text("소식 알림")
                    .padding(.vertical, 10)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
                Spacer()
                Toggle("", isOn: $isNewsAlarm)
            }
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
            )
            
            HStack {
                Text("마케팅 수신 동의")
                    .padding(.vertical, 10)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
                Spacer()
                Toggle("", isOn: $isMarketingAlarm)
            }
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
            )
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    AlarmSettingView()
}
