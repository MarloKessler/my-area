//
//  KeyboardTextfieldobserver.swift
//  Sportbeats
//
//  Created by Marlo Kessler on 12.11.19.
//  Copyright © 2019 Marlo Kessler. All rights reserved.
//

import SwiftUI
import Combine

public class KeyboardObserver: ObservableObject {
    
    @Published public var keyboardIsShown = false
    @Published public var keyboardHeight: CGFloat = 0
    
    public init() {}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    public func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        keyboardIsShown = true
        print(keyboardIsShown ? "keyboard is shown" : "keyboard is hidden")
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
            print("Height: \(keyboardHeight)")
        }
    }

    @objc func keyBoardDidHide(notification: Notification) {
        keyboardIsShown = false
    }
}
