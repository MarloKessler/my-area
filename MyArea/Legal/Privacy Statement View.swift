//
//  Privacy Statement.swift
//  RemoteControllTestApp
//
//  Created by Marlo Kessler on 23.02.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI
import Firebase

struct PrivacyStatementView: View {
    
    @State var privacyStatement: String? = nil
    
    var body: some View {
        Group {
            if privacyStatement == nil {
                ActivityIndicator(style: .large)
            } else {
                VStack  {
                    Text(privacyStatement!)
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
                        self.privacyStatement = data["privacyStatement"] as? String
                    }
                }
        }
    }
}

struct PrivacyStatementView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyStatementView()
    }
}
