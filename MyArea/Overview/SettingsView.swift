//
//  SettingsView.swift
//  MyArea
//
//  Created by Marlo Kessler on 22.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var environmentContainer: EnvironmentContainer
    
    var body: some View {
        VStack {
            List {
                NavigationLink(destination: ImprintView()) {
                    Text("Impressum")
                }
                NavigationLink(destination: PrivacyStatementView()) {
                    Text("Datenschutzerklärung")
                }
            }
            
            Button(action: {
                self.environmentContainer.showTraderBackend = true
            }) {
                Text("Händler-Bereich")
            }.padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
