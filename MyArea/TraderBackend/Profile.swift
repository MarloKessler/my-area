//
//  Profile.swift
//  MyArea
//
//  Created by Marlo Kessler on 22.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI
import Firebase

struct Profile: View {
    @ObservedObject var trader: Trader
    
    @State private var editMode: EditMode = .inactive
    @State private var showEndEditActionSheet = false
    @State private var showImagePicker = false
    @State private var showHUD = false
    @State private var hudConfig = HUDConfiguration(mode: .circleActivityIndicator)
    @State private var showDeleteProfileAlert = false
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var keyboardIsShown = false
    
    @State private var name = ""
    @State private var newImage: UIImage? = nil
    @State private var categories = [Category]()
    @State private var phoneNumber = ""
    @State private var showPhoneNumber = false
    @State private var email = ""
    @State private var showEmail = false
    @State private var address = ""
    @State private var showAddress = false
    @State private var description = NSAttributedString(string: "")
    @State private var postalCode = ""
    @State private var postalCodeIsOkay = true
        
    var body: some View {
        NavigationView {
            GeometryReader() { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        if self.editMode == .active {
                            Group {
                                HStack {
                                    Text("Name")
                                    Spacer()
                                }.padding(.top)
                                TextField("Name", text: self.$name)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }.padding(.horizontal)
                            
                            NavigationLink(destination: CategoriesChooserView(selectedCategories: self.$categories)) {
                                HStack {
                                    Text("Kategorien: \(self.categoryString)")
                                    Spacer()
                                }
                            }.padding()
                            
                            Group {
                                self.traderImage(size: geometry.size)
                                    .padding()
                                    .onTapGesture {
                                        self.showImagePicker.toggle()
                                }
                                
                                Text("Foto bearbeiten")
                                    .font(.footnote)
                                    .foregroundColor(.orange)
                                    .padding()
                                    .onTapGesture {
                                        self.showImagePicker.toggle()
                                }
                            }
                            
                            Group {
                                HStack {
                                    Text("Telefon")
                                    Spacer()
                                }.padding(.top)
                                TextField("Telefon", text: self.$phoneNumber)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Toggle(isOn: self.$showPhoneNumber) {
                                    Text("Telefonnummer anzeigen")
                                }.padding(.bottom)
                            }.padding(.horizontal)
                            
                            Group {
                                HStack {
                                    Text("E-Mail Adresse")
                                    Spacer()
                                }
                                TextField("E-Mail Adresse", text: self.$email)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Toggle(isOn: self.$showEmail) {
                                    Text("E-Mail Adresse anzeigen")
                                }.padding(.bottom)
                            }.padding(.horizontal)
                            
                            Group {
                                HStack {
                                    Text("Adresse")
                                    Spacer()
                                }
                                TextField("Adresse", text: self.$address)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Toggle(isOn: self.$showAddress) {
                                    Text("Adresse anzeigen")
                                }.padding(.bottom)
                            }.padding(.horizontal)
                            
                            Group {
                                HStack {
                                    Text("Postleitzahlengebiet")
                                    Spacer()
                                }
                                TextField("Postleitzahl", text: self.$postalCode, onEditingChanged: {didChange in }) {
                                    self.postalCode = self.postalCode.trimmingCharacters(in: .whitespaces)
                                    self.postalCodeIsOkay = Int(self.postalCode) == nil ? false : true
                                    print("ON COMMIT POSTAL CODE")
                                }.textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(self.postalCodeIsOkay ? .primary : .red)
                                    .padding(.bottom)
                            }.padding(.horizontal)
                            
                            Group {
                                HStack {
                                    Text("Beschreibung")
                                    Spacer()
                                }.padding(.top)
                                TextFieldView(attributedText: self.$description)
                                    .placeholder("Beschreibung")
                                    .style(.roundedBorders())
                                    .frame(width: geometry.size.width - 32, height: 300)
                                    .padding(.bottom)
                            }.padding(.horizontal)
                            
                            Button(action: {
                                self.showDeleteProfileAlert.toggle()
                            }) {
                                Text("Profil löschen")
                                    .foregroundColor(.red)
                            }.padding()
                            
                            Spacer().frame(height: self.keyboardIsShown ? self.keyboardHeight - 30 : 0)
                            
                        } else {
                            HStack {
                                Text(self.trader.name ?? "")
                                    .font(.headline)
                                Spacer()
                            }.padding()
                            
                            HStack {
                                Text("Kategorien: \(self.categoryString)")
                                    .lineLimit(1)
                                Spacer()
                            }.padding()
                            
                            
                            if self.trader.image == nil && self.trader.thumbnail == nil {
                                Text("Kein Foto ausgewählt.")
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                                    .padding()
                            } else {
                                Group  {
                                    self.traderImage(size: geometry.size)
                                        .padding()
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Telefon: \(self.trader.phoneNumber ?? "")")
                                    Spacer()
                                }.padding(.bottom)
                                
                                HStack {
                                    Text("E-Mail: \(self.trader.email ??  "")")
                                    Spacer()
                                }.padding(.bottom)
                                
                                HStack {
                                    Text("Adresse: \(self.trader.address ?? "")")
                                    Spacer()
                                }.padding(.bottom)
                                HStack {
                                    Text("Postleitzahlengebiet: \(self.trader.postalCode ??  "")")
                                    Spacer()
                                }.padding(.bottom)
                                
                                HStack {
                                    Text("Beschreibung:")
                                    Spacer()
                                }
                                
                                HStack {
                                    Text(self.trader.description ?? "")
                                        .fixedSize(horizontal: false, vertical: true)
                                    Spacer()
                                }.padding(.bottom)
                            }.padding()
                        }
                    }
                }.frame(width: geometry.size.width)
            }.navigationBarTitle("Profil")
                .navigationBarItems(trailing: Button(action: {
                    if self.editMode == .active {
                        self.showEndEditActionSheet.toggle()
                    } else {
                        self.editMode = .active
                    }
                }, label: {
                    Text(self.editMode == .active ? "Fertig" : "Bearbeiten")
                })).environment(\.editMode, $editMode)
                    .actionSheet(isPresented: $showEndEditActionSheet, content: {
                        ActionSheet(title: Text("Willst Du deine Änderungen speichern?"), message: nil, buttons: [.destructive(Text("Speichern & Veröffentlichen"), action: {
                            self.editMode = .inactive
                            self.save()
                        }), .default(Text("Nicht Speichern"), action: {
                            self.editMode = .inactive
                            self.presetValues()
                        }), .cancel()])
                    })
        }.sheet(isPresented: $showImagePicker) {
            ImagePickerView(showPhotoView: self.$showImagePicker, selectedImage: self.$newImage)
        }.alert(isPresented: $showDeleteProfileAlert, content: {
            Alert(title: Text("Bitte kontaktiere uns, wir löschen dann dein Profil."))
        }).hud(show: $showHUD, with: hudConfig)
            .onAppear{
                self.trader.loadImage()
                self.presetValues()
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    self.keyboardHeight = value.height
                    self.keyboardIsShown = true
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    self.keyboardHeight = 0
                    self.keyboardIsShown = false
                }
        }
        
    }
    
    private func traderImage(size: CGSize) -> some View {
        print("WIDTH: \(size.width)")
        if let image = newImage ?? trader.image ?? trader.thumbnail {
            return AnyView(
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width - 32)
                    .frame(maxHeight: size.width * 1.5)
                    .clipped()
                    .cornerRadius(20)
                    .shadow(radius: 5)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    private var categoryString: String {
        get {
            if trader.categories.isEmpty {
                return CategoryHandler.getDescription(category: .andere)
            } else {
                var cats = ""
                
                var counter = 0
                for cat in trader.categories {
                    cats = cats + "\(CategoryHandler.getDescription(category: cat))\(counter < trader.categories.count - 1 ? ", " : "")"
                    counter += 1
                }
                
                return cats
            }
        }
    }
    
    private func presetValues() {
        name = trader.name ?? ""
        categories = trader.categories
        phoneNumber = trader.phoneNumber ?? ""
        showPhoneNumber = trader.showPhoneNumber
        email = trader.email ?? ""
        showEmail = trader.showEmail
        address = trader.address ?? ""
        showAddress = trader.showAddress
        description = NSAttributedString(string: trader.description ?? "")
        postalCode = trader.postalCode ?? ""
        self.newImage = nil
    }
    
    private func save() {
        hudConfig = HUDConfiguration(mode: .circleActivityIndicator)
        showHUD = true
        
        trader.name = name
        trader.description = description.string
        trader.categories = categories
        
        trader.email = email
        trader.showEmail = showEmail
        trader.phoneNumber = phoneNumber
        trader.showPhoneNumber = showPhoneNumber
        trader.address = address
        trader.showAddress = showAddress
        if Int(self.postalCode) != nil {
            trader.postalCode = postalCode
        }
        
        Firestore.firestore()
            .collection("traders")
            .document(trader.id)
            .updateData(trader.asDictionary()) { error in
                
                if error == nil {
                    self.hudConfig = HUDConfiguration(mode: .success)
                } else {
                    self.hudConfig = HUDConfiguration(mode: .failure, text: "Speichern fehlgeschlagen.")
                }
                
                if self.newImage == nil {
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                        self.showHUD = false
                    }
                } else {
                    self.updateImage()
                }
        }
    }
    
    private func updateImage() {
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        if let data = newImage?.pngData() {
            Storage.storage().reference()
                .child("traders")
                .child(trader.id)
                .child("profileImage.png")
                .putData(data, metadata: metadata) { _, error in
                    if error == nil {
                        self.trader.image = self.newImage
                        self.hudConfig = HUDConfiguration(mode: .success)
                    } else {
                        self.hudConfig = HUDConfiguration(mode: .failure, text: "Speichern fehlgeschlagen.")
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                        self.showHUD = false
                    }
            }
        } else {
            self.hudConfig = HUDConfiguration(mode: .failure, text: "Speichern fehlgeschlagen.")
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                self.showHUD = false
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(trader: Trader())
    }
}
