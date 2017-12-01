//
//  School.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/19/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit
import Firebase

final class School: ListDiffable {
    
    let school_id: String
    let name: String
    let imageURL: URL
    let members: Int
    let points: Int
    let color: UIColor
    
    init(snapshot: DataSnapshot) {
        self.school_id = snapshot.key
        guard let snapshotValue = snapshot.value as? [String: Any] else { fatalError() }
        
        self.name = snapshotValue["name"] != nil ? snapshotValue["name"] as! String : "error"
        self.members = snapshotValue["num_members"] != nil ? snapshotValue["num_members"] as! Int : -99
        self.points = snapshotValue["points"] != nil ? snapshotValue["points"] as! Int : -99
        let hex = snapshotValue["color"] != nil ? snapshotValue["color"] as! String : "000000"
        self.color = UIColor(hex: hex)
        self.imageURL = URL(string: "https://yt3.ggpht.com/-Cbp1OF_NviQ/AAAAAAAAAAI/AAAAAAAAAAA/Sq7fexyvxrw/s288-c-k-no-mo-rj-c0xffffff/photo.jpg")!
    }
    
    init(school_id: String, name: String, imageURL: URL, members: Int, points: Int, hex: String) {
        self.school_id = school_id
        self.name = name
        self.imageURL = imageURL
        self.members = members
        self.points = points
        self.color = UIColor.blue//use hex
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return school_id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let school = object as? School else {
            return false
        }
        if school.school_id == self.school_id {
            return true
        } else {
            return false
        }
    }
}
