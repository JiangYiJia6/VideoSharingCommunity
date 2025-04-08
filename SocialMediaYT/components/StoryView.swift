//
//  StoryView.swift
//  SocialMediaYT
//
//  Created by user270092 on 2/6/25.
//

import SwiftUI

struct Story: Identifiable {
    var id = UUID()
    var imageName: String
}

struct StoryView: View {
    let stories: [Story] = (1...7).map { Story(imageName: "image\($0)") }
    
    @State private var selectedStory: Story?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(stories) { story in
                    Image(story.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        .shadow(radius: 3)
                        .onTapGesture {
                            selectedStory = story
                        }
                }
            }
            .padding()
        }
        .fullScreenCover(item: $selectedStory) { currentStory in
            FullScreenStoryView(story: currentStory)
        }
    }
}

struct FullScreenStoryView: View {
    let story: Story
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image(story.imageName)
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
            },
            alignment: .topTrailing
        )
    }
}

// ✅ Corrected Preview
#Preview {
    StoryView()
}
