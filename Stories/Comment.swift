//
//  Comment.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/14/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit
import FirebaseDatabase

final class Comment: ListDiffable {
    
    let comment_id: String
    var user: User = User(user_id: "user_id", handlename: "loading", posts: 0, points: 0)
    let caption: String
    let timestamp: Double
    let date_created: Date
    let user_id: String
    
    init (snapshot: DataSnapshot) {
        self.comment_id = snapshot.key
        guard let snapshotValue = snapshot.value as? [String: Any] else { fatalError() }
        self.caption =  snapshotValue["caption"] != nil ? snapshotValue["caption"] as! String : "error"
        self.timestamp = snapshotValue["date_created"] != nil ? snapshotValue["date_created"] as! Double : 0
        self.date_created = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
        self.user_id = snapshotValue["user_id"] != nil ? snapshotValue["user_id"] as! String : "error"
    }
    
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return comment_id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let comment = object as? Comment else {
            return false
        }
        if comment.comment_id == self.comment_id {
            return true
        } else {
            return false
        }
    }
    
}
