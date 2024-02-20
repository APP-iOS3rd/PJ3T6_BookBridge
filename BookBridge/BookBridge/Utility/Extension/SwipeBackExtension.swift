//
//  SwipeEctension.swift
//  BookBridge
//
//  Created by 이현호 on 2/19/24.
//

import Foundation
import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func swipeBack(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
