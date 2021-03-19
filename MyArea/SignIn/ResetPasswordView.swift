//
//  ResetPasswordView.swift
//  RemoteControllTestApp
//
//  Created by Marlo Kessler on 07.02.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI
import Firebase

struct ResetPasswordView: View {
    
    @Binding var showResetPasswordView: Bool
    @Binding var email: String
    @ObservedObject var keyboardObserver: KeyboardObserver
    
    @Binding var showHUD: Bool
    @Binding var showHUDTime: Double?
    @Binding var hudConfiguration: HUDConfiguration
    
    var body: some View {
        VStack{
            Text("Passwort zurücksetzten")
                .font(.system(size: 30))
                .fontWeight(.bold)
                .padding()
            
            HStack{
                Spacer()
                
                TextField("E-Mail", text: self.$email)
                    .frame(width: 300)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                
                
                Spacer()
            }.padding()
            
            Button(action: {
                self.sendResetEmail()
            }, label: {
                Text("Passwort zurücksetzten")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
            }).frame(width: 250)
                .background(Color.orange)
                .opacity(email.isValidEmail() ? 1 : 0.7)
                .cornerRadius(30)
                .padding()
                .shadow(radius: 5)
                .disabled(email.isValidEmail() ? false : true)
            
            if keyboardObserver.keyboardIsShown {
                Spacer()
            }
        }.onTapGesture {
            self.endEditing(force: false)
        }.animation(.default)
    }

    func sendResetEmail() {
        if email.isValidEmail() {
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                                
                if let error = error {
                    self.hudConfiguration.mode = .failure
                    self.showHUDTime = 2
                    
                    switch error.localizedDescription {
                    case "There is no user record corresponding to this identifier. The user may have been deleted.":
                        self.hudConfiguration.text = "Deine E-Mail Adresse ist nicht registriert."
                    default:
                        self.hudConfiguration.text = "Das Zurücksetzten ist fehlgeschlagen, versuche es später erneut!"
                    }
                } else {
                    self.hudConfiguration.mode = .success
                    self.hudConfiguration.text = "Wir haben Dir eine E-Mail mit eimem Link zum Zurücksetzten geschickt!"
                    self.showHUDTime = 4

                    self.showResetPasswordView.toggle()
                }
                
                self.showHUD = true
                
                if error != nil {
                    print("Password Reset ERROR: \(error!)")
                    print("")
                    print(error!.localizedDescription)
                }
            }
        }
    }
}


struct ResetPasswordView_PreviewsHelper {
    @State var showForgotPasswordView = true
    @State var email = "lol_lol@lol.com"
    @ObservedObject var keyboardObserver = KeyboardObserver()

    @State var showHUD = false
    @State var showHUDTime: Double? = nil
    @State var hudConfiguration = HUDConfiguration(mode: .success)
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(showResetPasswordView: ResetPasswordView_PreviewsHelper().$showForgotPasswordView,
                          email: ResetPasswordView_PreviewsHelper().$email,
                          keyboardObserver: ResetPasswordView_PreviewsHelper().keyboardObserver,
                          showHUD: ResetPasswordView_PreviewsHelper().$showHUD,
                          showHUDTime: ResetPasswordView_PreviewsHelper().$showHUDTime,
                          hudConfiguration: ResetPasswordView_PreviewsHelper().$hudConfiguration)
    }
}

