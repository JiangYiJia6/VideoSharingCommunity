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
    @Binding var lastDraggedProgress: CGFloat
    @Binding var isSeeking: Bool
    @Binding var isFinishedPlaying: Bool
    @Binding var comments: [DanmakuComment]
    @Binding var isPressed: Bool
    @Binding var commentOffsets: [CGFloat]
    @Binding var isFullScreen: Bool

    @GestureState  var isDragging: Bool = false
    @State  var timeoutTask: DispatchWorkItem?
    @State  var comment: String = ""
    @State  var videoId: String

    //init(
    //    size: CGSize,
    //    safeArea: EdgeInsets,
    //    player: Binding<AVPlayer?>,
    //    showPlayerControls: Binding<Bool>,
    //    isPlaying: Binding<Bool>,
    //    progress: Binding<CGFloat>,
    //    lastDraggedProgress: Binding<CGFloat>,
    //    isSeeking: Binding<Bool>,
    //    isFinishedPlaying: Binding<Bool>,
    //    comments: Binding<[DanmakuComment]>,
    //    isPressed: Binding<Bool>,
    //    commentOffsets: Binding<[CGFloat]>,
    //    videoId: String,
    //    isFullScreen: Binding<Bool>
    //) {
    //    self.size = size
    //    self.safeArea = safeArea
    //    self._player = player
    //    self._showPlayerControls = showPlayerControls
    //    self._isPlaying = isPlaying
    //    self._progress = progress
    //    self._lastDraggedProgress = lastDraggedProgress
    //    self._isSeeking = isSeeking
    //    self._isFinishedPlaying = isFinishedPlaying
    //    self._comments = comments
    //    self._isPressed = isPressed
    //    self._commentOffsets = commentOffsets
    //    self.videoId = videoId
    //    self._isFullScreen = isFullScreen
    //}

    var body: some View {
        let videoPlayerSize = CGSize(width: size.width, height: size.height / 3.5)

        ZStack {
            if let player = player {
                CustomVideoPlayer(player: player)
                    .overlay {
                        Rectangle()
                            .fill(.black.opacity(0.4))
                            .opacity(showPlayerControls || isDragging ? 1 : 0)
                            .animation(.easeInOut(duration: 0.35), value: isDragging)
                            .overlay { PlaybackControls() }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            showPlayerControls.toggle()
                        }
                        if isPlaying { timeoutControls() }
                    }
                    .overlay(alignment: .bottom) {
                        VideoSeekerView(videoPlayerSize)
                    }
            }

            // Danmaku comments overlay
            VStack {
                ForEach(comments.indices, id: \.self) { index in
                    let comment = comments[index]
                    Text(comment.text)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(5)
                        .offset(x: comment.offsetX)
                        .animation(.linear(duration: 3), value: comments[index].offsetX)
                        .onAppear {
                            withAnimation(.linear(duration: 5)) {
                                comments[index].offsetX = -UIScreen.main.bounds.width
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                if index < comments.count {
                                    withAnimation { comments.remove(at: index) }
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

                Text("#nature") // Example tag, update dynamically

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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("📢 Fetching comments for videoId: \(videoId)")
                NetworkManager.shared.fetchVideoComments(videoId: videoId) { comments in
                    DispatchQueue.main.async {
                        self.comments = comments.map { DanmakuComment(text: $0) }
                    }
                }
            }
        }
    }

    @ViewBuilder
    func VideoSeekerView(_ videoSize: CGSize) -> some View {
        ZStack(alignment: .leading) {
            Rectangle().fill(.gray)
            Rectangle().fill(.red).frame(width: max(size.width * progress, 0))
        }
        .frame(height: 3)
    }

    @ViewBuilder
    func PlaybackControls() -> some View {
        Button {
            if isFinishedPlaying {
                isFinishedPlaying = false
                player?.seek(to: .zero)
                progress = .zero
                lastDraggedProgress = .zero
            }
            if isPlaying {
                player?.pause()
                timeoutTask?.cancel()
            } else {
                player?.play()
                timeoutControls()
            }
            withAnimation(.easeInOut(duration: 0.2)) { isPlaying.toggle() }
        } label: {
            Image(systemName: isFinishedPlaying ? "arrow.clockwise" : (isPlaying ? "pause.fill" : "play.fill"))
                .font(.title2)
                .foregroundColor(.white)
                .padding(15)
                .background(Circle().fill(.black.opacity(0.35)))
        }
    }

    func timeoutControls() {
        timeoutTask?.cancel()
        timeoutTask = DispatchWorkItem {
            withAnimation(.easeInOut(duration: 0.35)) { showPlayerControls = false }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: timeoutTask!)
    }
}

#Preview {
    VideoPlayerView(
        size: CGSize(width: 300, height: 200),
        safeArea: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        player: .constant(nil),
        showPlayerControls: .constant(false),
        isPlaying: .constant(false),
        progress: .constant(0),
        lastDraggedProgress: .constant(0),
        isSeeking: .constant(false),
        isFinishedPlaying: .constant(false),
        comments: .constant([]),
        isPressed: .constant(false),
        commentOffsets: .constant([]),
        isFullScreen: .constant(false), // Make sure isFullScreen is before videoId
        videoId: "5dc885d1-bc5d-42a8-b47b-82267319075a"
    )
}

