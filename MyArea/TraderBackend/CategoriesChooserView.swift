//
//  CategoriesChooserView.swift
//  MyArea
//
//  Created by Marlo Kessler on 22.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI

struct CategoriesChooserView: View {
    @Binding var selectedCategories: [Category]
    @State private var categories = [Category: Bool]()
    @State private var resfreshView = false
    
    var body: some View {
        List{
            ForEach(CategoryHandler.filters, id: \.self) { category in
                Button(action: {
                    self.categories[category] = !(self.categories[category] ?? true)
                    self.updateSelectedCategories()
                }) {
                    HStack {
                        Text(CategoryHandler.getDescription(category: category))
                        
                        if self.categories[category] ?? false {
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .foregroundColor(Color.orange)
                                .imageScale(.large)
                        }
                    }
                }
            }
            Text(self.resfreshView ? "" : "")
        }.navigationBarTitle("Kategorien")
            .onAppear{
                self.setUpValues()
        }
    }
    
    private func setUpValues() {
        var categories = [Category: Bool]()
        for category in CategoryHandler.filters {
            categories[category] = selectedCategories.contains(category)
            print("Contains \(category.rawValue): \(selectedCategories.contains(category))")
        }
        self.categories = categories
        self.resfreshView.toggle()
    }
    
    private func updateSelectedCategories() {
        var selectedCategories = [Category]()
        for category in categories.keys {
            if categories[category] ?? false {
                selectedCategories.append(category)
            }
        }
        self.selectedCategories = selectedCategories
    }
}


struct CategoriesChooserView_PreviewsHelper {
    @State var cats: [Category] = [.alle]
}

struct CategoriesChooserView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesChooserView(selectedCategories: CategoriesChooserView_PreviewsHelper().$cats)
    }
}
