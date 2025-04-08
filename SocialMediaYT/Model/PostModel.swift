//
//  PostModel.swift
//  SocialMediaYT
//
//  Created by user270092 on 2/6/25.
//

import Foundation

struct Post: Identifiable {
    let id = UUID()
    let name: String
    let username: String
    let userProfileImage: String
    let postImageName: String
    let description: String
    let videoURL: String?
    let tags: [String]
    
    
    init(name: String, username: String, postImageName: String, description: String, videoURL: String?, tags: [String] = []) {
        self.name = name
        self.username = username
        self.userProfileImage = ["image1","image2","image3","image4","image5","image6","image7"].randomElement() ?? "default_image"
        self.postImageName = postImageName
        self.description = description
        self.videoURL = videoURL
        self.tags = tags
    }
}

let topicOptions = ["Nature", "Music", "Technology", "Sports", "Art", "Science", "Gaming", "Travel", "Cooking", "Fitness"]

let posts = [
    Post(name: "John", username: "john123", postImageName: "image1", description: "Hiking through lush green forests.", videoURL: "https://res.cloudinary.com/dqooyao2x/video/upload/v1739668823/cat5_elfcs1.mp4", tags: ["Nature", "Travel"]),
    Post(name: "John", username: "john123", postImageName: "image6", description: "Another post where on fire.", videoURL: "https://res.cloudinary.com/dqooyao2x/video/upload/v1739668687/cat2_wrunpx.mp4", tags: ["Sports"]),
    Post(name: "Emma", username: "emma456", postImageName: "image2", description: "Admiring the serene beauty of a waterfall.", videoURL: "https://res.cloudinary.com/dqooyao2x/video/upload/v1739665937/water-falling-on-rocks-854982_fpkjlg.mp4", tags: ["Nature"]),
    Post(name: "Michael", username: "mike789", postImageName: "image3", description: "Camping under a starry sky.", videoURL: "https://res.cloudinary.com/dqooyao2x/video/upload/v1739668794/cat4_bl1wln.mp4", tags: ["Travel"]),
    Post(name: "Sophia", username: "sophia1", postImageName: "image4", description: "Exploring a tranquil lake.", videoURL: "https://res.cloudinary.com/dqooyao2x/video/upload/v1739668823/cat5_elfcs1.mp4", tags: ["Nature", "Fitness"]),
    Post(name: "David", username: "dave007", postImageName: "image5", description: "Capturing the sunrise over mountains.", videoURL: "https://res.cloudinary.com/dqooyao2x/video/upload/v1739668687/cat2_wrunpx.mp4", tags: ["Art", "Travel"]),
    Post(name: "Olivia", username: "olivia22", postImageName: "image6", description: "Walking along a pristine beach.", videoURL: "https://res.cloudinary.com/dqooyao2x/video/upload/v1739665937/water-falling-on-rocks-854982_fpkjlg.mp4", tags: ["Travel", "Fitness"]),
    Post(name: "Daniel", username: "dan456", postImageName: "image7", description: "Marveling at the colorful sunset by the ocean.", videoURL: "https://res.cloudinary.com/dqooyao2x/video/upload/v1739668794/cat4_bl1wln.mp4", tags: ["Nature", "Art"])
]
