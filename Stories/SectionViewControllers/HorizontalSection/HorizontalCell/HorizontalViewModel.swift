//
//  HorizontalViewModel.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/19/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit

final class HorizontalViewModel: ListDiffable {
    
    let school_id: String
    
    init(school_id: String) {
        self.school_id = school_id
    }
    
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return "HorizontalCell" + school_id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? HorizontalViewModel else { return false }
        return school_id == object.school_id
    }
    
}
