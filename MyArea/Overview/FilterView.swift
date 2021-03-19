//
//  FilterView.swift
//  MyArea
//
//  Created by Marlo Kessler on 21.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    @Binding var selectedCategory: Category
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        List{
            ForEach(CategoryHandler.filters, id: \.self) { category in
                Button(action: {
                    self.selectedCategory = category
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(CategoryHandler.getDescription(category: category))
                        Spacer()
                        if self.selectedCategory == category {
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .foregroundColor(Color.orange)
                                .imageScale(.large)
                        }
                    }
                }
            }
        }
    }
}


struct FilterView_PreviewsHelper {
    @State var filter: Category = .alle
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(selectedCategory: FilterView_PreviewsHelper().$filter)
    }
}
