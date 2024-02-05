//
//  ImagePicker.swift
//  BookBridge
//
//  Created by 이현호 on 1/29/24.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var isVisible: Bool
    @Binding var images: [UIImage]
    var sourceType: Int
    
    static let maxSelections = 5
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        if sourceType == 0 {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = context.coordinator
            return picker
        } else {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = ImagePicker.maxSelections - images.count
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = context.coordinator
            return picker
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isVisible = false
            
            let imageLoadGroup = DispatchGroup()
            
            for result in results {
                imageLoadGroup.enter()
                
                result.itemProvider.loadObject(ofClass: UIImage.self) { [self] (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            if self.parent.images.count < ImagePicker.maxSelections {
                                self.parent.images.append(image)
                            }
                        }
                    }
                    imageLoadGroup.leave()
                }
            }
            
            imageLoadGroup.notify(queue: .main) {
                // 이미지 로드가 완료되면 여기에 추가 작업
            }
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                if parent.images.count < ImagePicker.maxSelections {
                    parent.images.append(image)
                }
            }
            parent.isVisible = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isVisible = false
        }
    }
}
