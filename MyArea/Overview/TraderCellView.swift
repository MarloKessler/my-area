//
//  TraderCellView.swift
//  MyArea
//
//  Created by Marlo Kessler on 21.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI

struct TraderCellView: View {
    @ObservedObject var trader: Trader
    
    var body: some View {
        HStack {
            Image(uiImage: trader.thumbnail  ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .cornerRadius(25)
                .shadow(radius: 5)
            
            VStack(alignment: .leading) {
                Text(trader.name ?? "")
                .fontWeight(.bold)
                .lineLimit(1)

                HStack {
                    Text(categories)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
        }
    }
    
    private var categories: String {
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
}

struct TraderCellView_Previews: PreviewProvider {
    static var previews: some View {
        TraderCellView(trader: Trader())
    }
}
