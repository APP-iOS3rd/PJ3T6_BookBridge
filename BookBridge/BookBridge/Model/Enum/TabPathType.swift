//
//  TabPathType.swift
//  BookBridge
//
//  Created by 김건호 on 3/6/24.
//

import Foundation
enum TabPathType : Hashable {
        
    case mypage(other: UserModel)
    
    case postview(noticeboard : NoticeBoard)
    
    case chatMessage(isAlarm: Bool?, chatRoomListId: String, chatRoomPartner: ChatPartnerModel, noticeBoardTitle: String, uid: String)
    
    case chatRoomList(chatRoomList: [String], isComeNoticeBoard: Bool, uid: String)
    
}
