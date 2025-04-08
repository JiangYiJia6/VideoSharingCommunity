//
//  FilteredPostListView.swift
//  SocialMediaYT
//
//  Created by user270092 on 4/1/25.
//


import SwiftUI

struct FilteredPostListView: View {
    let selectedTopic: String
    let filteredPosts: [Post]

    init(selectedTopic: String) {
        self.selectedTopic = selectedTopic
        self.filteredPosts = posts.filter { $0.tags.contains(selectedTopic) }
    }

    var body: some View {
        ScrollView {
            VStack {
                if filteredPosts.isEmpty {
                    Text("No posts found for '\(selectedTopic)'")
                        .foregroundColor(.gray)
                        .italic()
                        .padding()
                } else {
                    PostListView(posts: filteredPosts)
                }
            }
        }
        .navigationTitle(selectedTopic)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FilteredPostListView(selectedTopic: "Sports")
}
