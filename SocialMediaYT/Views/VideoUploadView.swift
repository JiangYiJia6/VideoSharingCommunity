//
//  VideoUploadView.swift
//  VideoSharingCommunity
//
//  Created by Yijia Jiang on 2025-03-23.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct VideoUploadView: View {
    @State private var videoPickerItem: PhotosPickerItem?
    @State private var videoURL: URL?
    @State private var name: String = ""
    @State private var tag: String = ""
    @State private var isUploading = false
    @State private var uploadMessage: String = ""

    var body: some View {
        VStack(spacing: 20) {
            PhotosPicker(selection: $videoPickerItem, matching: .videos) {
                Text(videoURL == nil ? "Select a Video" : "Video Selected")
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .onChange(of: videoPickerItem) { _ in
                loadVideo()
            }
            
            TextField("Enter video name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter tag", text: $tag)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: uploadVideo) {
                Text("Upload Video")
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(videoURL == nil || name.isEmpty || tag.isEmpty || isUploading)
            
            if isUploading {
                ProgressView()
            }
            
            Text(uploadMessage)
                .foregroundColor(.blue)
        }
        .padding()
        .onAppear {
            loadVideo()  
        }
    }
    
    func loadVideo() {
        if let videoPath = Bundle.main.path(forResource: "sample_video", ofType: "mp4") {
            let videoURL = URL(fileURLWithPath: videoPath)

            // Copy to a temporary directory
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("sample_video.mp4")

            do {
                // If the file doesn’t exist, copy it
                if !FileManager.default.fileExists(atPath: tempURL.path) {
                    try FileManager.default.copyItem(at: videoURL, to: tempURL)
                }
                self.videoURL = tempURL
                print("Video loaded from project folder: \(tempURL)")
            } catch {
                print("Error copying video file: \(error)")
            }
        } else {
            print("Sample video not found in bundle")
        }
    }




    
//    func loadVideo() {
//        Task {
//            if let videoPickerItem {
//                if let url = try? await videoPickerItem.loadTransferable(type: URL.self) {
//                    videoURL = url
//                }
//            }
//        }
//    }

    func uploadVideo() {
        guard let videoURL else { return }
        isUploading = true
        uploadMessage = "Uploading..."

        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: "http://localhost:3000/items")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let newline = "\r\n"
        
        // Add Name
        body.append("--\(boundary)\(newline)")
        body.append("Content-Disposition: form-data; name=\"name\"\(newline)\(newline)")
        body.append("\(name)\(newline)")
        
        // Add Tag
        body.append("--\(boundary)\(newline)")
        body.append("Content-Disposition: form-data; name=\"tag\"\(newline)\(newline)")
        body.append("\(tag)\(newline)")
        
        // Add Video File
        let filename = "video.mp4"
        let mimetype = "video/mp4"
        let fileData = try! Data(contentsOf: videoURL)
        
        body.append("--\(boundary)\(newline)")
        body.append("Content-Disposition: form-data; name=\"video\"; filename=\"\(filename)\"\(newline)")
        body.append("Content-Type: \(mimetype)\(newline)\(newline)")
        body.append(fileData)
        body.append("\(newline)--\(boundary)--\(newline)")
        
        request.httpBody = body
        request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        
        // Upload request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isUploading = false
                if let error = error {
                    uploadMessage = "Upload failed: \(error.localizedDescription)"
                } else {
                    uploadMessage = "Upload successful!"
                }
            }
        }
        task.resume()
    }
}

// Helper to append Data
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

struct VideoUploadView_Previews: PreviewProvider {
    static var previews: some View {
        VideoUploadView()
    }
}

