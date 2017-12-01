//
//  User.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/21/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class User {
    
    let user_id: String
    let handlename: String
    let posts: Int
    let points: Int
    let rank: String
    
    init(snapshot: DataSnapshot) {
        self.user_id = snapshot.key
        guard let snapshotValue = snapshot.value as? [String: Any] else { fatalError() }
        self.handlename = snapshotValue["handlename"] != nil ? snapshotValue["handlename"] as! String : "error"
        self.points = snapshotValue["points"] != nil ? snapshotValue["points"] as! Int : -99
        self.posts = snapshotValue["posts"] != nil ? snapshotValue["posts"] as! Int : -99
        self.rank = "---"
    }
    
    init(user_id: String, handlename: String, posts: Int, points: Int) {
        self.user_id = user_id
        self.handlename = handlename
        self.posts = posts
        self.points = points
        self.rank = "King"
    }
}
