import SwiftUI

struct PostCard: View {
    let post: Post
    let showProfileLink: Bool // New parameter
    
    @State private var selectedStory: Story? // Handles fullscreen image preview

    var body: some View {
        VStack(alignment: .leading) {
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
                            .foregroundColor(.gray) // Prevents redundant navigation in ProfileView
                    }
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .padding()
            }
            
            VStack {
                Image(post.postImageName)
                    .resizable()
                    .scaledToFill()
            }
            .frame(maxHeight: 400)
            .background(Color.white)
            .cornerRadius(0)
            
            HStack {
                Button {
                    print("Like")
                } label: {
                    Image(systemName: "heart")
                }
                Button {
                    print("Comment")
                } label: {
                    Image(systemName: "message")
                }
                Button {
                    print("Share")
                } label: {
                    Image(systemName: "paperplane")
                }
                Spacer()
                Button {
                    print("Bookmark")
                } label: {
                    Image(systemName: "bookmark")
                }
            }
            .foregroundColor(.black)
            .font(.title3)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            
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
        PostCard(post: posts[0], showProfileLink: true) // Updated preview
    }
}

