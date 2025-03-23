//
//  FullScreenVideoView.swift
//  VideoSharingCommunity
//
//  Created by Yijia Jiang on 2025-03-04.
//

import SwiftUI
import AVKit

struct FullScreenVideoView: View {
    var player: AVPlayer?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        setOrientation(.portrait) // Force portrait mode
                    }
                    .onDisappear {
                        setOrientation(.all) // Restore default orientations
                    }
            } else {
                Text("No video available")
                    .foregroundColor(.white)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss() // Exit fullscreen
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    
    private func setOrientation(_ orientation: UIInterfaceOrientationMask) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
    }
}

#Preview {
    FullScreenVideoView()
}
