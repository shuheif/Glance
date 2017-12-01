//
//  CommunityLoader.swift
//  Stories
//
//  Created by Shuhei Fujita on 11/2/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import Firebase
import IGListKit

protocol CommunityLoaderDelegate {
    func dataDidUpdate()
    func trendingUpdate(school_id: String)
}

class CommunityLoader {
    
    var delegate: CommunityLoaderDelegate?
    
    var schools: [String: School] = [:] {
        didSet {
            for school in schools {
                let school_id = school.value.school_id
                data.append(school.value)
                // Only fetch Beloit trendings
                if school_id == TableNameStruct.beloit_id {
                    data.append(Trendings(school_id: school_id, trendingPosts: []))
                    loadTrendPosts(school_id: school_id)
                }
            }
            delegate?.dataDidUpdate()
        }
    }
    
    var data: [ListDiffable] = []
    
    func connect() {
        loadSchools()//Triggers loadTrendings
    }
    
    func loadSchools() {
        let schoolsRef = Database.database().reference().child(TableNameStruct.schoolsTable)
        
        schoolsRef.observe(.childAdded, with: { snapshot in
            let school = School(snapshot: snapshot)
            self.schools[school.school_id] = school
        })
        
        schoolsRef.observe(.childChanged, with: { snapshot in
            let school = School(snapshot: snapshot)
            self.schools[school.school_id] = school
        })
    }
    
    func loadTrendPosts(school_id: String) {
        var posts: [Post] = []
        let postsRef = Database.database().reference().child(TableNameStruct.dataTable).child(school_id).child(TableNameStruct.postsTable)
        
        postsRef.queryOrdered(byChild: "points").queryLimited(toLast: 5).observe(.childAdded, with: { snapshot in
            let post = Post(snapshot: snapshot)
            posts.append(post)
            if posts.count == 5 {
                self.addToData(school_id: school_id, posts: posts)
            }
        })
    }
    
    func addToData(school_id: String, posts: [Post]) {
        for object in data {
            if let trendings = object as? Trendings {
                if trendings.school_id == school_id {
                    trendings.trendingPosts = posts
                }
            }
        }
        delegate?.trendingUpdate(school_id: school_id)
    }
}
