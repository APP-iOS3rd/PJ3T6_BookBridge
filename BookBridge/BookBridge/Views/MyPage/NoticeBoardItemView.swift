//
//  NoticeBoardItemView.swift
//  BookBridge
//
//  Created by 노주영 on 2/21/24.
//

import SwiftUI

struct NoticeBoardItemView: View {
    @StateObject var viewModel: NoticeBoardViewModel
    
    var homeFirebaseManager = HomeFirebaseManager.shared
    
    var author: String
    var date: Date
    var id: String
    var imageLinks: [String]
    var isChange: Bool
    var locate: String
    var title: String
    
    var body: some View {
        HStack {
            if imageLinks.isEmpty {
                Image("Character")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 100)
                    .foregroundStyle(.black)
                    .cornerRadius(10)
                    .padding()
            } else {
                Image(uiImage:
                        (isChange ? viewModel.changeNoticeBoardsDic[id] : viewModel.findNoticeBoardsDic[id]) ?? UIImage(named: "Character")!
                )
                .resizable()
                .frame(width: 75, height: 100)
                .foregroundStyle(.black)
                .cornerRadius(10)
                .padding()
            }
            
            
            VStack(alignment: .leading, spacing: 0){
                Divider().opacity(0)
                Text("\(title)")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 10)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text("\(author)")
                    .font(.system(size: 10))
                    .padding(.top, 5)
                    .foregroundStyle(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Text("\(locate.count>=20 ? locate.components(separatedBy: " ")[3] : locate) | \(ConvertManager.getTimeDifference(from: date))")
                    .font(.system(size: 10))
                    .padding(.bottom, 10)
                    .foregroundStyle(Color(red: 75/255, green: 75/255, blue: 75/255))
            }
            
            Spacer()
            
            VStack{
                Button {
                    viewModel.bookMarkToggle(id: id)
                } label: {
                    if (viewModel.bookMarks.contains(id)) {
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 20))
                            .padding()
                            .foregroundColor(.black)
                    } else {
                        Image(systemName: "bookmark")
                            .font(.system(size: 20))
                            .padding()
                            .foregroundColor(.black)
                    }
                }
                Spacer()
            }
        }
        .frame(height: 120, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .circular)
                .foregroundColor(Color(red: 230/255, green: 230/255, blue: 230/255))
        )
        .onAppear {
            if !imageLinks.isEmpty {
                viewModel.getDownLoadImage(isChange: isChange, noticeBoardId: id, urlString: imageLinks[0])
            }
        }
    }

}
