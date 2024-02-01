//
//  BookAPIManger.swift
//  BookBridge
//
//  Created by 노주영 on 1/30/24.
//

import Foundation

class BookAPIManger {
    //결과값
    func getData(text: String, startIndex: Int, completion: (@escaping (Book) -> Void)){
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(text)&startIndex=\(startIndex)&maxResults=20&printType=books"

         guard let url = URL(string: urlString) else { return }

         let session = URLSession(configuration: .default)

         let task = session.dataTask(with: url){ data, response, error in
             if let error = error {
                 print(error.localizedDescription)
                 return
             }

             guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                 print("포스팅되지 않음")
                 return
             }

             guard let data = data else {
                 print("데이터 없음")
                 return
             }

             do {
                 let json = try JSONDecoder().decode(Book.self, from: data)
                 
                 completion(json)
             } catch let error {
                 print(error.localizedDescription)
             }
         }
         task.resume()
    }
}
