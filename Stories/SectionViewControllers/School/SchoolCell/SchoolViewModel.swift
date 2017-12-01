//
//  SchoolViewModel.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/19/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit

final class SchoolViewModel: ListDiffable {
    
    let school_id: String
    let name: String
    let members: Int
    let points: Int
    let imageURL: URL
    let color: UIColor
    
    init(school_id: String, name: String, members: Int, points: Int, imageURL: URL, color: UIColor) {
        self.school_id = school_id
        self.name = name
        self.members = members
        self.points = points
        self.imageURL = imageURL
        self.color = color
    }
    
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return "SchoolCell" + school_id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? SchoolViewModel else { return false }
        return school_id == object.school_id
    }
    
}
