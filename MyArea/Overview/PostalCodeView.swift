//
//  PostalCodeView.swift
//  MyArea
//
//  Created by Marlo Kessler on 23.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI

struct PostalCodeView: View {
    @Binding var postalCode: String
    @State private var newPostalCode: String = ""
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            
            HStack {
                Text("Postleitzahl")
                    .foregroundColor(.gray)
                    .font(.headline)
                Spacer()
            }.padding()
            
            TextField("Postleitzahl", text: $newPostalCode, onEditingChanged: { didCange in }) {
                print("")
            }.textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.largeTitle)
                .keyboardType(.asciiCapableNumberPad)
                .textContentType(.postalCode)
                .padding()
            
            Button(action: {
                if self.postalCodeIsOkay() {
                    self.postalCode = self.newPostalCode
                }
            }) {
                Text("Auswählen")
                    .foregroundColor(.orange)
                    .padding()
            }.frame(width: 200, height: 50)
                .background(Color("lightGray"))
                .disabled(!postalCodeIsOkay())
                .opacity(postalCodeIsOkay() ? 1 : 0.8)
                .cornerRadius(50)
                .shadow(radius: postalCodeIsOkay() ? 5 : 0)
                .padding()
            
            Spacer()
        }.onTapGesture {
            self.endEditing(force: true)
        }.onAppear {
            self.newPostalCode = self.postalCode
        }
    }
    
    private func postalCodeIsOkay() -> Bool {
        return true
    }
}


struct PostalCodeView_PreviewsHelper {
    @State var postalCode = "66851"
}

struct PostalCodeView_Previews: PreviewProvider {
    static var previews: some View {
        PostalCodeView(postalCode: PostalCodeView_PreviewsHelper().$postalCode)
    }
}
