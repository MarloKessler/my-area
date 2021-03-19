//
//  Trader.swift
//  MyArea
//
//  Created by Marlo Kessler on 21.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import Foundation
import Firebase

class Trader: Identifiable, ObservableObject{
    
    let id: String
    
    @Published var name: String?
    @Published var description: String?
    @Published var categories: [Category] = [Category]()
    
    @Published var email: String?
    @Published var showEmail: Bool = false
    @Published var phoneNumber: String?
    @Published var showPhoneNumber: Bool = false
    @Published var address: String?
    @Published var showAddress: Bool = false
    
    @Published var postalCode: String?
    
    @Published var thumbnail: UIImage?
    @Published var image: UIImage?
    
    var storageRef: StorageReference {
        get {
            return Storage.storage().reference()
                .child("traders")
                .child(id)
        }
    }
        
    init(id: String = UUID().uuidString,
         
         name: String? = nil,
         description: String? = nil,
         categories: [Category] = [.andere],
         
         email: String? = nil,
         showEmail: Bool = false,
         phoneNumber: String? = nil,
         showPhoneNumber: Bool = false,
         address: String? = nil,
         showAddress: Bool = false,
         
         postalCode: String? = nil,
         
         thumbnail: UIImage? = nil,
         image: UIImage? = nil) {
        
        self.id = id
        
        self.name = name
        self.description = description
        self.categories = categories
        
        self.email = email
        self.showEmail = showEmail
        self.phoneNumber = phoneNumber
        self.showPhoneNumber = showPhoneNumber
        self.address = address
        self.showAddress = showAddress
        
        self.postalCode = postalCode
        
        self.thumbnail = thumbnail
        self.image = image
        
        loadThumbmnail()
    }
    
    init(id: String = UUID().uuidString, dictionary: [String: Any?]) {
        self.id = id
        
        self.name = dictionary[Keys.name.rawValue] as? String
        self.description = dictionary[Keys.description.rawValue] as? String
        if let dictCategories = dictionary[Keys.categories.rawValue] as? [String] {
            for category in dictCategories {
                if let cat = Category(rawValue: category) {
                    self.categories.append(cat)
                }
            }
        } else {
            self.categories = [.andere]
        }
        
        self.email = dictionary[Keys.email.rawValue] as? String
        self.showEmail = dictionary[Keys.showEmail.rawValue] as? Bool ?? false
        self.phoneNumber = dictionary[Keys.phoneNumber.rawValue] as? String
        self.showPhoneNumber = dictionary[Keys.showPhoneNumber.rawValue] as? Bool ?? false
        self.address = dictionary[Keys.address.rawValue] as? String
        self.showAddress = dictionary[Keys.showAddress.rawValue] as? Bool ?? false
        
        self.postalCode = dictionary[Keys.postalCode.rawValue] as? String
        
        loadThumbmnail()
    }
    
    private func loadThumbmnail() {
        if thumbnail == nil {
            storageRef
                .child("Thumb_profileImage.png")
                .getData(maxSize: 10000000) { data, error in
                    if error == nil {
                        if let data = data, let image = UIImage(data: data) {
                            self.thumbnail = image
                        }
                    } else {
                        print("Error while loading Thumbnails \(error)")
                    }
            }
        }
    }
    
    func loadImage() {
        if image == nil {
            storageRef
                .child("profileImage.png")
                .getData(maxSize: 100000000) { data, error in
                    if error == nil {
                        if let data = data, let image = UIImage(data: data) {
                            self.image = image
                        }
                    } else {
                        print("Error while loading Images \(error)")
                    }
            }
        }
    }
    
    func asDictionary() -> [String: Any?] {
        var dictionary: [String: Any?] = [String: Any?]()
        dictionary[Keys.name.rawValue] = name
        dictionary[Keys.description.rawValue] = description
        
        var cats = [String]()
        for cat in categories {
            cats.append(cat.rawValue)
        }
        dictionary[Keys.categories.rawValue] = cats
        
        dictionary[Keys.email.rawValue] = email
        dictionary[Keys.showEmail.rawValue] = showEmail
        dictionary[Keys.phoneNumber.rawValue] = phoneNumber
        dictionary[Keys.showPhoneNumber.rawValue] = showPhoneNumber
        dictionary[Keys.address.rawValue] = address
        dictionary[Keys.showAddress.rawValue] = showAddress
        
        dictionary[Keys.postalCode.rawValue] = postalCode
        
        return dictionary
    }
    
    enum Keys: String {
        case name = "name"
        case description = "description"
        case categories = "categories"
        
        case email = "email"
        case showEmail = "showEmail"
        case phoneNumber = "phoneNumber"
        case showPhoneNumber = "showPhoneNumber"
        case address = "address"
        case showAddress = "showAddress"
        
        case postalCode = "postalCode"
    }
}
