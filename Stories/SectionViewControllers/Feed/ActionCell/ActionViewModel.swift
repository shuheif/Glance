//
//  ActionViewModel.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/14/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit

final class ActionViewModel: ListDiffable {
    
    let likes: Int
    let downs: Int
    let comments: Int
    var haveUpvoted: Bool
    var haveDownvoted: Bool
    
    init(likes: Int, downs: Int, comments: Int, haveUpvoted: Bool, haveDownvoted: Bool) {
        self.likes = likes
        self.downs = downs
        self.comments = comments
        self.haveUpvoted = haveUpvoted
        self.haveDownvoted = haveDownvoted
    }
    
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return "action" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ActionViewModel else { return false }
        return likes == object.likes && comments == object.comments && downs == object.downs
    }
    
}
