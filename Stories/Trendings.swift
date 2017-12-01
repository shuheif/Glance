//
//  Trendings.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/20/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit

final class Trendings: ListDiffable {
    
    let school_id: String
    var trendingPosts: [Post]
    
    init(school_id: String, trendingPosts: [Post]) {
        self.school_id = school_id
        self.trendingPosts = trendingPosts
    }
    
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return "Trendings" + school_id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Trendings else {
            return false
        }
        if object.school_id == self.school_id {
            return true
        } else {
            return false
        }
    }
    
}
