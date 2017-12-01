//
//  HomeViewModel.swift
//  Stories
//
//  Created by Shuhei Fujita on 11/1/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import Firebase

protocol HomePostsLoaderDelegate {
    func homePostsDidUpdate()
}


class HomePostsLoader {
    
    var delegate: HomePostsLoaderDelegate?
    
    var allPosts: [Double: Post] = [:] {
        didSet {
            delegate?.homePostsDidUpdate()
        }
    }
    
    var data: [Post] {
        let sortedDict = allPosts.sorted{ $0.key > $1.key }
        var array: [Post] = []
        for object in sortedDict {
            array.append(object.value)
        }
        return array
    }
    
    func connect() {
        loadAllPosts()
    }
    
    func loadAllPosts() {
        let postsRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.postsTable).queryOrdered(byChild: "date_created")
        
        postsRef.observe(.childAdded, with: { snapshot in
            let post = Post(snapshot: snapshot)
            let userRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.usersTable).child(post.user_id)
            userRef.observeSingleEvent(of: .value, with: { snapshot in
                let user = User(snapshot: snapshot)
                post.user = user
                self.allPosts[post.timestamp] = post
            })
        })
        
        postsRef.observe(.childChanged, with: { snapshot in
            let post = Post(snapshot: snapshot)
            let userRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id).child(TableNameStruct.usersTable).child(post.user_id)
            userRef.observeSingleEvent(of: .value, with: { snapshot in
                let user = User(snapshot: snapshot)
                post.user = user
                self.allPosts[post.timestamp] = post
            })
        })
    }
    
    /*
     Used manually.
    */
    func createSchool(name: String, email: String) {
        let school: [String: Any] = ["name": name,
                                     "email": email,
                                     "points": 0,
                                     "num_members": 0]
        let schoolRef = Database.database().reference().child("schools")
        schoolRef.childByAutoId().setValue(school)
    }
}
