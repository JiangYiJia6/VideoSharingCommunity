//
//  UserModel.swift
//  SocialMediaYT
//
//  Created by user270092 on 3/7/25.
//

import Foundation

struct User: Identifiable {
    let id = UUID()
    let username: String
    let password: String
    let userProfileImage: String
    var topicTags: [String]
    let posts: [Post]
    
    init(username: String, password: String, userProfileImage: String, topicTags: [String], posts: [Post]) {
        self.username = username
        self.password = password
        self.userProfileImage = userProfileImage
        self.topicTags = topicTags
        self.posts = posts
    }
}
