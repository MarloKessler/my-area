//
//  ProductView.swift
//  MyArea
//
//  Created by Marlo Kessler on 21.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI

struct ProductView: View {
    @ObservedObject var product: Product
    @ObservedObject var trader: Trader
    
    var body: some View {
        GeometryReader() { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    HStack {
                        Text(self.product.subtitle ?? "")
                            .font(.headline)
                            .lineLimit(2)
                        Spacer()
                    }.padding(.horizontal)

                    self.images(width: UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? geometry.size.width - 32 : 350)
                        .padding()

                    self.contactView(axis: UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? .vertical : .horizontal)
                        .padding()
                    
                    HStack {
                        Text(self.product.description ?? "")
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        Spacer()
                    }.padding()

//                    Text("Gefällt Ihnen was Sie sehen? Kontaktieren Sie uns jetzt!")
//                        .font(.headline)
//                        .fontWeight(.bold)
//                        .multilineTextAlignment(.center)
//                        .padding()
                    
                    self.contactView(axis: .vertical).padding()
                }.padding()
            }.navigationBarTitle(self.product.title == nil ? "" : self.product.title ?? "")
        }.onAppear{
            self.product.loadImages()
        }
    }
    
    private func images(width: CGFloat) -> some View {
        return AnyView(
            Group {
                if !self.product.images.isEmpty || !self.product.thumbnails.isEmpty {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(self.product.images, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .cornerRadius(20)
                                    .shadow(radius: 5)
                                    .frame(width: width - 12)
                                    .frame(maxHeight: width/3 * 1.5)
                                    .padding()
                            }
                        }
                    }.frame(width: width)
                        .frame(maxHeight: 500)
                } else {
                    EmptyView()
                }
        })
    }
    
    private func contactView(axis: Axis) -> some View {
        let content = AnyView(Group{
            if self.trader.showPhoneNumber {
                HStack {
                    Text("Telefon: ")
                    TextView(self.trader.phoneNumber ?? "")
                }
            }
            if self.trader.showEmail {
                HStack {
                    Text("E-Mail: ")
                    TextView(self.trader.email ?? "")
                }
            }
            if self.trader.showAddress {
                HStack {
                    Text("Adresse: ")
                    TextView(self.trader.address ?? "")
                }
            }
        })
        
        if axis == .horizontal {
            return AnyView(Group {
                HStack {
                    content
                }
            })
        } else {
            return AnyView(Group {
                VStack(alignment: .leading) {
                    content
                }
            })
        }
    }
}


struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(product: Product(), trader: Trader())
    }
}
