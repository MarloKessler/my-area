//
//  ControlView.swift
//  MyArea
//
//  Created by Marlo Kessler on 22.03.20.
//  Copyright © 2020 Marlo Kessler. All rights reserved.
//

import SwiftUI

struct ControlView: View {
    @ObservedObject var environmentContainer: EnvironmentContainer
    
    var body: some View {
        ZStack {
            if environmentContainer.showTraderBackend && environmentContainer.traderID != nil {
                TraderBackend().environmentObject(environmentContainer)
            } else if environmentContainer.showTraderBackend && environmentContainer.traderID == nil {
                SignInView().environmentObject(environmentContainer)
            } else {
                OverView().environmentObject(environmentContainer)
            }
        }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(environmentContainer: EnvironmentContainer())
    }
}
