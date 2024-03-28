//
//  TabPathViewModel.swift
//  BookBridge
//
//  Created by 김건호 on 3/6/24.
//

import Foundation
class TabPathViewModel: ObservableObject {
  @Published var paths: [TabPathType]
  
  init(paths: [TabPathType] = []) {
    self.paths = paths
  }
}
