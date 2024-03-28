//
//  ViewModelable.swift
//  BookBridge
//
//  Created by 이민호 on 3/11/24.
//

import Foundation
import SwiftUI
import Combine

protocol ViewModelable: ObservableObject {
  associatedtype Action
  associatedtype State
  
  
  
  func action(_ action: Action)
}
