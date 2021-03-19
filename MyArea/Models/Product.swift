//
//  Product.swift
//  MyArea
//
//  Created by Marlo Kessler on 21.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import Foundation
import Firebase

class Product: Identifiable, ObservableObject{
    
    let id: String
    let traderID: String
    
    @Published var title: String?
    @Published var subtitle: String?
    @Published var description: String?
    @Published var category: Category
    @Published var isVisible: Bool
    var imageIDs: [String] = [String]()
    var thumbnails: [UIImage] = [UIImage]()
    var images: [UIImage] = [UIImage]()
    
    var storageRef: StorageReference {
        get {
            return Storage.storage().reference()
                .child("traders")
                .child(traderID)
                .child("products")
                .child(id)
        }
    }
    
    init(id: String = UUID().uuidString, traderID: String = UUID().uuidString, title: String? = nil, subtitle: String? = nil, description: String? = nil, category: Category = .andere, isVisible: Bool = false, imageIDs: [String] = [String](), thumbnails: [UIImage] = [UIImage](), images: [UIImage] = [UIImage]()) {
        self.id = id
        self.traderID = traderID
        
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.category = category
        self.isVisible = false
        
        self.imageIDs = imageIDs
        self.thumbnails = thumbnails
        self.images = images
        
        loadThumbmnails()
    }
    
    init(id: String = UUID().uuidString, dictionary: [String: Any?]) {
        self.id = id
        self.traderID = dictionary[Keys.traderID.rawValue] as? String ?? UUID().uuidString
        
        self.title = dictionary[Keys.title.rawValue] as? String
        self.subtitle = dictionary[Keys.subtitle.rawValue] as? String
        self.description = dictionary[Keys.description.rawValue] as? String
        self.category = Category(rawValue: dictionary[Keys.category.rawValue] as? String ?? "") ?? .andere
        self.isVisible = dictionary[Keys.isVisible.rawValue] as? Bool ?? false
        
        self.imageIDs = dictionary[Keys.imageIDs.rawValue] as? [String] ?? [String]()
        
        loadThumbmnails()
    }
    
    private func loadThumbmnails() {
        if thumbnails.isEmpty {
            for imageID in imageIDs {
                storageRef
                    .child("Thumb_\(imageID).png")
                    .getData(maxSize: 10000000) { data, error in
                        if error == nil {
                            if let data = data, let image = UIImage(data: data) {
                                var images = self.thumbnails
                                images.append(image)
                                self.thumbnails = images
                            }
                        } else {
                            print("Error while loading Thumbnails \(error)")
                        }
                }
            }
        }
    }
    
    func loadImages() {
        if images.isEmpty {
            for imageID in imageIDs {
                storageRef
                    .child("\(imageID).png")
                    .getData(maxSize: 100000000) { data, error in
                        if error == nil {
                            if let data = data, let image = UIImage(data: data) {
                                var images = self.images
                                images.append(image)
                                self.images = images
                            }
                        } else {
                            print("Error while loading Images \(error)")
                        }
                }
            }
        }
    }
    
    func asDictionary() -> [String: Any?] {
        var dictionary: [String: Any?] = [String: Any?]()
        dictionary[Keys.title.rawValue] = title
        dictionary[Keys.subtitle.rawValue] = subtitle
        dictionary[Keys.category.rawValue] = category.rawValue
        dictionary[Keys.description.rawValue] = description
        dictionary[Keys.isVisible.rawValue] = isVisible
        dictionary[Keys.imageIDs.rawValue] = imageIDs
        
        return dictionary
    }
    
    enum Keys: String {
        case traderID = "traderID"
        case title = "title"
        case subtitle = "subtitle"
        case description = "description"
        case category = "category"
        case isVisible = "isVisible"
        case imageIDs = "imageIDs"
    }
}
