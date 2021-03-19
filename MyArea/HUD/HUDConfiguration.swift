//
//  HUDConfiguration.swift
//  ViewConverter
//
//  Created by Marlo Kessler on 18.12.19.
//  Copyright © 2019 Marlo Kessler. All rights reserved.
//

import SwiftUI
import LHProgressHUD

struct HUDConfiguration {
    ///The HUD's mode
    var mode: HUDMode
    var isAnimated = true
    
    ///The blur effect setd the whole screen to blur.
    var blur: LHBlurEffectStyle = .none
    
    ///Shows the progress in a linesActivityIndicator
    var progress: CGFloat = 0
    
    ///The color of the i in the info HUD.
    var infoIColor = UIColor.white
    var spinnerColor = UIColor.white
    
    ///The view's background color.
    var backgroundColor: UIColor?
    
    ///The text shown in the HUD.
    var text: String?
    ///The color of the text.
    var textColor = UIColor.white
    ///The background color of the TextLabel the text is shown in.
    var textLabelBackgroundcolor = UIColor.clear
}
