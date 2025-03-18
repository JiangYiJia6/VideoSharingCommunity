//
//  Home.swift
//  VideoSharingCommunity
//
//  Created by Yijia Jiang on 2025-02-07.
//
import SwiftUI
import AVKit

struct Video: View {
    var size: CGSize
    var safeArea: EdgeInsets
    
    @StateObject private var viewModel = VideoPlayerViewModel()
    @State private var showPlayerControls: Bool = false
    @State private var isPlaying: Bool = false
    @State private var progress: CGFloat = 0
    @State private var lastGraggedProgress: CGFloat = 0
    @State private var isSeeking: Bool = false
    @State private var isFinishedPlaying: Bool = false
    @State private var comments: [DanmakuComment] = []
    @State private var isPressed: Bool = false
    @State private var commentOffsets: [CGFloat] = []
    @State private var videoURLs: [String: URL] = [:]
    @State private var isFullScreen = false

    @State private var videoId: String = "5dc885d1-bc5d-42a8-b47b-82267319075a"// Assuming you start with the first video ID
    
    @State private var recommendedVideoIDs: [String] = [
        "3a62a771-37bc-45fd-9715-75cfee19be45",
        "41c3d515-9029-44bf-a47a-9c478d7a453f",
        "7df7accf-b4f6-47ff-bff3-57c9c093a19c",
        "d8a4b4b8-1017-43b8-b6a0-a22714b967a6"
    ]


    
    var body: some View {
        VStack(spacing: 0) {
            let videoPlayerSize: CGSize = .init(width: size.width, height: size.height / 3.5)
            
            // Video player view
            if let player = viewModel.player {
                VideoPlayerView(
                    size: size,
                    safeArea: safeArea,
                    player: $viewModel.player,
                    showPlayerControls: $showPlayerControls,
                    isPlaying: $isPlaying,
                    progress: $progress,
                    lastGraggedProgress: $lastGraggedProgress,
                    isSeeking: $isSeeking,
                    isFinishedPlaying: $isFinishedPlaying,
                    comments: $comments,
                    isPressed: $isPressed,
                    commentOffsets: $commentOffsets,
                    videoId: videoId, isFullScreen: $isFullScreen // Pass the video ID to VideoPlayerView
                )
                .frame(width: videoPlayerSize.width, height: videoPlayerSize.height)
                .onAppear {
                    // Fetch comments when the view appears
                    viewModel.fetchComments(for: videoId) { fetchedComments in
                        DispatchQueue.main.async {
                            comments = fetchedComments.map { DanmakuComment(text: $0) }
                        }
                    }
                }
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(width: videoPlayerSize.width, height: videoPlayerSize.height)
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .frame(width: videoPlayerSize.width, height: videoPlayerSize.height)
            }
            
            // Recommended video list
            VStack(alignment: .leading, spacing: 8) {
                Text("Also for you:")
                    .font(.headline)
                    .padding(.horizontal, 15)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(recommendedVideoIDs, id: \.self) { videoID in
                            GeometryReader { geometry in
                                let size = geometry.size
                                
                                if let videoURL = videoURLs[videoID] {
                                    VideoPlayer(player: AVPlayer(url: videoURL))
                                        .frame(width: size.width, height: size.height)
                                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                } else {
                                    ProgressView()
                                        .frame(width: size.width, height: size.height)
                                        .background(Color.gray.opacity(0.3))
                                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                }
                            }
                            .frame(height: 200)
                        }

                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
                    .padding(.bottom, 15 + safeArea.bottom)
                }
            }
        }
        .padding(.top, safeArea.top)
        .onAppear {
            // Fetch main video URL
            NetworkManager.shared.fetchVideoURL(from: "http://localhost:3000/items/\(videoId)") { videoURL in
                if let videoURL = videoURL {
                    DispatchQueue.main.async {
                        viewModel.loadVideo(url: videoURL.absoluteString) // Ensure loadVideo accepts String
                    }
                } else {
                    viewModel.errorMessage = "Failed to fetch video URL"
                }
            }
            
            // Fetch recommended video URLs
            for videoID in recommendedVideoIDs {
                NetworkManager.shared.fetchVideoURL(from: "http://localhost:3000/items/\(videoID)") { videoURL in
                    if let videoURL = videoURL {
                        DispatchQueue.main.async {
                            videoURLs[videoID] = videoURL
                        }
                    }
                }
            }

        }
    }
}

#Preview {
    ContentView()
}
