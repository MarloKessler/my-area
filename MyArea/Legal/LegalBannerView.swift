//
//  LegalView.swift
//  RemoteControllTestApp
//
//  Created by Marlo Kessler on 23.02.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI

struct LegalBannerView: View {
    
    @State private var showImprintView = false
    @State private var showPrivacyStatementView = false
    
    var body: some View {
        HStack {
            
            Text("Impressum")
                .font(.footnote)
                .foregroundColor(.gray)
                .onTapGesture {
                    self.showImprintView.toggle()
            }
                
            .sheet(isPresented: $showImprintView, content: {
                ImprintView()
            })
            
            Text(" | ")
                .font(.footnote)
                .foregroundColor(.gray)
            
            Text("Datenschutzerklärung")
                .font(.footnote)
                .foregroundColor(.gray)
                .onTapGesture {
                    self.showPrivacyStatementView.toggle()
            }
                
            .sheet(isPresented: $showPrivacyStatementView, content: {
                PrivacyStatementView()
            })
        }
    }
}

struct LegalBannerView_Previews: PreviewProvider {
    static var previews: some View {
        LegalBannerView()
    }
}
