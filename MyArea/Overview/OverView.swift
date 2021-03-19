//
//  ContentView.swift
//  MyArea
//
//  Created by Marlo Kessler on 21.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI
import Firebase

struct OverView: View {
    
    @State var traders = [Trader]()
    @State private var searchText = ""
    
    @State private var showFilterView = false
    @State private var filter: Category = .alle
    
    @State private var error = false
    @State private var postalCode = "66851"
    @State private var showPostalCodeView = false
        
    var body: some View {
        NavigationView {
            GeometryReader() { geometry in
                if self.error {
                    VStack {
                        Text("Ein Fehler ist aufgetreten!")
                        
                        Button(action: {
                            self.loadTraders()
                        }) {
                            Text("Nochmal versuchen")
                                .foregroundColor(.white)
                        }.background(Color.orange)
                            .frame(width: 100, height: 50)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                } else {
                    List {
                        SearchBar(text: self.$searchText, placeholder: "Suchen")
                        HStack {
                            HStack {
                                Spacer()
                                Text("Area: \(self.postalCode)")
                                    .foregroundColor(.orange)
                                    .onTapGesture {
                                        self.showPostalCodeView.toggle()
                                }
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                if self.filter == .alle {
                                    Image(systemName: "line.horizontal.3.decrease.circle")
                                        .renderingMode(.template)
                                        .foregroundColor(.orange)
                                        .imageScale(.large)
                                } else {
                                    Text("\(CategoryHandler.getDescription(category: self.filter))")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.orange)
                                        .padding(.trailing)
                                }
                                Spacer()
                            }.onTapGesture {
                                self.showFilterView.toggle()
                            }
                        }
                        
                        if self.traders.isEmpty {
                            HStack {
                                Spacer()
                                ActivityIndicator(style: .medium)
                                Spacer()
                            }.padding()
                        } else {
                            ForEach(self.traders) { trader in
                                NavigationLink(destination: TraderView(trader: trader)) {
                                    TraderCellView(trader: trader)
                                }
                            }
                        }
                    }
                }
            }.navigationBarTitle("MyArea")
                .navigationBarItems(trailing: NavigationLink(destination: SettingsView(), label: {
                    Image(systemName: "ellipsis")
                        .renderingMode(.template)
                        .foregroundColor(.orange)
                        .imageScale(.large)
                })).sheet(isPresented: self.$showPostalCodeView, content: {
                    PostalCodeView(postalCode: self.$postalCode)
                })
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
            .onAppear{
                self.loadTraders()
        }.sheet(isPresented: $showFilterView, content: {
            FilterView(selectedCategory: self.$filter)
        }).accentColor(.orange)
    }
    
    private func loadTraders() {
        Firestore.firestore()
            .collection("traders")
            .order(by: Trader.Keys.name.rawValue)
            .getDocuments { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot {
                        self.error = false
                        var traders = [Trader]()
                        for doc in snapshot.documents {
                            traders.append(Trader(id: doc.documentID, dictionary: doc.data()))
                        }
                        self.traders = traders
                    }
                } else {
                    self.error = true
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OverView()
    }
}
