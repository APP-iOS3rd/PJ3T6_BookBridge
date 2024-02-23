//
//  ChangePostingView.swift
//  BookBridge
//
//  Created by 이현호 on 1/29/24.

import SwiftUI

struct ImageDropDelegate: DropDelegate {
    @Binding var draggedItem: UIImage?
    @Binding var items: [UIImage]
    
    let item: UIImage
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem else {
            return
        }
        
        if draggedItem != item {
            let from = items.firstIndex(of: draggedItem)!
            let to = items.firstIndex(of: item)!
            withAnimation(.default) {
                self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
    }
}
