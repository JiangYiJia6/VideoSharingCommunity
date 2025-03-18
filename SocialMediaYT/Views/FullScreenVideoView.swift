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
}


#Preview {
    FullScreenVideoView()
}

