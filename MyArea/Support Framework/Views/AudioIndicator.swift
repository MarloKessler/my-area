//
//  AudioIndicator.swift
//  RemoteControllTestApp
//
//  Created by Marlo Kessler on 05.02.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

//import SwiftUI
//
//public struct AudioIndicator: View {
//
//    public var isPlaying: Bool {
//        get {
//            return self.isPlaying
//        }
//
//        set {
//            if newValue {
//                start()
//            } else {
//                stop()
//            }
//        }
//    }
//    public var animate: Bool = true
//    public var color: Color = .primary
//    public var background: some View = EmptyView()
//
//    @State private var heightCapsule1: CGFloat = 0
//    @State private var heightCapsule2: CGFloat = 0
//    @State private var heightCapsule3: CGFloat = 0
//
//    private var dispatchGroup = DispatchGroup()
//
//    public var body: some View {
//        HStack {
//            Capsule()
//                .foregroundColor(color)
//                .frame(height: heightCapsule1)
//                .padding(.vertical)
//
//            Capsule()
//                .foregroundColor(color)
//                .frame(height: heightCapsule2)
//                .padding(.vertical)
//
//            Capsule()
//                .foregroundColor(color)
//                .frame(height: heightCapsule3)
//                .padding(.vertical)
//
//        }.background(background)
//            .onAppear{
//                self.changeHeights()
//        }
//    }
//
//    private func changeHeights() {
//
//    }
//
//    private func start() {
//        dispatchGroup.enter()
//        DispatchQueue(label: "audioIndicatorStart").async {
//            DispatchQueue(label: "audioIndicator1").async {
//                var goUp = true
//
//                while true {
//                    sleep(1)
//
//                    if self.heightCapsule1 < 100 {
//                        self.heightCapsule1 = goUp ? self.heightCapsule1 + 1 : self.heightCapsule1 - 1
//                    } else if self.heightCapsule1 == 100 || self.heightCapsule1 == 0 {
//                        goUp.toggle()
//                    }
//                }
//            }
//
//            sleep(1)
//
//            DispatchQueue(label: "audioIndicator2").async {
//                <#code#>
//            }
//
//            sleep(1)
//
//            DispatchQueue(label: "audioIndicator3").async {
//                <#code#>
//            }
//        }
//    }
//
//    private func stop() {
//        dispatchGroup.leave()
//    }
//}
//
//struct AudioIndicator_PreviewsHelper {
//    @State var isPlaying = true
//}
//
//struct AudioIndicator_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioIndicator()
//    }
//}
