//
//  MessageItemView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI

//View의 크기를 알기위해 사용하는 변수
struct sizePreferenceKey: PreferenceKey{
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct MessageListView: View {
    @StateObject var viewModel: ChatMessageViewModel
    @State var keyboardHeight: CGFloat = 0
    @State var heigtVStackMain: CGFloat = 0
    
    var partnerId: String
    var partnerImageURL: String
    var uid: String
    
    static let emptyScrollToString = "Empty"
    
    var body: some View {
        GeometryReader { g in
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(viewModel.chatMessages) { chatMessage in
                            MessageItemView(messageModel: ChatMessageModel(date: chatMessage.date, imageURL: chatMessage.imageURL, location: chatMessage.location, message: chatMessage.message, sender: chatMessage.sender), partnerId: partnerId, partnerImageURL: partnerImageURL, uid: uid)
                        }
                        HStack {
                            Spacer()
                        }
                        .id(Self.emptyScrollToString)
                    }
//                    .offset(y: -self.keyboardHeight)
//                    .animation(.spring())
//                    .onAppear {
//                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
//                            let keyboardFrame = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//                            self.keyboardHeight = keyboardFrame.height
//                        }
//                        
//                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
//                            self.keyboardHeight = 0
//                        }
//                    }
                    // 자동 스크롤
                    .onReceive(viewModel.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                        }
                    }
                }
            }
            .background(
                //SwiftUI 에서는 각 뷰의 크기를 구하는것이 함수화 되어있지않다 그래서 살짝 꼼수를 사용해야하는데
                //내가 상단으로 인지하고싶은 부분에 투명한 색상의 배경을 하나 선언을 해주고
                //선언한 투명한 배경의 크기를 구한다.
                
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: sizePreferenceKey.self, value: proxy.size)
                }
            )
            //SizePreferenceKey.self 값이 변경될때마다 실행되는 트리거를 실행하고
            //이렇게 구한 화면의 크기를 heigtVStackMain 변수에 넣어준다.
            .onPreferenceChange(sizePreferenceKey.self){ newSize in
                self.heigtVStackMain = newSize.height
                print("높이 :  \(self.heigtVStackMain)")
            }
        }
    }
}
