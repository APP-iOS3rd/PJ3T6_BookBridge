//
//  PostPathModel.swift
//  BookBridge
//
//  Created by 김건호 on 2/15/24.
//

import Foundation

class PostPathViewModel: ObservableObject {
  @Published var paths: [PostPathType]
  
  init(paths: [PostPathType] = []) {
    self.paths = paths
  }
}
