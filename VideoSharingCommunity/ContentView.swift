//
//  ContentView.swift
//  VideoSharingCommunity
//
//  Created by Yijia Jiang on 2025-02-07.
//

import SwiftUI
import Firebase
import AVKit

struct ContentView: View {
   
    var body: some View {
        GeometryReader{
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            Video(size:size,safeArea: safeArea)
                .ignoresSafeArea()
                .onAppear{
                    print("Firebase Initialized: \(FirebaseApp.app() != nil)")
                }
               
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
