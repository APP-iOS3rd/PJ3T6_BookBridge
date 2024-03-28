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
            TabView{
                VStack{
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
                }
                VStack{
                    HStack(alignment: .center) {
                        Image("mockup")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width / 2.4, height: UIScreen.main.bounds.height / 2.4)
                        Image("mockup2")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width / 2.4, height: UIScreen.main.bounds.height / 2.4)
                    }
                    Text("내 위치를 확인하고 설정해주세요")
                        .font(.system(size: 20))
                    Text("설정한 위치 근처에 게시글을 볼 수 있어요")
                        .font(.system(size: 20))
                }
                VStack{
                    HStack(alignment: .center) {
                        Image("mockup4")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width / 2.4, height: UIScreen.main.bounds.height / 2.4)
                        Image("mockup3")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width / 2.4, height: UIScreen.main.bounds.height / 2.4)
                    }
                    Text("구해요에는 읽지 않는 책이 올라오고")
                        .font(.system(size: 20))
                    Text("바꿔요에는 읽고 싶은 책이 올라와요")
                        .font(.system(size: 20))
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
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

