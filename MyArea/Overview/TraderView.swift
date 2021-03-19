//
//  TraderView.swift
//  MyArea
//
//  Created by Marlo Kessler on 21.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI
import Firebase

struct TraderView: View {
    @ObservedObject var trader: Trader
    @State private var products = [Product]()
    @State private var showMore = false
    
    var body: some View {
        GeometryReader() { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
                        if self.trader.image != nil || self.trader.thumbnail != nil {
                            Image(uiImage: self.trader.image ?? self.trader.thumbnail ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(20)
                                .shadow(radius: 5)
                                .frame(width: geometry.size.width - 32)
                                .frame(maxHeight: geometry.size.width * 1.5)
                                .edgesIgnoringSafeArea(.top)
                                .padding()
                        }
                        
                        self.contactView.padding()
                    } else {
                        HStack {
                            Image(uiImage: self.trader.image ?? self.trader.thumbnail ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(20)
                                .shadow(radius: 5)
                                .frame(width: geometry.size.width/3 - 32)
                                .frame(maxHeight: geometry.size.width/3 * 1.5)
                                .padding()
                            
                            VStack(alignment: .leading) {
                                Text(self.trader.name ?? "")
                                    .font(.title)
                                self.contactView
                            }
                        }.padding()
                    }
                    
                    self.traderDesc
                        .padding()
                    
                    HStack {
                        Text("Produkte:")
                            .font(.headline)
                        Spacer()
                    }.padding(.horizontal)
                    if self.products.isEmpty {
                        Text("Es sind keine Produkte vorhanden.")
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .padding()
                    } else {
                        Divider()
                        ForEach(self.products) { product in
                            if product.isVisible {
                                NavigationLink(destination: ProductView(product: product, trader: self.trader)) {
                                    VStack {
                                        ProductCellView(product: product)
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }.onAppear {
            self.loadProducts()
            self.trader.loadImage()
        }.navigationBarTitle(trader.name == nil ? "" : trader.name ?? "")
    }
    
    private var contactView: some View {
        VStack(alignment: .leading) {
            
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
        }
    }
    
    private var traderDesc: some View {
        VStack {
            HStack {
                Text(self.trader.description ?? "")
                .lineLimit(self.showMore ? nil : 3)
                .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    self.showMore.toggle()
                }) {
                    Text(self.showMore ? "Weniger" : "Mehr")
                }
            }
        }
    }
    
    private func loadProducts() {
        Firestore.firestore()
            .collection("traders")
            .document(trader.id)
            .collection("products")
            .getDocuments { snapshot, error in
                if error == nil {
                    if let s = snapshot {
                        var products = [Product]()
                        for doc in s.documents {
                            products.append(Product(id: doc.documentID, dictionary: doc.data()))
                        }
                        self.products.removeAll()
                        self.products = products
                    }
                }
        }
    }
}

struct TraderView_Previews: PreviewProvider {
    static var previews: some View {
        TraderView(trader: Trader())
    }
}
