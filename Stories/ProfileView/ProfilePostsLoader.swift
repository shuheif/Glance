//
//  ProfilePostsLoader.swift
//  Stories
//
//  Created by Shuhei Fujita on 11/2/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import Firebase

protocol ProfilePostsLoaderDelegate {
    func userPostsDidUpdate()
    func userInfoDidUpdate(user: User)
    func litpostsDidUpdate()
}

class ProfilePostsLoader {
    
    var delegate: ProfilePostsLoaderDelegate?
    
    var userPosts: [Double: Post] = [:] {
        didSet {
            delegate?.userPostsDidUpdate()
        }
    }
    
    var litPosts: [Double: Post] = [:] {
        didSet {
            delegate?.litpostsDidUpdate()
        }
    }
    
    private var user: User?
    
    var userPostsData: [Post] {
        let sortedDict = userPosts.sorted{ $0.key > $1.key }
        var array: [Post] = []
        for object in sortedDict {
            array.append(object.value)
        }
        return array
    }
    
    var litPostsData: [Post] {
        let sortedDict = litPosts.sorted{ $0.key > $1.key }
        var array: [Post] = []
        for object in sortedDict {
            array.append(object.value)
        }
        return array
    }
    
    var litPostsKey: [String: Bool] = [:] {
        didSet {
            loadLitPosts()
        }
    }
    
    func connect() {
        loadUserInfo()// Calls loadUserPosts()
        loadLitKeys()
    }
    
    func loadUserPosts() {
        let uid = Auth.auth().currentUser!.uid
        let postsRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.postsTable).queryOrdered(byChild: "user_id").queryEqual(toValue: uid)
        
        postsRef.observe(.childAdded, with: { snapshot in
            let post = Post(snapshot: snapshot)
            if self.user != nil {
                post.user = self.user!
            }
            self.userPosts[post.timestamp] = post
        })
        
        postsRef.observe(.childChanged, with: { snapshot in
            let post = Post(snapshot: snapshot)
            if self.user != nil {
                post.user = self.user!
            }
            self.userPosts[post.timestamp] = post
        })
    }
    
    func loadUserInfo() {
        let uid = Auth.auth().currentUser!.uid
        let userRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.usersTable).child(uid)
        userRef.observe(.value, with: { snapshot in
            let user = User(snapshot: snapshot)
            self.user = user
            self.loadUserPosts()
            self.delegate?.userInfoDidUpdate(user: user)
        })
    }
    
    func loadLitKeys() {
        let uid = Auth.auth().currentUser!.uid
        let schoolRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id)
        let upvotesRef = schoolRef.child(TableNameStruct.upvotesTable).child(uid)
        
        upvotesRef.observe(.childAdded, with: { snapshot in
            let post_id = snapshot.key
            self.litPostsKey[post_id] = true
        })
        
        upvotesRef.observe(.childChanged, with: { snapshot in
            let post_id = snapshot.key
            self.litPostsKey[post_id] = true
        })
        
        upvotesRef.observe(.childRemoved, with: { snapshot in
            let post_id = snapshot.key
            self.litPostsKey.removeValue(forKey: post_id)
        })
    }
    
    func loadLitPosts() {
        let postsRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.postsTable)
        let usersRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.usersTable)
        for key in litPostsKey.keys {
            let postRef = postsRef.child(key)
            postRef.observe(.value, with: { snapshot in
                let post = Post(snapshot: snapshot)
                
                let userRef = usersRef.child(post.user_id)
                userRef.observe(.value, with: { snapshot in
                    let user = User(snapshot: snapshot)
                    post.user = user
                    self.litPosts[post.timestamp] = post
                    self.delegate?.litpostsDidUpdate()
                })
            })
        }
    }
}
