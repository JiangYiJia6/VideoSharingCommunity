//
//  ContentView.swift
//  SocialMediaYT
//
//  Created by user270092 on 2/6/25.
//

import SwiftUI
import Firebase
import AVKit

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack{
                LoginView()
                //HomeView(user: User(
                //    username: "TestUser",
                //    password: "password123", // Can be ignored if unused in the view
                //    userProfileImage: "https://example.com/profile.jpg", // Replace with a real or placeholder URL
                //    topicTags: ["Swift", "iOS", "D&D"],
                //    posts: [] // Provide an empty array or test posts
                //))
//                GeometryReader{
//                    let size = $0.size
//                    let safeArea = $0.safeAreaInsets
//                    
//                    Video(size:size,safeArea: safeArea)
//                        .ignoresSafeArea()
//                }
//                .preferredColorScheme(.dark)

            }
        }.onAppear{
            print("Firebase Initialized: \(FirebaseApp.app() != nil)")
        }
        
    }
}

#Preview {
    NavigationStack{
        ContentView()
    }
}
