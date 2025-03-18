//
//  SocialMediaYTApp.swift
//  SocialMediaYT
//
//  Created by user270092 on 2/6/25.
//

import SwiftUI
import FirebaseCore

@main
struct SocialMediaYTApp: App {
    
    init() {
      FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
