//
//  MessageModel.swift
//  SocialMediaYT
//
//  Created by user270092 on 2/7/25.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let sender: String
    let receiver: String
    let text: String
    let timestamp: Date
}

