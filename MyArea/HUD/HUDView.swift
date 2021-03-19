//
//  LHProgressHUDView.swift
//  Sportbeats
//
//  Created by Marlo Kessler on 17.12.19.
//  Copyright © 2019 Marlo Kessler. All rights reserved.
//

import SwiftUI
import LHProgressHUD

fileprivate struct HUD: UIViewControllerRepresentable {
    
    private var configuration: HUDConfiguration
    
    init(configuration: HUDConfiguration) {
        self.configuration = configuration
    }
    
    init(mode: HUDMode) {
        self.init(configuration: HUDConfiguration(mode: mode))
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<HUD>) -> UIViewController {
        
        let viewController = UIViewController()
        
        let hud = getHud(view: viewController.view, with: configuration)
        
        viewController.view = hud
        
        return viewController
    }
    
        
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<HUD>) {
        uiViewController.view = getHud(view: uiViewController.view, with: configuration)
    }
    
    
    private func getHud(view: UIView, with configuration: HUDConfiguration) -> LHProgressHUD {
        
        let hud: LHProgressHUD
        
        switch configuration.mode {
        case .circleActivityIndicator:
            hud = LHProgressHUD.showAdded(to: view)
            
        case .linesActivityIndicator:
            hud = LHProgressHUD.showAdded(to: view)
            hud.mode = LHProgressHUDMode.LHProgressHUDModeProgress
            hud.progress = configuration.progress
            
        case .progressIndicator:
            hud = LHProgressHUD.showAdded(to: view)
            hud.mode = LHProgressHUDMode.LHProgressHUDModeActivityIdenticator
            
        case .info:
            hud = LHProgressHUD.showInfoAdded(to: view, animated: configuration.isAnimated)
            
        case .success:
            hud = LHProgressHUD.showSuccessAdded(to: view, animated: configuration.isAnimated)
            
        case .failure:
            hud = LHProgressHUD.showFailureAdded(to: view, animated: configuration.isAnimated)
            
        case .textOnly:
            hud = LHProgressHUD.showAdded(to: view)
            hud.mode = LHProgressHUDMode.LHProgressHUDModeTextOnly
        }
        
        hud.backgroundView.blurStyle = configuration.blur
        hud.progress = configuration.progress
        
        hud.infoColor = configuration.infoIColor
        hud.spinnerColor = configuration.spinnerColor
        hud.backgroundColor = configuration.backgroundColor
        
        hud.textLabel.text = configuration.text
        hud.textLabel.textColor = configuration.textColor
        hud.textLabel.backgroundColor = configuration.textLabelBackgroundcolor
        
        return hud
    }
}

fileprivate struct HUDContainer: ViewModifier {
    @Binding var show: Bool
    
    var time: Double? = nil
    var configuration: HUDConfiguration
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if show {
                HUD(configuration: configuration)
                    .onAppear{
                        if let time = self.time {
                            Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: false) { _ in
                                self.show = false
                            }
                        }
                }
            }
        }
    }
}

extension View {
    ///Presenting a HUD with a specific configuration. If time is nil, HUD will show until SHOW will be set to FALSE.
    func hud(show: Binding<Bool>, for time: Double? = nil, with configuration: HUDConfiguration) -> some View {
        return self.modifier( HUDContainer(show: show,time: time, configuration: configuration) )
    }
}


struct HUD_PreviewsHelper {
    var config = HUDConfiguration(mode: .circleActivityIndicator)
}

struct HUD_Previews: PreviewProvider {
    
    static var previews: some View {
        HUD(configuration: HUD_PreviewsHelper().config)
    }
}
