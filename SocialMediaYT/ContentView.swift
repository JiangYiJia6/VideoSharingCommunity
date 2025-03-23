//
//  ContentView.swift
//  SocialMediaYT
//
//  Created by user270092 on 2/6/25.
//

import SwiftUI
import Firebase
import AVKit

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack{
                LoginView()
//                GeometryReader{
//                    let size = $0.size
//                    let safeArea = $0.safeAreaInsets
//                    
//                    Video(size:size,safeArea: safeArea)
//                        .ignoresSafeArea()
//                }
//                .preferredColorScheme(.dark)

            }
        }.onAppear{
            print("Firebase Initialized: \(FirebaseApp.app() != nil)")
        }
        
    }
}

#Preview {
    NavigationStack{
        ContentView()
    }
}
