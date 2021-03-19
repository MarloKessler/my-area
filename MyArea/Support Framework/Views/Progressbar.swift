//
//  Progressbar.swift
//  SupportFiles
//
//  Created by Marlo Kessler on 09.02.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//
//
import SwiftUI

public struct Progressbar: View {
    @Binding public var progress: Double
    
    private var orientation: Orientation
    private var length: CGFloat = 5
    
    private var primaryColor: Color = .blue
    private var secondaryColor: Color = .gray
    
    @State private var width: CGFloat = 0
    
    public func foregroundColor(_ color: Color?) -> Progressbar {
        return Progressbar(progress: _progress, orientation: orientation, length: length, secondaryColor: secondaryColor, primaryColor: color ?? .primary)
    }
    
    public func backgroundColor(_ color: Color?) -> Progressbar {
        return Progressbar(progress: _progress, orientation: orientation, length: length, secondaryColor: color ?? .gray, primaryColor: primaryColor)
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .foregroundColor(secondaryColor)
                .background(GeometryReader { geometry in
                    Rectangle().fill(Color.clear)
                        .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
                })
            
            Capsule()
                .foregroundColor(primaryColor)
                .frame(width: CGFloat(progress) * width)

            
        }.onPreferenceChange(WidthPreferenceKey.self, perform: { width in
            self.width = width
        }).frame(height: length)
    }
    
    public init(progress: Binding<Double>, orientation: Progressbar.Orientation = .horizontal, length: CGFloat = 5) {
        self._progress = progress
        self.orientation = orientation
        self.length = length
    }
    
    private init(progress: Binding<Double>, orientation: Progressbar.Orientation = .horizontal, length: CGFloat = 5, secondaryColor: Color = .gray, primaryColor: Color = .primary) {
        self._progress = progress
        self.orientation = orientation
        self.length = length
        self.secondaryColor = secondaryColor
        self.primaryColor = primaryColor
    }
    
    fileprivate struct WidthPreferenceKey: PreferenceKey {
        public static var defaultValue: CGFloat = 0

        public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }

        public typealias Value = CGFloat
    }
    
    public enum Orientation {
        case horizontal
        case vertical
    }
}


struct Progressbar_PreviewsHelper {
    @State var progress: Double = 0.6
}

struct Progressbar_Previews: PreviewProvider {
    static var previews: some View {
        Progressbar(progress: Progressbar_PreviewsHelper().$progress)
    }
}
