//
//  ChatListView.swift
//  SocialMediaYT
//
//  Created by user270092 on 2/7/25.
//

import SwiftUI

struct ChatListView: View {
    let users = ["emma456", "mike789", "sophia1", "dave007", "olivia22"]

    var body: some View {
        List(users, id: \.self) { user in
            NavigationLink(destination: ChatView(receiver: user)) {
                HStack {
                    Image("default_image") // Replace with actual user profile images
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(user)
                            .bold()
                        Text("Last message preview...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.vertical, 5)
            }
        }
        .navigationTitle("Messages") // This will work properly if called from a NavigationStack
    }
}

// ✅ Corrected Preview
#Preview {
    NavigationStack { // Ensure navigation works in preview
        ChatListView()
    }
}

