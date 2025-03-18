//
//  VideoPlayerViewModel.swift
//  VideoSharingCommunity
//
//  Created by Yijia Jiang on 2025-02-20.
//

import SwiftUI
import AVKit

class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // Function to load video
    func loadVideo(url: String) {
        guard let videoURL = URL(string: url) else {
            errorMessage = "Invalid URL"
            return
        }
        player = AVPlayer(url: videoURL)
        isLoading = false
    }

    // Function to fetch comments
    func fetchComments(for videoId: String, completion: @escaping ([String]) -> Void) {
        let urlString = "http://localhost:3000/comments/\(videoId)"
        fetchCommentsFromDatabase(from: urlString) { fetchedComments in
            DispatchQueue.main.async {
                completion(fetchedComments)
            }
        }
    }

    // Function to fetch comments from the database
    private func fetchCommentsFromDatabase(from urlString: String, completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching comments: \(error)")
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    let comments = json.compactMap { $0["comment"] as? String }
                    completion(comments)
                } else {
                    completion([])
                }
            } catch {
                print("Error parsing comments: \(error)")
                completion([])
            }
        }
        task.resume()
    }
}
