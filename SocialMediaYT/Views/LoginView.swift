//
//  LoginView.swift
//  SocialMediaYT
//
//  Created by user270092 on 3/6/25.
//

import SwiftUI
import FirebaseFirestore

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var navigateToHome: Bool = false
    @State private var errorMessage: String?
    @State private var authenticatedUser: User?

    var body: some View {
        //NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 40)
                    .foregroundColor(.blue)

                Text("Welcome to")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("VidConnect")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)

                VStack(alignment: .leading) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Button(action: authenticateUser) {
                    Text("SIGN IN")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)

                HStack {
                    Text("Not A Member?")
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .foregroundColor(.purple)
                            .fontWeight(.bold)
                    }
                }
                .font(.footnote)
            }
            .padding()
            .navigationDestination(isPresented: $navigateToHome) {
            //.fullScreenCover(isPresented: $navigateToHome){
                if let authenticatedUser = authenticatedUser {
                    //HomeView(user: authenticatedUser)
                    MainTabView(user: authenticatedUser)
                }
            }
        }
    //}

    private func authenticateUser() {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in
                if let error = error {
                    errorMessage = "Error checking credentials: \(error.localizedDescription)"
                    return
                }

                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    errorMessage = "Invalid username or password."
                    return
                }

                for document in documents {
                    let data = document.data()
                    if let storedPassword = data["password"] as? String, storedPassword == password {
                        let user = User(
                            username: username,
                            password: storedPassword,
                            userProfileImage: data["userProfileImage"] as? String ?? "",
                            topicTags: data["topicTags"] as? [String] ?? [],
                            posts: [] // Load user posts separately if needed
                        )
                        self.authenticatedUser = user
                        self.navigateToHome = true
                        return
                    }
                }

                errorMessage = "Invalid username or password."
            }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
