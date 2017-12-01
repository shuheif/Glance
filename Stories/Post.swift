//
//  Post.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/14/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit
import FirebaseDatabase

final class Post: ListDiffable {
    
    let post_id: String
    let date_created: Date
    let timestamp: Double
    let caption: String
    let image_path: URL?
    let likes: Int
    let downs: Int
    let num_comments: Int
    let points: Int
    var comments: [Comment] = []
    let user_id: String
    var user: User = User(user_id: "user_id", handlename: "loading", posts: 0, points: 0)
    var haveUpvoted: Bool = false
    var haveDownvoted: Bool = false
    
    init (snapshot: DataSnapshot) {
        
        self.post_id = snapshot.key
        guard let snapshotValue = snapshot.value as? [String: Any] else { fatalError() }
        self.caption =  snapshotValue["caption"] != nil ? snapshotValue["caption"] as! String : "error"
        self.timestamp = snapshotValue["date_created"] != nil ? snapshotValue["date_created"] as! Double : 0
        self.date_created = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
        self.image_path = snapshotValue["image_path"] != nil ? URL(string: snapshotValue["image_path"] as! String)! : nil
        self.num_comments = snapshotValue["comments"] != nil ? snapshotValue["comments"] as! Int : -99
        self.points = snapshotValue["points"] != nil ? snapshotValue["points"] as! Int : -99
        self.user_id = snapshotValue["user_id"] != nil ? snapshotValue["user_id"] as! String : "error"
        
        if snapshotValue[TableNameStruct.upvotesInPosts] != nil {
            let upvotedUsers = snapshotValue[TableNameStruct.upvotesInPosts] as! NSDictionary
            self.likes = upvotedUsers.count
            if upvotedUsers.value(forKey: user_id) != nil {
                self.haveUpvoted = true
            }
        } else {
            self.likes = 0
        }
        
        if snapshotValue[TableNameStruct.downvotesInPosts] != nil {
            let downvotedUsers = snapshotValue[TableNameStruct.downvotesInPosts] as! NSDictionary
            self.downs = downvotedUsers.count
            if downvotedUsers.value(forKey: user_id) != nil {
                self.haveDownvoted = true
            }
        } else {
            self.downs = 0
        }
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return "Post" + String(post_id) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        
        guard let post = object as? Post else {
            return false
        }
        if post.post_id == self.post_id {
            return true
        } else {
            return false
        }
    }
}
