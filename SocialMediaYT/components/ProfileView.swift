//
//  ProfileView.swift
//  SocialMediaYT
//
//  Created by user270092 on 2/7/25.
//

import SwiftUI

struct ProfileView: View {
    let user: Post // The user's data
    
    // Filter posts that match the current user's username
    var userPosts: [Post] {
        posts.filter { $0.username == user.username }
    }
    
    var body: some View {
        VStack {
            // Profile Header
            VStack {
                Image(user.userProfileImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    .shadow(radius: 3)
                    .frame(width: 100, height: 100)
                
                Text(user.name)
                    .font(.title)
                    .bold()
                
                Text(user.username)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            
            // User's Posts
            List(userPosts) { post in
                PostCard(post: post, showProfileLink: false) // Prevents navigation loop
            }
            .listStyle(PlainListStyle()) // Makes it look more like a feed
        }
        .navigationTitle(user.username)
    }
}

#Preview {
    NavigationStack {
        ProfileView(user: posts[0]) // Example user profile
    }
}

