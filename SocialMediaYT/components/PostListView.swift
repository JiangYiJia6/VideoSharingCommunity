//
//  PostListView.swift
//  SocialMediaYT
//
//  Created by user270092 on 2/6/25.
//

import SwiftUI

struct PostListView: View {
    let posts: [Post]
    var body: some View {
        VStack {
            ForEach(posts) { post in
                PostCard(post: post, showProfileLink: true) // Explicitly set showProfileLink to true
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 7)
            }
        }
        .listStyle(.plain)
    }
}


