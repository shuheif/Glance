//
//  DetailLoader.swift
//  Stories
//
//  Created by Shuhei Fujita on 11/4/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import Firebase

protocol DetailLoaderDelegate {
    func postChanged()
    func commentsChanged()
}

class DetailLoader {
    
    var delegate: DetailLoaderDelegate?
    
    var data: [Post] {
        if post != nil {
            post!.comments = sortedComents
            return [post!]
        } else {
            return []
        }
    }
    
    var post: Post? {
        didSet {
            delegate?.postChanged()
        }
    }
    
    var comments: [String: Comment] = [:] {
        didSet {
            delegate?.commentsChanged()
        }
    }
    
    var sortedComents: [Comment] {
        let sortedDict = self.comments.sorted { $0.value.timestamp < $1.value.timestamp }
        var array: [Comment] = []
        for object in sortedDict {
            array.append(object.value)
        }
        return array
    }
    
    func connect(post_id: String) {
        loadPost(post_id: post_id)
        loadComments(post_id: post_id)
    }
    
    func loadPost(post_id: String) {
        let postRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.postsTable).child(post_id)
        
        postRef.observe(.value, with: { snapshot in
            let postSnap = Post(snapshot: snapshot)
            let userRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.usersTable).child(postSnap.user_id)
            userRef.observeSingleEvent(of: .value, with: { snapshot in
                let user = User(snapshot: snapshot)
                postSnap.user = user
                self.post = postSnap
            })
        })
    }
    
    func loadComments(post_id: String) {
        let commentsRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.commentsTable).child(post_id)
        
        commentsRef.observe(.childAdded, with: { snapshot in
            let commentSnap = Comment(snapshot: snapshot)
            let userRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.usersTable).child(commentSnap.user_id)
            userRef.observeSingleEvent(of: .value, with: { snapshot in
                let user = User(snapshot: snapshot)
                commentSnap.user = user
                self.comments[commentSnap.comment_id] = commentSnap
            })
        })
        
        commentsRef.observe(.childChanged, with: { snapshot in
            let commentSnap = Comment(snapshot: snapshot)
            let userRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.usersTable).child(commentSnap.user_id)
            userRef.observeSingleEvent(of: .value, with: { snapshot in
                let user = User(snapshot: snapshot)
                commentSnap.user = user
                self.comments[commentSnap.comment_id] = commentSnap
            })
        })
    }
}
