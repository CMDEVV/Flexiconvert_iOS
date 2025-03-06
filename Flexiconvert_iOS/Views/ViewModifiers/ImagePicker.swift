//
//  ImagePicker.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 3/5/25.
//
import Foundation
import SwiftUI
import UIKit
import AVFoundation
import PhotosUI
import UniformTypeIdentifiers

struct MultiPhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Binding var imageExtensions: [String]

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 0 // 0 means unlimited selection
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: MultiPhotoPicker

        init(_ parent: MultiPhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            parent.selectedImages.removeAll()
            parent.imageExtensions.removeAll()
            
            let dispatchGroup = DispatchGroup()
            
            for result in results {
                let provider = result.itemProvider
                
                dispatchGroup.enter()
                if let identifier = provider.registeredTypeIdentifiers.first, let utType = UTType(identifier) {
                    let fileExtension = utType.preferredFilenameExtension ?? "unknown"
                    DispatchQueue.main.async {
                        self.parent.imageExtensions.append(fileExtension)
                    }
                }
                
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { image, _ in
                        if let uiImage = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(uiImage)
                            }
                        }
                        dispatchGroup.leave()
                    }
                } else {
                    dispatchGroup.leave()
                }
            }
        }
    }
}
