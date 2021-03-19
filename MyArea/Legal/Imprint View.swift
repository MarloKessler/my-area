//
//  Legal Statement View.swift
//  RemoteControllTestApp
//
//  Created by Marlo Kessler on 22.02.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI
import Firebase

struct ImprintView: View {
    
    @State var imprint: String? = nil
    
    var body: some View {
        Group {
            if imprint == nil {
                ActivityIndicator(style: .large)
            } else {
                VStack  {
                    Text(imprint!)
                    Spacer()
                }.padding()
                
            }
        }.onAppear {
            self.loadLegalStatement()
        }
    }
    
    private func loadLegalStatement() {
        Firestore.firestore()
            .collection("projectSettings")
            .document("legalInformation")
            .getDocument { (snapshot, error) in
                if error == nil {
                    if let snapshot = snapshot, let data = snapshot.data() {
                        self.imprint = data["imprint"] as? String
                    }
                }
        }
    }
}

struct ImprintView_Previews: PreviewProvider {
    static var previews: some View {
        ImprintView()
    }
}
