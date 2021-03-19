//
//  Extensions.swift
//  Sportbeats
//
//  Created by Marlo Kessler on 29.10.19.
//  Copyright © 2019 Marlo Kessler. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation


public extension View {
    func endEditing(force isForced: Bool) {
        for window in UIApplication.shared.windows {
            window.endEditing(isForced)
        }
    }
}



//extension UIViewController {
//
//    //Hides the keyboard when tap on view
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}



//extension AnyTransition {
//    static var moveAndFade: AnyTransition {
//        let insertion = AnyTransition.move(edge: .trailing)
//            .combined(with: .opacity)
//        let removal = AnyTransition.scale
//            .combined(with: .opacity)
//        return .asymmetric(insertion: insertion, removal: removal)
//    }
//}



public extension Color {

//    var uiColor: UIColor {
//        let components = self.components()
//        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
//    }
//
//    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
//        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
//        var hexNumber: UInt64 = 0
//        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
//
//        let result = scanner.scanHexInt64(&hexNumber)
//        if result {
//            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//            a = CGFloat(hexNumber & 0x000000ff) / 255
//        }
//        return (r, g, b, a)
//    }
    
    static func getColor(ofType color: Color.Types) -> Color {
        switch color {
        case .black:
            return Color.black
        case .blue:
            return Color.blue
        case .clear:
            return Color.clear
        case .gray:
            return Color.gray
        case .green:
            return Color.green
        case .orange:
            return Color.orange
        case .pink:
            return Color.pink
        case .primary:
            return Color.primary
        case .purple:
            return Color.purple
        case .red:
            return Color.red
        case .secondary:
            return Color.secondary
        case .white:
            return Color.white
        case .yellow:
            return Color.yellow
        }
    }
    
    var colorType: Types? {
        get {
            switch self {
            case .black:
                return .black
            case .blue:
                return .blue
            case .clear:
                return .clear
            case .gray:
                return .gray
            case .green:
                return .green
            case .orange:
                return .orange
            case .pink:
                return .pink
            case .primary:
                return .primary
            case .purple:
                return .purple
            case .red:
                return .red
            case .secondary:
                return .secondary
            case .white:
                return .white
            case .yellow:
                return .yellow
            default:
                return nil
            }
        }
    }
    
    enum Types: String, Hashable {
        case black = "black"
        case blue = "blue"
        case clear = "clear"
        case gray = "gray"
        case green = "green"
        case orange = "orange"
        case pink = "pink"
        case primary = "primary"
        case purple = "purple"
        case red = "red"
        case secondary = "secondary"
        case white = "white"
        case yellow = "yellow"
    }
}



public extension CMTime {
    var roundedSeconds: TimeInterval {
        return seconds.rounded()
    }
    var hours: Int {
        guard !roundedSeconds.isNaN && !roundedSeconds.isInfinite else {
            return 0
        }
        return Int(roundedSeconds / 3600)
    }
    var minute: Int {
        guard !roundedSeconds.isNaN && !roundedSeconds.isInfinite else {
            return 0
        }
        return Int(roundedSeconds.truncatingRemainder(dividingBy: 3600) / 60)
    }
    var second: Int {
        guard !roundedSeconds.isNaN && !roundedSeconds.isInfinite else {
            return 0
        }
        return Int(roundedSeconds.truncatingRemainder(dividingBy: 60))
    }
    
    ///The current positional time in a String.
    var positionalTime: String {
        return hours > 0 ? String(format: "%d:%02d:%02d", hours, minute, second) : String(format: "%02d:%02d", minute, second)
    }
}



public extension String {
    
    ///Checks if an email adress is valid.
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    ///Returns the string as NSAttributedString
    var htmlToAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        print("HTML TEXT: ")
        print("")
        print("\(self)")
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return nil
        }
    }
}

public extension NSAttributedString {
    func toHTML() -> String? {
        var resultHtmlText: String? = nil
        do {
            let range = NSRange(location: 0, length: self.length)
            let attributes = [DocumentAttributeKey.documentType: DocumentType.html]

            let data = try self.data(from: range, documentAttributes: attributes)

            if let htmlText = String(data: data, encoding: .utf8) {
                print("RTFD TEXT: ")
                print("")
                print("\(htmlText)")
                resultHtmlText = htmlText
            }
        } catch {}
        return resultHtmlText
    }
}



public extension Int {
    ///Formats a number to a String.
    func toFormattedString() -> String {
        let formatter = NumberFormatter()
//        formatter.groupingSeparator = "."
        formatter.numberStyle = .none
        return formatter.string(for: self) ?? ""
    }
}



public extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func toString(timeStyle: DateFormatter.Style, dateStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = timeStyle
        formatter.dateStyle = dateStyle
        return formatter.string(from: self)
    }
    
    func timeString(from date: Date) -> String {
        if self.hours(from: date) > 0 {
            return hoursMinutesAndSeconds(from: date)
        } else {
            return minutesAndSeconds(from: date)
        }
    }
    
    func minutesAndSeconds(from date: Date) -> String{
        
        let minutes = (self.minutes(from: date) % 60)
        let stringMinutes = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        let seconds = (self.seconds(from: date) % 60)
        let stringSeconds = seconds  > 9 ? "\(seconds)" : "0\(seconds)"
        
        let result = "\(stringMinutes) : \(stringSeconds)"
        
        return result
    }
    
    func hoursMinutesAndSeconds(from date: Date) -> String{
        
        let hours = self.hours(from: date)
        let stringHours = hours > 9 ? "\(hours)" : "0\(hours)"
        
        let minutes = (self.minutes(from: date) % 60)
        let stringMinutes = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        let seconds = (self.seconds(from: date) % 60)
        let stringSeconds = seconds  > 9 ? "\(seconds)" : "0\(seconds)"
        
        let result = hours == 0 ? "\(stringMinutes) : \(stringSeconds)" : "\(stringHours) : \(stringMinutes) : \(stringSeconds)"
        
        return result
    }
}



public extension Dictionary {
    mutating func append(dictionary: [Key: Value]){
        for (k, v) in dictionary {
            updateValue(v, forKey: k)
        }
    }
}
