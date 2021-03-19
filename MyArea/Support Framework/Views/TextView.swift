//
//  TextView.swift
//  SupportFiles
//
//  Created by Marlo Kessler on 11.02.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI

public struct TextView: UIViewRepresentable {
    private var attributedText: NSAttributedString
        
    private var textColor: Color = .primary
    private var font: UIFont = UIFont.systemFont(ofSize: 18)
    private var textAlignment: NSTextAlignment = .left
    private var isSelectable: Bool = true
    private var allowsEditingTextAttributes: Bool = true
    private var range: NSRange? = nil
    private var linkTextAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key : Any]()
    private var usesStandardTextScaling: Bool = false
    
    public init(_ text: String) {
        self.attributedText = NSAttributedString(string: text)
    }
    
    public init(_ attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }
    
    private init(attributedText: NSAttributedString,
                 textColor: Color,
                 font: UIFont,
                 textAlignment: NSTextAlignment,
                 isSelectable: Bool,
                 allowsEditingTextAttributes: Bool,
                 range: NSRange?,
                 linkTextAttributes: [NSAttributedString.Key : Any],
                 usesStandardTextScaling: Bool) {
        
        self.attributedText = attributedText
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.isSelectable = isSelectable
        self.allowsEditingTextAttributes = allowsEditingTextAttributes
        self.range = range
        self.linkTextAttributes = linkTextAttributes
        self.usesStandardTextScaling = usesStandardTextScaling
    }
    
    public func makeUIView(context: UIViewRepresentableContext<TextView>) -> UIView {
        let textView = UITextView()
        
        textView.attributedText = attributedText
        textView.textColor = UIColor(named: "Primary")//color.uiColor
        textView.font = font
        textView.textAlignment = textAlignment
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = isSelectable
        textView.allowsEditingTextAttributes = allowsEditingTextAttributes
        if let range = range {
            textView.scrollRangeToVisible(range)
        }
        textView.linkTextAttributes = linkTextAttributes
        textView.usesStandardTextScaling = usesStandardTextScaling
        
        return textView
    }
    
    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<TextView>) {}
    
//    public func foregroundColor(_ color: Color?) -> TextFieldView {
//        return TextView(attributedString: attributedString, height: _height, color: color ?? .primary, textAlignment: textAlignment)
//    }
    
    public func multilineTextAlignment(_ alignment: TextAlignment) -> TextView {
        let textAlignment: NSTextAlignment
        
        switch alignment {
        case .center:
            textAlignment = .center
        case .leading:
            textAlignment = .left
        case .trailing:
            textAlignment = .right
        }
        
        return TextView(attributedText: attributedText,
                        textColor: textColor,
                        font: font,
                        textAlignment: textAlignment,
                        isSelectable: isSelectable,
                        allowsEditingTextAttributes: allowsEditingTextAttributes,
                        range: range,
                        linkTextAttributes: linkTextAttributes,
                        usesStandardTextScaling: usesStandardTextScaling)
    }
    
    public func font(_ font: UIFont?) -> TextView {
        return TextView(attributedText: attributedText,
                        textColor: textColor,
                        font: font ?? self.font,
                        textAlignment: textAlignment,
                        isSelectable: isSelectable,
                        allowsEditingTextAttributes: allowsEditingTextAttributes,
                        range: range,
                        linkTextAttributes: linkTextAttributes,
                        usesStandardTextScaling: usesStandardTextScaling)
    }
            
    // toggle selectability, which controls the ability of the user to select content and interact with URLs & attachments. On tvOS this also makes the text view focusable.
    public func isSelectable(_ isSelectable: Bool) -> TextView {
        return TextView(attributedText: attributedText,
                        textColor: textColor,
                        font: font,
                        textAlignment: textAlignment,
                        isSelectable: isSelectable,
                        allowsEditingTextAttributes: allowsEditingTextAttributes,
                        range: range,
                        linkTextAttributes: linkTextAttributes,
                        usesStandardTextScaling: usesStandardTextScaling)
    }
        
    //defaults to NO
    public func allowsEditingTextAttributes(_ allowsEditingTextAttributes: Bool) -> TextView {
        return TextView(attributedText: attributedText,
                        textColor: textColor,
                        font: font,
                        textAlignment: textAlignment,
                        isSelectable: isSelectable,
                        allowsEditingTextAttributes: allowsEditingTextAttributes,
                        range: range,
                        linkTextAttributes: linkTextAttributes,
                        usesStandardTextScaling: usesStandardTextScaling)
    }
        
    public func range(_ range: NSRange) -> TextView {
        return TextView(attributedText: attributedText,
                        textColor: textColor,
                        font: font,
                        textAlignment: textAlignment,
                        isSelectable: isSelectable,
                        allowsEditingTextAttributes: allowsEditingTextAttributes,
                        range: range,
                        linkTextAttributes: linkTextAttributes,
                        usesStandardTextScaling: usesStandardTextScaling)
    }
    
    // Style for links
    public func linkTextAttributes(_ linkTextAttributes: [NSAttributedString.Key : Any]) -> TextView {
        return TextView(attributedText: attributedText,
                        textColor: textColor,
                        font: font,
                        textAlignment: textAlignment,
                        isSelectable: isSelectable,
                        allowsEditingTextAttributes: allowsEditingTextAttributes,
                        range: range,
                        linkTextAttributes: linkTextAttributes,
                        usesStandardTextScaling: usesStandardTextScaling)
    }
    
    // When turned on, this changes the rendering scale of the text to match the standard text scaling and preserves the original font point sizes when the contents of the text view are copied to the pasteboard.  Apps that show a lot of text content, such as a text viewer or editor, should turn this on and use the standard text scaling.
    public func usesStandardTextScaling(_ usesStandardTextScaling: Bool) -> TextView {
        return TextView(attributedText: attributedText,
                        textColor: textColor,
                        font: font,
                        textAlignment: textAlignment,
                        isSelectable: isSelectable,
                        allowsEditingTextAttributes: allowsEditingTextAttributes,
                        range: range,
                        linkTextAttributes: linkTextAttributes,
                        usesStandardTextScaling: usesStandardTextScaling)
    }
}
