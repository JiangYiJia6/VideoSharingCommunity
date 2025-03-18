//
//  VideoPlayerView.swift
//  VideoSharingCommunity
//
//  Created by Yijia Jiang on 2025-02-20.
//

import SwiftUI
import AVKit
import Foundation


struct VideoPlayerView: View {
    var size: CGSize
    var safeArea: EdgeInsets
    @Binding var player: AVPlayer?
    @Binding var showPlayerControls: Bool
    @Binding var isPlaying: Bool
    @Binding var progress: CGFloat
    @Binding var lastGraggedProgress: CGFloat
    @Binding var isSeeking: Bool
    @Binding var isFinishedPlaying: Bool
    @Binding var comments: [DanmakuComment] 

    @Binding var isPressed: Bool
    @Binding var commentOffsets: [CGFloat]
    
    @GestureState private var isDragging: Bool = false
    @State private var timeoutTask: DispatchWorkItem?
    @State private var comment: String = ""
    @State private var videoUrl: String? // To store the fetched video URL
    @State private var videoId: String // Assuming you have a way to set this video ID
    @Binding var isFullScreen: Bool

    
    init(size: CGSize,
             safeArea: EdgeInsets,
             player: Binding<AVPlayer?>,
             showPlayerControls: Binding<Bool>,
             isPlaying: Binding<Bool>,
             progress: Binding<CGFloat>,
             lastGraggedProgress: Binding<CGFloat>,
             isSeeking: Binding<Bool>,
             isFinishedPlaying: Binding<Bool>,
            comments: Binding<[DanmakuComment]>,
             isPressed: Binding<Bool>,
             commentOffsets: Binding<[CGFloat]>,
             videoId: String,
         isFullScreen: Binding<Bool>) {
            self.size = size
            self.safeArea = safeArea
            self._player = player
            self._showPlayerControls = showPlayerControls
            self._isPlaying = isPlaying
            self._progress = progress
            self._lastGraggedProgress = lastGraggedProgress
            self._isSeeking = isSeeking
            self._isFinishedPlaying = isFinishedPlaying
            self._comments = comments
            self._isPressed = isPressed
            self._commentOffsets = commentOffsets
            self.videoId = videoId
            self._isFullScreen=isFullScreen
        }

    var body: some View {
        let videoPlayerSize: CGSize = .init(width: size.width, height: size.height / 3.5)
        
        ZStack {
            if let player = player {
                CustomVideoPlayer(player: player)
                    .overlay {
                        Rectangle()
                            .fill(.black.opacity(0.4))
                            .opacity(showPlayerControls || isDragging ? 1 : 0)
                            .animation(.easeInOut(duration: 0.35), value: isDragging)
                            .overlay {
                                PlaybackControls()
                            }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            showPlayerControls.toggle()
                        }
                        
                        if isPlaying {
                            timeoutControls()
                        }
                    }
                    .overlay(alignment: .bottom) {
                        VideoSeekerView(videoPlayerSize)
                    }
            }
            
            VStack {
                
                    ForEach(comments.indices, id: \.self) { index in
                        let comment = comments[index] // ✅ Use DanmakuComment struct
                        Text(comment.text)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(5)
                            .offset(x: comment.offsetX) // ✅ Apply `offsetX` from DanmakuComment
                            .animation(.linear(duration: 3), value: comments[index].offsetX) // ✅ Animate movement
                            .onAppear {
                                withAnimation(.linear(duration: 5)) {
                                    comments[index].offsetX = -UIScreen.main.bounds.width // ✅ Move comment leftward
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    if index < comments.count { // ✅ Prevents out-of-bounds crash
                                        withAnimation {
                                            comments.remove(at: index)
                                        }
                                    }
                                }
                            }
                    
                }



            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .onChange(of: comments) { newComments in
                print("📢 UI Updated with comments: \(newComments)")
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Button {
                        isFullScreen.toggle()
                    } label: {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.black.opacity(0.35)))
                    }
                    .padding(.bottom, 5)
                    .fullScreenCover(isPresented: $isFullScreen) {
                        FullScreenVideoView(player: player)
                    }
                Text("#nature") // Example tag, update based on your data
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                
                HStack(spacing: 8) {
                    TextField("comments?", text: $comment)
                        .padding(.horizontal, 8)
                        .frame(width: 300, height: 20)
                        .background(Color.white.opacity(0.4))
                        .cornerRadius(8)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    Button {
                        if !comment.isEmpty {
                            
                            NetworkManager.shared.submitComment(videoID: videoId, comment: comment) { success in
                                if success {
                                    withAnimation {
                                        comments.append(DanmakuComment(text: comment))
                                    }
                                    comment = ""
                                } else {
                                    print("Failed to submit comment")
                                }
                            }

                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.black.opacity(0.35)))
                    }
                    
                    Button {
                        comments.removeAll()
                        isPressed.toggle()
                    } label: {
                        Image(systemName: "circle.fill")
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(isPressed ? Color.blue.opacity(0.8) : Color.black.opacity(0.35)))
                    }
                }

            }
            .opacity(isPlaying ? 0 : 1)
            .animation(.easeInOut(duration: 0.3), value: isPlaying)
            .background(Color.gray.opacity(0.1))
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Give UI time to update
                print("📢 Fetching comments for videoId: \(videoId)")
                NetworkManager.shared.fetchVideoComments(videoId: videoId) { comments in
                    DispatchQueue.main.async {
                        print("📢 Updating UI with comments: \(comments)")
                        self.comments = comments.map { DanmakuComment(text: $0) }
                    }
                }
            }
        }
    }
    


    @ViewBuilder
    func VideoSeekerView(_ videoSize: CGSize) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.gray)
            
            Rectangle()
                .fill(.red)
                .frame(width: max(size.width * progress, 0))
        }
        .frame(height: 3)
        .overlay(alignment: .leading) {
            Circle()
                .fill(.red)
                .frame(width: 15, height: 15)
                .scaleEffect(showPlayerControls || isDragging ? 1 : 0.001, anchor: progress * size.width > 15 ? .trailing : .leading)
                .contentShape(Rectangle())
                .offset(x: size.width * progress)
                .gesture(
                    DragGesture()
                        .updating($isDragging) { _, out, _ in
                            out = true
                        }
                        .onChanged { value in
                            if let timeoutTask = timeoutTask {
                                timeoutTask.cancel()
                            }
                            
                            let translationX: CGFloat = value.translation.width
                            let calculatedProgress = (translationX / videoSize.width) + lastGraggedProgress
                            progress = min(max(0, calculatedProgress), 1)
                            isSeeking = true
                        }
                        .onEnded { value in
                            lastGraggedProgress = progress
                            if let currentPlayerItem = player?.currentItem {
                                let totalDuration = currentPlayerItem.duration.seconds
                                
                                player?.seek(to: .init(seconds: totalDuration * progress, preferredTimescale: 1))
                                if isPlaying {
                                    timeoutControls()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isSeeking = false
                                }
                            }
                        }
                )
                .offset(x: progress * videoSize.width > 15 ? -15 : 0)
                .frame(width: 15, height: 15)
        }
    }
    
    @ViewBuilder
    func PlaybackControls() -> some View {
        HStack(spacing: 25) {
            Button {
                if isFinishedPlaying {
                    isFinishedPlaying = false
                    player?.seek(to: .zero)
                    progress = .zero
                    lastGraggedProgress = .zero
                }
                if isPlaying {
                    player?.pause()
                    if let timeoutTask = timeoutTask {
                        timeoutTask.cancel()
                    }
                } else {
                    player?.play()
                    timeoutControls()
                }
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPlaying.toggle()
                }
            } label: {
                Image(systemName: isFinishedPlaying ? "arrow.clockwise" : (isPlaying ? "pause.fill" : "play.fill"))
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(15)
                    .background {
                        Circle()
                            .fill(.black.opacity(0.35))
                    }
            }
            .scaleEffect(1.1)
        }
        .opacity(showPlayerControls ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: showPlayerControls && !isDragging)
    }
    
    func timeoutControls() {
        if let timeoutTask = timeoutTask {
            timeoutTask.cancel()
        }
        timeoutTask = .init {
            withAnimation(.easeInOut(duration: 0.35)) {
                showPlayerControls = false
            }
        }
        
        if let timeoutTask = timeoutTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: timeoutTask)
        }
    }
}

//#Preview {
//    VideoPlayerView()
//}
#Preview {
    VideoPlayerView(
        size: CGSize(width: 300, height: 200),
        safeArea: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        player: .constant(nil),
        showPlayerControls: .constant(false),
        isPlaying: .constant(false),
        progress: .constant(0),
        lastGraggedProgress: .constant(0),
        isSeeking: .constant(false),
        isFinishedPlaying: .constant(false),
        comments: .constant([]),
        isPressed: .constant(false),
        commentOffsets: .constant([]),
        videoId: "5dc885d1-bc5d-42a8-b47b-82267319075a",
        isFullScreen: .constant(false)
    )
}
