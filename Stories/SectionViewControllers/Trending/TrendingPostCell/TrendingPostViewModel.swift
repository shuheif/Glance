//
//  TrendingPostViewModel.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/20/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit

final class TrendingPostViewModel: ListDiffable {
    
    let post_id: String
    let caption: String
    let image_path: URL?
    
    init(post_id: String, caption: String, image_path: URL?) {
        self.post_id = post_id
        self.caption = caption
        if image_path == nil {
            self.image_path = nil
        } else {
            self.image_path = image_path
        }
    }
    
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return "TrendingPostCell" + post_id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? TrendingPostViewModel else { return false }
        return post_id == object.post_id
    }
    
}
