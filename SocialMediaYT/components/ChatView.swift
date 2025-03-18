//
//  ChatView.swift
//  SocialMediaYT
//
//  Created by user270092 on 2/7/25.
//

import SwiftUI

struct ChatView: View {
    let receiver: String
    @State private var messages: [Message] = [
        Message(sender: "john123", receiver: "emma456", text: "Hey, how are you?", timestamp: Date()),
        Message(sender: "emma456", receiver: "john123", text: "I'm good! You?", timestamp: Date())
    ]
    @State private var newMessage = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        HStack {
                            if message.sender == "john123" {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }

            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle(receiver)
        .navigationBarTitleDisplayMode(.inline)
    }

    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        let newMsg = Message(sender: "john123", receiver: receiver, text: newMessage, timestamp: Date())
        messages.append(newMsg)
        newMessage = ""
    }
}

#Preview {
    ChatView(receiver: "emma456")
}

