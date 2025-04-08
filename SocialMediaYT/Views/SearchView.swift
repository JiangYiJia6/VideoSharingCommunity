//
//  SearchView.swift
//  SocialMediaYT
//
//  Created by user270092 on 3/30/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    let topicOptions = ["Nature", "Music", "Technology", "Sports", "Art", "Science", "Gaming", "Travel", "Cooking", "Fitness"]
    
    var filteredTopics: [String] {
        if searchText.isEmpty {
            return topicOptions
        } else {
            return topicOptions.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(filteredTopics, id: \.self) { topic in
                        NavigationLink(destination: FilteredPostListView(selectedTopic: topic)) {
                            HStack {
                                Image(systemName: "tag")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)

                                Text(topic)
                                    .fontWeight(.semibold)

                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .searchable(text: $searchText, prompt: "Search topics...")
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SearchView()
}
