//
//  ActivityIndicator.swift
//  SupportFiles
//
//  Created by Marlo Kessler on 30.12.19.
//  Copyright © 2019 Marlo Kessler. All rights reserved.
//

import SwiftUI

public struct ActivityIndicator: UIViewRepresentable {

    public let style: UIActivityIndicatorView.Style

    public init(style: UIActivityIndicatorView.Style) {
        self.style = style
    }
    
    public func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.startAnimating()
        return indicator
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {}
}
