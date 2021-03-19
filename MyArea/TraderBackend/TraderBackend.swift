//
//  TraderBackend.swift
//  MyArea
//
//  Created by Marlo Kessler on 22.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI
import Firebase

struct TraderBackend: View {
    @EnvironmentObject var environmentContainer: EnvironmentContainer
    @State private var trader: Trader? = nil
    
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            if trader != nil {
                Text("").onAppear{
                    self.environmentContainer.showTraderBackend = false
                }.tabItem {
                    Image(systemName: "arrow.left")
                        .imageScale(.large)
                }.tag(0)
                
                Products(trader: trader!).tabItem {
                    Image(systemName: "rectangle.3.offgrid")
                        .imageScale(.large)
                }.tag(1)
                
                Profile(trader: trader!).tabItem {
                    Image(systemName: "person")
                        .imageScale(.large)
                }.tag(2)
            } else {
                VStack {
                    ActivityIndicator(style: .medium).padding()
                    Button(action: {
                        self.environmentContainer.showTraderBackend = false
                    }) {
                        Text("Zurück")
                    }
                }
            }
        }.onAppear {
            self.loadTrader()
        }.accentColor(.orange)
    }
    
    private func loadTrader() {
        if let traderID = environmentContainer.traderID {
            Firestore.firestore()
                .collection("traders")
                .document(traderID)
                .getDocument { snapshot, error in
                    if let s = snapshot, let data = s.data() {
                        self.trader = Trader(id: s.documentID, dictionary: data)
                        print("Trader loaded.")
                    }
            }
        }
    }
}

struct TraderBackend_Previews: PreviewProvider {
    static var previews: some View {
        TraderBackend()
    }
}
