//
//  EnvironmentContainer.swift
//  MyArea
//
//  Created by Marlo Kessler on 22.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI

class EnvironmentContainer: ObservableObject {
    @Published var showTraderBackend = false
    @Published var traderID: String? = nil
}
