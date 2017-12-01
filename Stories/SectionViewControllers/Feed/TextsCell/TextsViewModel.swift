//
//  TextsViewModel.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/14/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit

final class TextsViewModel: ListDiffable {
    
    let caption: String
    
    init(caption: String) {
        self.caption = caption
    }
    
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return "caption" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? TextsViewModel else  { return false }
        return caption == object.caption
    }
    
}
