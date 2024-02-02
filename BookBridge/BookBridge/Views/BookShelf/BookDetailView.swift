//
//  BookDetailView.swift
//  BookBridge
//
//  Created by 김건호 on 2/1/24.
//

import SwiftUI

struct BookDetailView: View {
    var book: Item
    var body: some View {
        ScrollView{
            VStack{
                Spacer()
                    .frame(height: 20)
                
                Text("도서정보")
                    .font(.system(size: 20, weight: .bold))
                
                if let urlString = book.volumeInfo.imageLinks?.smallThumbnail, let url = URL(string: urlString) {
                    AsyncImage(url: url)
                        .frame(width: 150, height: 200)
                    
                    
                }
                Text("\(book.volumeInfo.title!)")
                    .font(.system(size: 24, weight: .bold))
                
                Text("\(book.volumeInfo.authors?[0] ?? "저자 없음")")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(hex: "999999"))
                
                WishBookAddBtnView()
                
                Spacer()
                    .frame(height: 10)
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "F8F8F8"))
                        .padding(.horizontal,20)
                    
                    
                    VStack(alignment: .leading, spacing: 15){
                        Text("기본정보")
                            .font(.system(size: 20, weight: .semibold))
                        
                        
                        Rectangle()
                            .fill(Color(hex: "BDBDBD"))
                            .frame(height: 1)
                        
                        HStack{
                            VStack(alignment: .leading,spacing: 15){
                                Text("· ISBN")
                                    .font(.system(size: 15, weight: .semibold))
                                
                                
                                Text("· 분류")
                                    .font(.system(size: 15, weight: .semibold))
                                Text("· 발행(출시)일자")
                                    .font(.system(size: 15, weight: .semibold))
                                Text("· 쪽수")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            Spacer()
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 15){
                                Text(isbnString(volumeInfo: book.volumeInfo))
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "9A9A9A"))
                                Text("\(book.volumeInfo.pageCount!)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "9A9A9A"))
                                Text("\(book.volumeInfo.publishedDate!)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "9A9A9A"))
                                Text("\(book.volumeInfo.pageCount!)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "9A9A9A"))
                            }
                        }
                        
                        
                        
                        Text("책 소개")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.top,20)
                        
                        
                        Rectangle()
                            .fill(Color(hex: "BDBDBD"))
                            .frame(height: 1)
                        
                        
                        Text("\(book.volumeInfo.description!)")
                    }
                    .padding(.vertical,20)
                    .padding(.horizontal, 40)
                    
                    
                    
                }
                
            }
        }
    }
    
    func isbnString(volumeInfo: VolumeInfo) -> String {
        if let identifiers = volumeInfo.industryIdentifiers {
            let identifierStrings = identifiers.map { $0.identifier ?? "" }
            return identifierStrings.joined(separator: ", ")
        }
        return "No ISBN"
    }
}




