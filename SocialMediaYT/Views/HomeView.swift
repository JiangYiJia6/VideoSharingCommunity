//
//  HomeView.swift
//  SocialMediaYT
//
//  Created by user270092 on 2/6/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView{
            ScrollView{
                StoryView()
                Divider()
                PostListView(posts: posts)
            }
            .navigationTitle("Serafino")
            .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Image(systemName: "pencil.and.outline")
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: ChatListView()) {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(.black) // Customize color if needed
                                }
                            }
                        }
        }
    }
}

#Preview {
    HomeView()
}
