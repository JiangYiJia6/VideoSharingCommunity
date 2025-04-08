//
//  NavigationView.swift
//  SocialMediaYT
//
//  Created by user270092 on 3/30/25.
//

import SwiftUI

struct MainTabView: View { // ✅ Renamed from NavigationView
    let user: User
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Feed
            HomeView(user: user)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            // Search View
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)

            // Video Upload View
            VideoUploadView(user: user)
                .tabItem {
                    Image(systemName: "plus.square.fill")
                    Text("Upload")
                }
                .tag(2)
        }
        .tint(Color.purple) // Optional: Change tab highlight color
    }
}

// ✅ Corrected Preview
#Preview {
    MainTabView(user: User(
        username: "TestUser",
        password: "password123", // Can be ignored if unused in the view
        userProfileImage: "https://example.com/profile.jpg", // Replace with a real or placeholder URL
        topicTags: ["Swift", "iOS", "D&D"],
        posts: [] // Provide an empty array or test posts
    ))
}
