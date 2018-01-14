//
//  PostViewModel.swift
//  Stories
//
//  Created by Shuhei Fujita on 11/1/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

protocol PostViewModelDelegate {
    func userInfoDidUpdate(user: User)
}
class PostViewModel {
    
    var delegate: PostViewModelDelegate?
    private var user: User?
    
    init() {    }
    
    func loadUserInfo() {
        let uid = Auth.auth().currentUser!.uid
        let userRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.usersTable).child(uid)
        userRef.observe(.value, with: { snapshot in
            let user = User(snapshot: snapshot)
            self.user = user
            self.delegate?.userInfoDidUpdate(user: user)
        })
    }
    
    /*
     Saves a post in the database.
     */
    func post(caption: String, imageURL: String?) {
        
        let uid = Auth.auth().currentUser!.uid
        
        let rootRef = Database.database().reference()
        let dataRef = rootRef.child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id)
        let postRef = dataRef.child(TableNameStruct.postsTable)
        let newPost = postRef.childByAutoId()
        let post: [String: Any] = ["caption": caption,
                                   "date_created": ServerValue.timestamp(),
                                   "points": 0,
                                   "comments": 0,
                                   "post_id": newPost.key,
                                   "user_id": uid]
        newPost.setValue(post)
        
        let userRef = dataRef.child("users").child(uid)
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            let user = User(snapshot: snapshot)
            let currentPoints = user.points
            userRef.child("points").setValue(currentPoints + 3)
            let currentPosts = user.posts
            userRef.child("posts").setValue(currentPosts + 1)
        })
        
        if imageURL != nil {
            let storageRef = Storage.storage().reference()
            let userStorageRef = storageRef.child("photos").child("users").child(uid)
            let imageRef = userStorageRef.child(UUID().uuidString)
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            let url = URL(fileURLWithPath: imageURL!)
            do {
                let imageData = try Data(contentsOf: url)
                imageRef.putData(imageData, metadata: metaData, completion: { metadata, error in
                    guard let metaData = metadata else {
                        print("error")
                        return
                    }
                    let url = metaData.downloadURL()!.absoluteString
                    newPost.updateChildValues(["image_path": url])
                })
            } catch {
                print("temp data fetch error")
                return
            }
        }
    }
}
