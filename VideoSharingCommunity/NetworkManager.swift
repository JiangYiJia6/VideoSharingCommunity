//
//  NetworkManager.swift
//  VideoSharingCommunity
//
//  Created by Yijia Jiang on 2025-02-15.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchVideoURL(from urlString: String, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching video URL: \(error)")
                completion(nil)
                return
            }
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let videoURLString = json["videoUrl"] as? String,
               let videoURL = URL(string: videoURLString) {
                print("Fetched video URL: \(videoURL)")
                completion(videoURL)
            } else {
                print("Failed to parse video URL from response")
                completion(nil)
            }
        }.resume()
    }
    
    func submitComment(videoID: String, comment: String, completion: @escaping (Bool) -> Void) {
        
        guard let apiURL = URL(string: "http://localhost:3000/items/\(videoID)/comments") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let commentData: [String: Any] = ["comment": comment]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: commentData, options: [])
            request.httpBody = jsonData
        } catch {
            print("Failed to encode comment: \(error.localizedDescription)")
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print("Failed to submit comment: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
           
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                
                completion(true)
            } else {
                
                print("Failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                completion(false)
            }
        }
        
        task.resume()
    }


    
    func fetchVideoComments(videoId: String, completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "http://localhost:3000/items/\(videoId)") else {
            print("❌ Invalid URL")
            completion([])
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error fetching comments: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let data = data else {
                print("❌ No data received")
                completion([])
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("✅ Received JSON: \(json)") // Debugging log
                    if let comments = json["comments"] as? [String] {
                        print("✅ Extracted Comments: \(comments)")
                        completion(comments)
                    } else {
                        print("❌ Comments field missing or incorrect type")
                        completion([])
                    }
                } else {
                    print("❌ JSON parsing failed")
                    completion([])
                }
            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
                completion([])
            }
        }

        task.resume()
    }

    
}
