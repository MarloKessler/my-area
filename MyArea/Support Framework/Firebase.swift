//
//  Firebase.swift
//  SupportFiles
//
//  Created by Marlo Kessler on 01.01.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import Foundation

//MARK: - Storage
public class FirebaseStorageHelper {
    
    public static func imageName(for name: String, size: ImageSizes) -> String {
        return "\(size.rawValue)\(name).\(LocalStorage.FileType.image.rawValue)"
    }
    
    public static func videoName(for name: String) -> String {
        return "\(name).\(LocalStorage.FileType.video.rawValue)"
    }
    
    public enum ImageSizes: String {
        case full = ""
        case thumbnailMedium = "thumb_m_"
        case thumbnailSmall = "thumb_s_"
    }
}

public protocol FirestoreObject {
    
    ///All variables of the class should be written down as a case in the enum "Keys".
    associatedtype Keys
    
    ///Sets the values from a dictionary. Must contain all variable names as key and the correct variable type as value or it will crash.
    func setValuesFromDictionary(values: [String: Any?])
    
    ///Returns a key-value dictionary for all variables.
    func asDictionary() -> [String:  Any?]
        
    ///Updates the value of the key in the firestore.
    func updateValueOnFirestore(for key: Keys)
    
    ///Updates the value of the keys in the firestore.
    func updateValuesOnFirestore(for keys: [Keys])
    
    ///Updates all values on Firestore with the local ones.
    func updateOnFirestore()
    
    ///Updates all local values with values from Firestore.
    func updateFromFirestore()
}

//Not in use yet
//enum FirestoreKeys: String {
//    case user = "user"
//    case newsSection = "newsSection"
//    case posts = "posts"
//    case likes = "likes"
//    case postComments = "postComments"
//}
