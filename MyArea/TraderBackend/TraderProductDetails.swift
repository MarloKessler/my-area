//
//  TraderProductDetails.swift
//  MyArea
//
//  Created by Marlo Kessler on 22.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI
import YPImagePicker
import Firebase

struct TraderProductDetails: View {
    @ObservedObject var product: Product
    @ObservedObject var trader: Trader
    
    @State private var editMode: EditMode = .inactive
    
    @State private var showEndEditActionSheet = false
    @State private var showImagePicker = false
    @State private var showHUD = false
    @State private var hudConfig = HUDConfiguration(mode: .circleActivityIndicator)
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var keyboardIsShown = false
    
    @State private var title = ""
    @State private var subtitle = ""
    @State private var category: Category = .alle
    @State private var isVisible = false
    @State private var newImages = [UIImage]()
    @State private var description = NSAttributedString(string: "")
    
    var body: some View {
        GeometryReader() { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if self.editMode == .active {
                        Group {
                            HStack {
                                Text("Titel")
                                Spacer()
                            }.padding(.top)
                            TextField("Titel", text: self.$title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom)
                        }.padding(.horizontal)
                        
                        Group {
                            HStack {
                                Text("Untertitel")
                                Spacer()
                            }.padding(.top)
                            TextField("Untertitel", text: self.$subtitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom)
                        }.padding(.horizontal)
                        
                        NavigationLink(destination: FilterView(selectedCategory: self.$category)) {
                            HStack {
                                Text("Kategorie: \(CategoryHandler.getDescription(category: self.category))")
                                Spacer()
                            }.padding()
                        }
                        
                        Group {
                            Toggle(isOn: self.$isVisible) {
                                Text("Produkt ist \(self.isVisible ? "" : "nicht ")sichtbar.")
                            }.padding()
                        }
                        
                        Group {
                            self.images(width: UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? geometry.size.width - 32 : 350)
                                .onTapGesture {
                                    self.showImagePicker.toggle()
                            }
                            
                            Text("Fotos bearbeiten")
                                .foregroundColor(.orange)
                                .onTapGesture {
                                    self.showImagePicker.toggle()
                            }
                        }
                        
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
                        
                        Spacer().frame(height: self.keyboardIsShown ? self.keyboardHeight - 30 : 0)
                    } else {
                        VStack{
                            HStack {
                                Text(self.product.subtitle ?? "")
                                    .font(.headline)
                                    .lineLimit(2)
                                Spacer()
                            }.padding(.horizontal)
                                .padding(.bottom)
                            
                            HStack {
                                Text("Kategorie: \(CategoryHandler.getDescription(category: self.product.category))")
                                Spacer()
                            }.padding()
                            
                            HStack {
                                Text("Sichtbarkeit: Produkt ist \(self.product.isVisible ? "" : "nicht ")sichtbar.")
                                Spacer()
                            }.padding()
                            
                            self.images(width: UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? geometry.size.width - 32 : 350)
                            
                            HStack {
                                Text(self.product.description ?? "")
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }.padding()
                        }
                    }
                }
            }
        }.navigationBarItems(trailing: Button(action: {
            if self.editMode == .active {
                self.showEndEditActionSheet.toggle()
            } else {
                self.editMode = .active
            }
        }, label: {
            Text(self.editMode == .active ? "Fertig" : "Bearbeiten")
        })).navigationBarTitle(Text(self.editMode == .active ? "" :  self.product.title ?? ""), displayMode: self.editMode == .active ? .inline : .automatic)
            .environment(\.editMode, $editMode)
            .actionSheet(isPresented: $showEndEditActionSheet, content: {
                ActionSheet(title: Text("Willst Du deine Änderungen speichern?"), message: nil, buttons: [.destructive(Text("Speichern & Veröffentlichen"), action: {
                    self.editMode = .inactive
                    self.save()
                }), .default(Text("Nicht Speichern"), action: {
                    self.editMode = .inactive
                    self.presetValues()
                }), .cancel()])
            }).sheet(isPresented: $showImagePicker) {
                ImagePickerView(showView: self.$showImagePicker, configuration: self.imagePickerConfig) { items in
                    if let items = items {
                        var images = [UIImage]()
                        print("Items: \(items.count)")
                        for item in items {
                            switch item {
                            case .photo(let image):
                                print("Item appended")
                                images.append(image.image)
                            default:
                                break
                            }
                        }
                        
                        self.newImages = images
                    } else {print("items is nil")}
                }
        }.hud(show: $showHUD, with: hudConfig)
            .onAppear{
                self.presetValues()
                self.product.loadImages()
                
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
    
    private func images(width: CGFloat) -> some View {
        return AnyView(Group{
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    if self.newImages.isEmpty {
                        ForEach(self.product.images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: width - 32)
                                .frame(maxHeight: width/3 * 1.5)
                                .clipped()
                                .cornerRadius(20)
                                .shadow(radius: 5)
                                .padding()
                        }
                    } else {
                        ForEach(self.newImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: width - 32)
                                .frame(maxHeight: width/3 * 1.5)
                                .clipped()
                                .cornerRadius(20)
                                .shadow(radius: 5)
                                .padding()
                        }
                    }
                }
            }.frame(width: width)
                .frame(maxHeight: 500)
        })
    }
    
    private var imagePickerConfig: YPImagePickerConfiguration {
        get {
            var config = YPImagePickerConfiguration()
            config.library.maxNumberOfItems = 10
            config.onlySquareImagesFromCamera = false
            return config
        }
    }
    
    private func presetValues() {
        title = product.title ?? ""
        subtitle = product.subtitle ?? ""
        category = product.category
        description = NSAttributedString(string: product.description ?? "")
        isVisible = product.isVisible
    }
    
    @State var newImageIDs = [String]()
    @State private var savingFailedPartly = false
    private func save() {
        product.title = title
        product.subtitle = subtitle
        product.category = category
        product.description = description.string
        product.isVisible = isVisible
        if !newImages.isEmpty {
            print("newImages is not empty")
            for _ in newImages {
                newImageIDs.append(UUID().uuidString)
            }
            product.imageIDs = newImageIDs
        }
        
        self.hudConfig = HUDConfiguration(mode: .circleActivityIndicator)
        self.showHUD = true
        Firestore.firestore()
            .collection("traders")
            .document(trader.id)
            .collection("products")
            .document(product.id)
            .updateData(product.asDictionary()) { error in
                if error != nil {
                    self.savingFailedPartly = true
                }
                
                if !self.newImages.isEmpty {
                    print("newImages is not empty")
                    self.uploadImages()
                } else {
                    self.finishUpload()
                }
        }
    }
    
    private func uploadImages(index: Int = 0) {
        if let data = newImages[index].pngData() {
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            print("Image name: \(newImageIDs[index]).png")
            let p = product.storageRef.child("\(newImageIDs[index]).png")
            print("PATH: \(p)")
            product.storageRef
                .child("\(newImageIDs[index]).png")
                .putData(data, metadata: metadata) { _, error in
                    if error != nil {
                        print("uploaderror : \(error)")
                        self.savingFailedPartly = true
                    }
                    if index < self.newImages.count - 1 {
                        print("uploaded image \(index)")
                        self.uploadImages(index: index + 1)
                    } else {
                        print("last image uploaded")
                        self.finishUpload()
                    }
            }
        } else {
            print("imagedata is Nil")
            self.savingFailedPartly = true
            if index < self.newImages.count - 1 {
                self.uploadImages(index: index + 1)
            } else {
                self.finishUpload()
            }
        }
    }
    
    private func finishUpload() {
        hudConfig = savingFailedPartly ? HUDConfiguration(mode: .failure, text: "Speichern fehlgeschlagen.") : HUDConfiguration(mode: .success)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.showHUD = false
        }
        
        Functions.functions(region: "europe-west3")
            .httpsCallable("deleteOldProductImages")
            .call(["traderID": trader.id, "productID": product.id], completion: { result, error in })
    }
}

struct TraderProductDetails_Previews: PreviewProvider {
    static var previews: some View {
        TraderProductDetails(product: Product(), trader: Trader())
    }
}
