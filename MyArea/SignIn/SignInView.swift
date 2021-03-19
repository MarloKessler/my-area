//
//  SignIn.swift
//  RemoteControllTestApp
//
//  Created by Marlo Kessler on 07.02.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    @EnvironmentObject var environmentContainer: EnvironmentContainer
    
    @ObservedObject var keyboardObserver = KeyboardObserver()
    @State private var showResetPasswordView = false
    @State private var email = ""
    @State private var password = ""
    
    @State private var showHUD = false
    @State private var hudConfiguration = HUDConfiguration(mode: .success)
    @State private var showHUDTime: Double?
        
    var body: some View {
        VStack{
            HStack{
                Spacer()
                
                Text("Schließen")
                .padding()
                    .foregroundColor(.orange)
                    .onTapGesture {
                        self.environmentContainer.showTraderBackend = false
                }
            }
            
            Text("Händler-Bereich")
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
                
                SecureField("Passwort", text: $password)
                    .frame(width: 300)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.password)
                    .autocapitalization(.none)
                
                Spacer()
            }
            
            Spacer()
            
            Button(action: {
                self.signIn()
            }, label: {
                Text("Einloggen")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                
            }).frame(width: 250)
                .background(Color.orange)
                .opacity(email.isValidEmail() && password != "" ? 1 : 0.7)
                .cornerRadius(50)
                .padding()
                .shadow(radius: email.isValidEmail() && password != "" ? 5 : 0)
                .disabled(email.isValidEmail() && password != "" ? false : true)
            
            Button(action: {
                self.showResetPasswordView.toggle()
            }, label: {
                Text("Passwort vergessen")
                    .foregroundColor(.primary)
                    .padding()
            })
            
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
    
    private func signIn() {
        if email.isValidEmail() && password != "" {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    self.hudConfiguration.mode = .failure
                    
                    switch error.localizedDescription {
                    case "There is no user record corresponding to this identifier. The user may have been deleted.":
                        self.hudConfiguration.text = "Deine E-Mail Adresse ist nicht registriert."
                    case "The password is invalid or the user does not have a password.":
                        self.hudConfiguration.text = "Dein Passwort ist falsch."
                    default:
                        self.hudConfiguration.text = "Einloggen fehlgeschlaggen, versuche es später erneut!"
                    }
                    
                    self.showHUDTime = 2
                    self.showHUD = true
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
