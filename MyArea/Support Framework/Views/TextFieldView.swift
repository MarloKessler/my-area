//
//  TextFieldView.swift
//  SupportFiles
//
//  Created by Marlo Kessler on 23.02.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI

public struct TextFieldView: UIViewRepresentable {
    @Binding private var attributedText: NSAttributedString
    
    private var placeholder: String = ""
    private var textColor: Color = .primary
    private var font: UIFont = UIFont.systemFont(ofSize: 18)
    private var textAlignment: NSTextAlignment = .left
    private var autocapitalizationType: UITextAutocapitalizationType = .sentences
    private var autocorrectionType: UITextAutocorrectionType = .default
    private var isSecureTextEntry: Bool = false
    private var clearsOnInsertion: Bool = false
    private var linkTextAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key : Any]()
    private var allowsEditingTextAttributes: Bool = true
    
    private var isDisabled: Bool = false
    private var isSelectable: Bool = true
    private var isScrollEnabled: Bool = true
    private var range: NSRange? = nil
    private var keyboardType: UIKeyboardType = .default
    private var usesStandardTextScaling: Bool = false
    private var textFieldStyle: TextFieldViewStyle = .plain
    
    public init(attributedText: Binding<NSAttributedString>) {
        self._attributedText = attributedText
    }
    
    private init(attributedText: Binding<NSAttributedString>,
                 placeholder: String,
                 textColor: Color,
                 font: UIFont,
                 textAlignment: NSTextAlignment,
                 isDisabled: Bool,
                 isSelectable: Bool,
                 isScrollEnabled: Bool = true,
                 autocapitalizationType: UITextAutocapitalizationType = .sentences,
                 autocorrectionType: UITextAutocorrectionType  = .default,
                 isSecureTextEntry: Bool = false,
                 keyboardType: UIKeyboardType = .default,
                 allowsEditingTextAttributes: Bool,
                 range: NSRange?,
                 clearsOnInsertion: Bool,
                 linkTextAttributes: [NSAttributedString.Key : Any],
                 usesStandardTextScaling: Bool,
                 textFieldStyle: TextFieldViewStyle) {
        
        self._attributedText = attributedText
        
        self.placeholder = placeholder
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.isDisabled = isDisabled
        self.isSelectable = isSelectable
        self.isScrollEnabled = isScrollEnabled
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.isSecureTextEntry = isSecureTextEntry
        self.keyboardType = keyboardType
        self.allowsEditingTextAttributes = allowsEditingTextAttributes
        self.range = range
        self.clearsOnInsertion = clearsOnInsertion
        self.linkTextAttributes = linkTextAttributes
        self.usesStandardTextScaling = usesStandardTextScaling
        self.textFieldStyle = textFieldStyle
    }
    
    public func makeUIView(context: UIViewRepresentableContext<TextFieldView>) -> UIView {
        let textView = UITextView()
        
        //Sets a placeholder if attributedText is empty.
        if attributedText.string.isEmpty {
            textView.attributedText = NSAttributedString(string: placeholder)
            textView.textColor = UIColor.lightGray
        } else {
            textView.attributedText = attributedText
            textView.textColor = UIColor(named: "Primary")//color.uiColor
        }
        
        textView.delegate = context.coordinator
        
        textView.font = font
        textView.textAlignment = textAlignment
        textView.autocapitalizationType = autocapitalizationType
        textView.autocorrectionType = autocorrectionType
        textView.isSecureTextEntry = isSecureTextEntry
        textView.clearsOnInsertion = clearsOnInsertion
        textView.linkTextAttributes = linkTextAttributes
        textView.allowsEditingTextAttributes = allowsEditingTextAttributes
        
        textView.isEditable = !isDisabled
        textView.isSelectable = isSelectable
        textView.isScrollEnabled = isScrollEnabled
        if let range = range {
            textView.scrollRangeToVisible(range)
        }
        textView.keyboardType = keyboardType
        textView.usesStandardTextScaling = usesStandardTextScaling
        
        switch textFieldStyle {
        case .plain:
            break
        case .roundedBorders(let width, let radius):
            textView.layer.borderColor = UIColor.lightGray.cgColor
            textView.layer.borderWidth = width
            textView.clipsToBounds = true
            textView.layer.cornerRadius = radius
        case .squaredBorders(let width):
            textView.layer.borderColor = UIColor.lightGray.cgColor
            textView.layer.borderWidth = width
        }
        
        return textView
    }
    
    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<TextFieldView>) {}
    
    public func makeCoordinator() -> TextFieldView.Coordinator {
        return Coordinator(attributedText: $attributedText, placeholder: placeholder)
    }
    
    public class Coordinator: NSObject, UITextViewDelegate {
        @Binding private var attributedText: NSAttributedString
        private var placeholder: String
        
        init(attributedText: Binding<NSAttributedString>, placeholder: String) {
            self._attributedText = attributedText
            self.placeholder = placeholder
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            attributedText = textView.attributedText
        }
        
        public func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = placeholder
                textView.textColor = UIColor.lightGray
            }
        }
    }
    
//    public func foregroundColor(_ color: Color?) -> TextFieldView {
//        return TextView(attributedString: attributedString, height: _height, color: color ?? .primary, textAlignment: textAlignment)
//    }
    
    public func multilineTextAlignment(_ alignment: TextAlignment) -> TextFieldView {
        let textAlignment: NSTextAlignment
        
        switch alignment {
        case .center:
            textAlignment = .center
        case .leading:
            textAlignment = .left
        case .trailing:
            textAlignment = .right
        }
        
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    public func placeholder(_ placeholder: String) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    public func disabled(_ disabled: Bool) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: disabled,
                             isSelectable: isSelectable,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    public func font(_ font: UIFont?) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font ?? self.font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
        
    }
    
    ///Toggle selectability, which controls the ability of the user to select content and interact with URLs & attachments. On tvOS this also makes the text view focusable.
    public func isSelectable(_ isSelectable: Bool) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    ///defaults to NO
    public func allowsEditingTextAttributes(_ allowsEditingTextAttributes: Bool) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    public func range(_ range: NSRange) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    ///defaults to NO. if YES, the selection UI is hidden, and inserting text will replace the contents of the field. changing the selection will automatically set this to NO.
    public func clearsOnInsertion(_ clearsOnInsertion: Bool) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    /// Style for links
    public func linkTextAttributes(_ linkTextAttributes: [NSAttributedString.Key : Any]) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    /// When turned on, this changes the rendering scale of the text to match the standard text scaling and preserves the original font point sizes when the contents of the text view are copied to the pasteboard.  Apps that show a lot of text content, such as a text viewer or editor, should turn this on and use the standard text scaling.
    public func usesStandardTextScaling(_ usesStandardTextScaling: Bool) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    ///Enables the scroll function.
    public func isScrollEnabled(_ isScrollEnabled: Bool) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             isScrollEnabled: isScrollEnabled,
                             autocapitalizationType: autocapitalizationType,
                             autocorrectionType: autocorrectionType,
                             isSecureTextEntry: isSecureTextEntry,
                             keyboardType: keyboardType,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    ///Set the autocapitalization type.
    public func autocapitalizationType(_ autocapitalizationType: UITextAutocapitalizationType) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             isScrollEnabled: isScrollEnabled,
                             autocapitalizationType: autocapitalizationType,
                             autocorrectionType: autocorrectionType,
                             isSecureTextEntry: isSecureTextEntry,
                             keyboardType: keyboardType,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    ///Set the autocorrection type.
    public func autocorrectionType(_ autocorrectionType: UITextAutocorrectionType) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             isScrollEnabled: isScrollEnabled,
                             autocapitalizationType: autocapitalizationType,
                             autocorrectionType: autocorrectionType,
                             isSecureTextEntry: isSecureTextEntry,
                             keyboardType: keyboardType,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    ///Enables the secure entry.
    public func isSecureTextEntry(_ isSecureTextEntry: Bool) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             isScrollEnabled: isScrollEnabled,
                             autocapitalizationType: autocapitalizationType,
                             autocorrectionType: autocorrectionType,
                             isSecureTextEntry: isSecureTextEntry,
                             keyboardType: keyboardType,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    ///Set the keyboard type.
    public func keyboardType(_ keyboardType: UIKeyboardType) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             isScrollEnabled: isScrollEnabled,
                             autocapitalizationType: autocapitalizationType,
                             autocorrectionType: autocorrectionType,
                             isSecureTextEntry: isSecureTextEntry,
                             keyboardType: keyboardType,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    //Set the field style.
    public func style(_ textFieldStyle: TextFieldViewStyle) -> TextFieldView {
        return TextFieldView(attributedText: $attributedText,
                             placeholder: placeholder,
                             textColor: textColor,
                             font: font,
                             textAlignment: textAlignment,
                             isDisabled: isDisabled,
                             isSelectable: isSelectable,
                             isScrollEnabled: isScrollEnabled,
                             autocapitalizationType: autocapitalizationType,
                             autocorrectionType: autocorrectionType,
                             isSecureTextEntry: isSecureTextEntry,
                             keyboardType: keyboardType,
                             allowsEditingTextAttributes: allowsEditingTextAttributes,
                             range: range,
                             clearsOnInsertion: clearsOnInsertion,
                             linkTextAttributes: linkTextAttributes,
                             usesStandardTextScaling: usesStandardTextScaling,
                             textFieldStyle: textFieldStyle)
    }
    
    public enum TextFieldViewStyle {
        case plain
        case roundedBorders(width: CGFloat = 1, radius: CGFloat =  5)
        case squaredBorders(width: CGFloat = 1)
    }
}
