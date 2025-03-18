//
//  HomeView.swift
//  SocialMediaYT
//
//  Created by user270092 on 2/6/25.
//

import SwiftUI

struct HomeView: View {
    let user: User

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        if !user.userProfileImage.isEmpty {
                            AsyncImage(url: URL(string: user.userProfileImage)) { image in
                                image.resizable()
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Welcome,")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text(user.username)
                                .font(.headline)
                        }
                        Spacer()
                    }
                    .padding()
                }

                StoryView()
                Divider()
                PostListView(posts: posts) // Display user posts
            }
            .navigationTitle(user.username)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "pencil.and.outline")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ChatListView()) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView(user: User(
        username: "TestUser",
        password: "password123", // Can be ignored if unused in the view
        userProfileImage: "https://example.com/profile.jpg", // Replace with a real or placeholder URL
        topicTags: ["Swift", "iOS", "D&D"],
        posts: [] // Provide an empty array or test posts
    ))
}

