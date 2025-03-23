import SwiftUI
import AVKit

struct PostCard: View {
    let post: Post
    let showProfileLink: Bool

    @State private var selectedStory: Story?
    @State private var player: AVPlayer? = nil
    @State private var isPlaying: Bool = false
    @State private var progress: CGFloat = 0
    @State private var lastDraggedProgress: CGFloat = 0
    @State private var isSeeking: Bool = false
    @State private var isFinishedPlaying: Bool = false
    @State private var isFullScreen: Bool = false
    @State private var commentOffsets: [CGFloat] = []
    @State private var comments: [DanmakuComment] = []
    @State private var showPlayerControls: Bool = true  // Added state

    var body: some View {
        VStack(alignment: .leading) {
            // Profile Header
            HStack(spacing: 1) {
                Image(post.userProfileImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    .shadow(radius: 3)
                    .frame(width: 70, height: 70)
                    .onTapGesture {
                        print("Tapped on profile image: \(post.userProfileImage)")
                        self.selectedStory = Story(imageName: post.userProfileImage)
                    }

                VStack(alignment: .leading) {
                    Text(post.name)
                        .bold()

                    if showProfileLink {
                        NavigationLink(destination: ProfileView(user: post)) {
                            Text(post.username)
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                    } else {
                        Text(post.username)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .padding()
            }

            // Content: Image or Video
            VStack {
                if let videoURLString = post.videoURL, let videoURL = URL(string: videoURLString) {
                    VideoPlayerView(
                        size: CGSize(width: UIScreen.main.bounds.width, height: 400),
                        safeArea: EdgeInsets(),
                        player: $player,
                        showPlayerControls: $showPlayerControls,  // Pass the state here
                        isPlaying: $isPlaying,
                        progress: $progress,
                        lastDraggedProgress: $lastDraggedProgress,
                        isSeeking: $isSeeking,
                        isFinishedPlaying: $isFinishedPlaying,
                        comments: $comments,
                        isPressed: .constant(false),
                        commentOffsets: $commentOffsets,
                        videoId: post.id.uuidString, isFullScreen: $isFullScreen
                    )
                    .frame(height: 400)
                    .onAppear {
                        player = AVPlayer(url: videoURL)
                    }
                } else {
                    Image(post.postImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 400)
                }
            }
            .background(Color.white)
            .cornerRadius(0)

            // Action Buttons
            HStack {
                Button { print("Like") } label: { Image(systemName: "heart") }
                Button { print("Comment") } label: { Image(systemName: "message") }
                Button { print("Share") } label: { Image(systemName: "paperplane") }
                Spacer()
                Button { print("Bookmark") } label: { Image(systemName: "bookmark") }
            }
            .foregroundColor(.black)
            .font(.title3)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)

            // Description
            HStack {
                Text(post.username)
                    .bold()
                    .font(.footnote)
                Text(post.description)
                    .font(.footnote)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.horizontal, 10)
        }
        .fullScreenCover(item: $selectedStory) { currentStory in
            FullScreenStoryView(story: currentStory)
        }
    }
}

#Preview {
    NavigationStack {
        PostCard(post: posts[0], showProfileLink: true)
    }
}

