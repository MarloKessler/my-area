//
//  ImagePickerView.swift
//  Sportbeats
//
//  Created by Marlo Kessler on 10.11.19.
//  Copyright © 2019 Marlo Kessler. All rights reserved.
//

import SwiftUI
import YPImagePicker

public struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var showView: Bool
    
    @Binding var selectedImage: UIImage?
    var imageCompletion: ((UIImage?) -> Void) = { image in }
    
    @Binding var selectedVideoURL: URL?
    var videoCompletion: ((YPMediaVideo?) -> Void) = { video in }
    
    var completion: (([YPMediaItem]?) -> Void) = { items in }
    
    var configuration: YPImagePickerConfiguration
        
    public init(showPhotoView: Binding<Bool>,
                selectedImage imageBinding: Binding<UIImage?> = Binding<UIImage?>.init(get: { return UIImage() }, set: { _ in }),
                configuration: YPImagePickerConfiguration = YPImagePickerConfiguration(),
                onComplete completion: @escaping ((UIImage?) -> Void) = { image in }) {
        
        self._showView = showPhotoView
        
        self._selectedImage = imageBinding
        self.imageCompletion = completion
        
        self._selectedVideoURL = Binding<URL?>.init(get: { return nil }, set: { _ in })
        
        self.configuration = configuration
        self.configuration.onlySquareImagesFromCamera = false
    }
    
    public init(showVideoView: Binding<Bool>,
                selectedVideoURL urlBinding: Binding<URL?> = Binding<URL?>.init(get: { return nil }, set: { _ in }),
                configuration: YPImagePickerConfiguration = YPImagePickerConfiguration(),
                onComplete completion: @escaping ((YPMediaVideo?) -> Void) = { url in }) {
        
        self._showView = showVideoView
        
        self._selectedImage = Binding<UIImage?>.init(get: { return UIImage() }, set: { _ in })
        
        self._selectedVideoURL = urlBinding
        self.videoCompletion = completion
        
        self.configuration = configuration
        self.configuration.onlySquareImagesFromCamera = false
        self.configuration.screens = [.library, .video]
        self.configuration.video.fileType = .mp4
        self.configuration.library.mediaType = .video
    }
    
    public init(showView: Binding<Bool>,
                configuration: YPImagePickerConfiguration = YPImagePickerConfiguration(),
                onComplete completion: @escaping (([YPMediaItem]?) -> Void)) {

        self._showView = showView

        self._selectedImage = Binding<UIImage?>.init(get: { return UIImage() }, set: { _ in })
        self._selectedVideoURL = Binding<URL?>.init(get: { return nil }, set: { _ in })

        self.configuration = configuration
        self.configuration.library.maxNumberOfItems = 10
        
        self.completion = completion
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIViewController {
        
        let imagePicker = YPImagePicker(configuration: configuration)
        
        imagePicker.didFinishPicking { [unowned imagePicker] items, cancelled in
            if cancelled {
                print("Picker was canceled")
                self.imageCompletion(nil)
                self.showView.toggle()
                return
            } else if items.count == 1 {
                if let photo = items.singlePhoto {
                    print("Picker was finished")
                    self.imageCompletion(photo.image)
                    self.selectedImage = photo.image
                    self.showView.toggle()
                }
                if let video = items.singleVideo {
                    print("Picker was finished")
                    self.videoCompletion(video)
                    self.selectedVideoURL = video.url
                    self.showView.toggle()
                }
            } else {
                self.completion(items)
                self.showView.toggle()
            }
        }
        
        return imagePicker
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ImagePickerView>) {}
}
