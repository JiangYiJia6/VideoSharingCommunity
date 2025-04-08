//
//  VideoUploadView.swift
//  VideoSharingCommunity
//
//  Created by Yijia Jiang on 2025-03-23.
//

import SwiftUI
import FirebaseFirestore

struct VideoUploadView: View {
    let user: User
    
    @State private var videoUrl: String = ""
    @State private var name: String = ""
    @State private var description: String = ""
    //@State private var tag: String = ""
    @State private var tagInput: String = ""
    @State private var isUploading = false
    @State private var uploadMessage: String = ""
    
    

    var body: some View {
        VStack(spacing: 20) {
            // Video URL input
            TextField("Enter video URL", text: $videoUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Name input
            TextField("Enter video name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Text input
            TextField("Enter video description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Tag input
            //TextField("Enter tag", text: $tag)
            TextField("Enter tags (comma-separated)", text: $tagInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Upload button
            Button(action: uploadToFirebase) {
                Text("Upload")
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            //.disabled(videoUrl.isEmpty || name.isEmpty || tag.isEmpty || isUploading)
            .disabled(videoUrl.isEmpty || name.isEmpty || tagInput.isEmpty || isUploading)

            if isUploading {
                ProgressView()
            }

            Text(uploadMessage)
                .foregroundColor(.blue)
                .padding(.top, 10)
        }
        .padding()
    }

    func uploadToFirebase() {
        isUploading = true
        uploadMessage = "Uploading..."

        let db = Firestore.firestore()
       // let data: [String: Any] = [
       //     "videoUrl": videoUrl,
       //     "name": name,
       //     "tag": tag,
       //     "timestamp": Timestamp(date: Date())
       // ]
        let data: [String: Any] = [
            "name": name,
            "username": "currentUser", // Replace with actual logged-in username
            "userProfileImage": user.userProfileImage, // Or any user image logic
            "postImageName": ["image1","image2","image3","image4","image5","image6","image7"].randomElement() ?? "default_image",    // Optional preview image if needed
            "description": description,
            "videoURL": videoUrl,
            //"tags": [tag],
            "tags": tagInput
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty },
            "timestamp": Timestamp(date: Date())
        ]


        db.collection("items").addDocument(data: data) { error in
            isUploading = false
            if let error = error {
                uploadMessage = "Upload failed: \(error.localizedDescription)"
            } else {
                uploadMessage = "Upload successful!"
                videoUrl = ""
                name = ""
                //tag = ""
                tagInput = ""
            }
        }
    }
}

struct VideoUploadView_Previews: PreviewProvider {
    static var previews: some View {
            VideoUploadView(user: User(
                username: "PreviewUser",
                password: "preview123",
                userProfileImage: "https://example.com/profile.jpg",
                topicTags: ["Nature", "Music"],
                posts: []
            ))
        }
}

