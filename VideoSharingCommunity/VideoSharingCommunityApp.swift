//
//  VideoSharingCommunityApp.swift
//  VideoSharingCommunity
//
//  Created by Yijia Jiang on 2025-02-07.
//

import SwiftUI
import Firebase

@main
struct VideoSharingCommunityApp: App {
    init() {
            FirebaseApp.configure()  // Initialize Firebase here
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
