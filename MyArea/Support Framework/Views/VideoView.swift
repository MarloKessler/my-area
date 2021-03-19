//
//  VideoView.swift
//  PlayerViewTestApp
//
//  Created by Marlo Kessler on 28.12.19.
//  Copyright © 2019 Marlo Kessler. All rights reserved.
//

import Foundation
import SwiftUI
import AVKit

public struct VideoView: UIViewControllerRepresentable {
    
    private let videoURL: URL
    private let player: AVPlayer
    
    public init(_ videoURL: URL) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session category, mode, and options.
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
            try audioSession.setActive(true)
        } catch {}
        
        self.videoURL = videoURL
        player = AVPlayer(url: videoURL)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<VideoView>) -> UIViewController {
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        playerViewController.exitsFullScreenWhenPlaybackEnds = true
        playerViewController.showsPlaybackControls = true
        
        return playerViewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<VideoView>) {}
}
