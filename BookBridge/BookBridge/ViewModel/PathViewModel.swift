//
//  Path.swift
//  BookBridge
//
//  Created by 김건호 on 1/31/24.
//

import Foundation

class PathViewModel: ObservableObject {
  @Published var paths: [PathType]
  
  init(paths: [PathType] = []) {
    self.paths = paths
  }
}
