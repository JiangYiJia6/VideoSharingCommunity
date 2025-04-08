//
//  SignUpView.swift
//  SocialMediaYT
//
//  Created by user270092 on 3/6/25.
//

import SwiftUI

import Firebase
import FirebaseFirestore

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var userProfileImage: String = ""
    @State private var navigateToTopicSelection: Bool = false
    @State private var showWarning: Bool = false
    @State private var userID: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .padding(.top, 20)

                Text("Create a new")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("account")
                    .font(.title2)
                    .fontWeight(.bold)

                VStack(spacing: 15) {
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }

                if showWarning {
                    Text("Please fill in all fields before signing up.")
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Button(action: registerUser) {
                    Text("SIGN UP")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 10)

                Spacer()

                .navigationDestination(isPresented: $navigateToTopicSelection) {
                    if let userID = userID {
                        TopicSelectionView(userID: userID)
                    }
                }
            }
            .padding(20)
            .navigationBarBackButtonHidden(true)
        }
    }

    // Function to register the user in Firebase
    private func registerUser() {
        if name.isEmpty || password.isEmpty {
            showWarning = true
            return
        }

        showWarning = false
        let db = Firestore.firestore()
        let userRef = db.collection("users").document()
        let userData: [String: Any] = [
            "username": name,
            "password": password,
            "userProfileImage": userProfileImage,
            "topicTags": []
        ]

        userRef.setData(userData) { error in
            if let error = error {
                print("Error adding user: \(error)")
            } else {
                self.userID = userRef.documentID
                self.navigateToTopicSelection = true
            }
        }
    }
}


struct TopicSelectionView: View {
    var userID: String
    @State private var selectedTopics: [String: Bool] = [:]
    @State private var navigateToMainTab: Bool = false
    @State private var user: User?
    
    let topicOptions = ["Nature", "Music", "Technology", "Sports", "Art", "Science", "Gaming", "Travel", "Cooking", "Fitness"]
    @Environment(\.presentationMode) var presentationMode

    init(userID: String) {
        self.userID = userID
        _selectedTopics = State(initialValue: Dictionary(uniqueKeysWithValues: topicOptions.map { ($0, false) }))
    }

    var body: some View {
        NavigationStack{
            VStack {
                Text("Select Topics of Interest:")
                    .font(.headline)
                    .padding()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(topicOptions, id: \.self) { topic in
                            Toggle(topic, isOn: Binding(
                                get: { selectedTopics[topic] ?? false },
                                set: { selectedTopics[topic] = $0 }
                            ))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                Button("Continue") {
                    saveUserTopics()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            .navigationDestination(isPresented: $navigateToMainTab) {
                    if let user = user {
                        MainTabView(user: user)
                    }
            }
        }
    }

    private func saveUserTopics() {
        let selectedTopicsList = selectedTopics.filter { $0.value }.map { $0.key }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        
        userRef.updateData(["topicTags": selectedTopicsList]) { error in
            if let error = error {
                print("Error updating topics: \(error.localizedDescription)")
                return
            }
            
            // Fetch the user and navigate
            userRef.getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data() ?? [:]
                    let loadedUser = User(
                        username: data["username"] as? String ?? "",
                        password: data["password"] as? String ?? "",
                        userProfileImage: data["userProfileImage"] as? String ?? "",
                        topicTags: data["topicTags"] as? [String] ?? [],
                        posts: [] // posts are not needed right now
                    )
                    self.user = loadedUser
                    self.navigateToMainTab = true
                } else {
                    print("Error fetching user after topic selection: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}


