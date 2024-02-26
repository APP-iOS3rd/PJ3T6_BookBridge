//
//  LaunchScreenView.swift
//  BookBridge
//
//  Created by jonghyun baik on 2/23/24.
//

import SwiftUI

struct LaunchScreenView: View {
    @Binding var isOnboardingActive: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Image("Character")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
            }
            .padding(.top, 100)
            HStack(alignment: .bottom) {
                Text("책다리")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                Text("우리 동네 책교환")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            }
            .padding()
            Text("내 위치를 중심으로 안 읽는 책을 교환해봐요")
                .font(.system(size: 20))
            Spacer()
            Button {
                isOnboardingActive = false
            } label: {
                Text("보러가기")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(hex:"59AAE0"))
                    .cornerRadius(10)
            }
            .padding(30)
        }
        
        
    }
}

