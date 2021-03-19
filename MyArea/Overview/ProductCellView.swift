//
//  ProductCellView.swift
//  MyArea
//
//  Created by Marlo Kessler on 21.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI

struct ProductCellView: View {
    @ObservedObject var product: Product
    
    var body: some View {
        HStack {
            Image(uiImage: product.thumbnails.count > 0 ? product.thumbnails[0] : UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .cornerRadius(25)
                .shadow(radius: 5)
            
            VStack(alignment: .leading) {
                if product.title != nil {
                    Text(product.title ?? "")
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                        .lineLimit(product.subtitle == nil ? 2 : 1)
                }

                if product.subtitle != nil {
                    Text(product.isVisible ? product.subtitle ?? "" : "Nicht sichtbar")
                        .foregroundColor(product.isVisible ? .primary : .red)
                        .lineLimit(product.title == nil ? 2 : 1)
                }
            }
        }
    }
}

struct ProductCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCellView(product: Product())
    }
}
