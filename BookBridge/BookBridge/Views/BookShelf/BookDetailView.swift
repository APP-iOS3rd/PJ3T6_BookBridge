//
//  BookDetailView.swift
//  BookBridge
//
//  Created by 김건호 on 2/1/24.
//

import SwiftUI

import SwiftUI

struct BookDetailView: View {
    @EnvironmentObject var viewModel: BookShelfViewModel
    @Binding var selectedPicker: tapInfo
    
    var isButton : Bool
    var book: Item
    
    var body: some View {
        ScrollView{
            VStack{
                Spacer()
                    .frame(height: 20)
                
                Text("도서정보")
                    .font(.system(size: 20, weight: .bold))
                
                if let urlString = book.volumeInfo.imageLinks?.smallThumbnail, let url = URL(string: urlString) {
                    AsyncImage(url: url){
                        image in
                        image
                            .frame(width: 150, height: 200)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 200)
                    }
                } else {
                    Image("imageNil")
                        .resizable()
                        .frame(width: 150, height: 200)
                        
                }
                
                Text("\(book.volumeInfo.title!)")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.horizontal,20)
                
                Text("\(book.volumeInfo.authors?[0] ?? "저자 없음")")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(hex: "999999"))
                
                
                if isButton {
                    WishBookAddBtnView(selectedPicker: $selectedPicker, book: book)
                        .environmentObject(viewModel)
                }
                
                
                    
                
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
                                Text("\(book.volumeInfo.industryIdentifiers?.first?.identifier ?? "정보 없음")")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "9A9A9A"))


                                Text("\(book.volumeInfo.categories?.first ?? "정보 없음")")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "9A9A9A"))
                                Text("\(book.volumeInfo.publishedDate!)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "9A9A9A"))
                              Text("\(book.volumeInfo.pageCount.map(String.init) ?? "정보 없음")")
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
                        
                        
                        Text("\(book.volumeInfo.description ?? "정보 없음")")
                    }
                    .padding(.vertical,20)
                    .padding(.horizontal, 40)
                                                            
                }
                
            }
        }
    }
    

}
