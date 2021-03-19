//
//  Products.swift
//  MyArea
//
//  Created by Marlo Kessler on 22.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI
import Firebase

struct Products: View {
    @ObservedObject var trader: Trader
    
    @State private var editMode: EditMode = .inactive
    
    @State private var products = [Product]()
    @State private var showCreateAlert = false
    @State private var showDeleteAlert = false
    @State private var deleteIndexSet: IndexSet? = nil
    
    @State private var showHUD = false
    @State private var hudConfig = HUDConfiguration(mode: .circleActivityIndicator)
    
    var body: some View {
        NavigationView{
            List{
                if editMode == .active {
                    Button(action: {
                        self.showCreateAlert.toggle()
                    }) {
                        HStack {
                            Spacer()
                            Text("Neues Produkt")
                                .foregroundColor(.orange)
                            Spacer()
                        }
                    }
                }
                ForEach(products) { product in
                    NavigationLink(destination: TraderProductDetails(product: product, trader: self.trader)) {
                        ProductCellView(product: product)
                    }
                }.onDelete{ indexSet in
                    self.deleteIndexSet = indexSet
                    self.showDeleteAlert.toggle()
                }
            }.navigationBarTitle("Produkte")
                .navigationBarItems(trailing: Button(action: {
                    self.editMode = self.editMode == .active ? .inactive : .active
                }, label: {
                    Text(self.editMode == .active ? "Fertig" : "Bearbeiten")
                }))
                .alert(isPresented: $showDeleteAlert) {
                    Alert(title: Text("Willst Du das Produkt löschen?"), message: Text("Dies kann nicht rückgängig gemacht werden"), primaryButton: .destructive(Text("Löschen"), action: {
                        self.deleteProduct()
                    }), secondaryButton: .cancel({
                        self.deleteIndexSet = nil
                    }))
            }.hud(show: $showHUD, with: hudConfig)
        }.environment(\.editMode, $editMode)
            .actionSheet(isPresented: $showCreateAlert, content: {
                ActionSheet(title: Text("Möchtest Du ein neues Produkt hinzufügen?"), message: nil, buttons: [.default(Text("Neues Produkt hinzufügen?"), action: {
                    self.createProduct()
                }), .cancel()])
            }).onAppear{
                self.loadProducts()
        }
    }
    
    private func loadProducts() {
        Firestore.firestore()
            .collection("traders")
            .document(trader.id)
            .collection("products")
            .getDocuments { snapshot, error in
                if let s = snapshot {
                    var products = [Product]()
                    for doc in s.documents {
                        products.append(Product(id: doc.documentID, dictionary: doc.data()))
                    }
                    self.products = products
                }
        }
    }
    
    private func createProduct() {
        let newProduct = Product(traderID: trader.id, title: "New Product")
        hudConfig = HUDConfiguration(mode: .circleActivityIndicator)
        showHUD = true
        Firestore.firestore()
            .collection("traders")
            .document(trader.id)
            .collection("products")
            .document(newProduct.id)
            .setData(newProduct.asDictionary()) { error in
                if error == nil {
                    self.hudConfig = HUDConfiguration(mode: .success)
                    var products = self.products
                    products.insert(newProduct, at: 0)
                    self.products = products
                } else {
                    self.hudConfig = HUDConfiguration(mode: .failure, text: "Neues Produkt hinzufügen fehlgeschlagen.")
                }
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    self.showHUD = false
                }
        }
    }
    
    private func deleteProduct() {
        if let indexSet = deleteIndexSet, let index = indexSet.first {
            let product = products[index]
            
            hudConfig = HUDConfiguration(mode: .circleActivityIndicator)
            showHUD =  true
            
            Functions.functions(region: "europe-west3").httpsCallable("deleteProduct")
                .call(["traderID": trader.id, "productID": product.id]) { result, error in
                    if error == nil {
                        self.products.remove(at: index)
                        self.hudConfig = HUDConfiguration(mode: .success)
                    } else {
                        self.hudConfig = HUDConfiguration(mode: .failure, text: "Produkt konnte nicht gelöscht werden.")
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                        self.showHUD = false
                    }
            }
        }
    }
}

struct Products_Previews: PreviewProvider {
    static var previews: some View {
        Products(trader: Trader())
    }
}
