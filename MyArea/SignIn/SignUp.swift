//
//  SignUp.swift
//  MyArea
//
//  Created by Marlo Kessler on 21.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI
import Firebase

struct SignUp: View {
    
    @ObservedObject var keyboardObserver = KeyboardObserver()
    @State private var showResetPasswordView = false
    @State private var email = ""
    @State private var password = ""
    @State private var repeatPassword = ""
    
    @State private var showHUD = false
    @State private var hudConfiguration = HUDConfiguration(mode: .success)
    @State private var showHUDTime: Double?
    
    var body: some View {
        VStack{
            Text("Händler Registrierung")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .padding()
            
            Spacer()
            
            HStack{
                Spacer()
                
                TextField("E-Mail", text: $email)
                    .frame(width: 300)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                
                Spacer()
            }
            
            HStack{
                Spacer()
                
                VStack {
                    SecureField("Passwort", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.newPassword)
                    .autocapitalization(.none)
                    
                    if password.count > 0 && password.count < 8 {
                        Text("Noch \(8-password.count) Zeichen.")
                            .foregroundColor(Color.red)
                            .font(.footnote)
                    }
                    
                    SecureField("Passwort wiederholen", text: $repeatPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.newPassword)
                        .autocapitalization(.none)
                    
                    if repeatPassword.count > 0 && password != repeatPassword {
                        Text("Die Passwörter stimmen nicht überein.")
                            .foregroundColor(Color.red)
                            .font(.footnote)
                    }
                }.frame(width: 300)
                
                Spacer()
            }
            
            Spacer()
            
            Button(action: {
                self.signUp()
            }, label: {
                Text("Registrieren")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                
            }).frame(width: 250)
                .background(Color.orange)
                .opacity(isValid() ? 1 : 0.7)
                .cornerRadius(50)
                .padding()
                .shadow(radius: isValid() ? 5 : 0)
                .disabled(isValid() ? false : true)
            
            Spacer()
            
            LegalBannerView()
                .padding()
        }.onAppear(perform: {
            self.keyboardObserver.addObserver()
        }).onDisappear(perform: {
            self.keyboardObserver.removeObserver()
        }).onTapGesture {
            self.endEditing(force: false)
        }.partialSheet(presented: $showResetPasswordView) {
            ResetPasswordView(showResetPasswordView: self.$showResetPasswordView, email: self.$email, keyboardObserver: self.keyboardObserver, showHUD: self.$showHUD, showHUDTime: self.$showHUDTime, hudConfiguration: self.$hudConfiguration)
        }.animation(.default)
        .hud(show: $showHUD, for: showHUDTime, with: hudConfiguration)
    }
    
    private func signUp() {
//        if isValid() {
//            Auth.auth().createUser(withEmail: email, password: password) { result, error in
//                <#code#>
//            }
//        }
    }
    
    private func isValid() -> Bool {
        return email.isValidEmail() && password.count > 8 && repeatPassword == password ? true : false
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
