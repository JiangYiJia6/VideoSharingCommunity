//
//  CustomVideoPlayer.swift
//  VideoSharingCommunity
//
//  Created by Yijia Jiang on 2025-02-07.
//

import SwiftUI
import AVKit

struct CustomVideoPlayer: UIViewControllerRepresentable {
    var player = AVPlayer()
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

#Preview {
    CustomVideoPlayer()
}
