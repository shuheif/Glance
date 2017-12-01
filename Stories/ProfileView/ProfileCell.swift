//
//  ProfileCell.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/21/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    func setContents(user: User?, schoolName: String) {
        usernameLabel.text = user != nil ? user!.handlename : "loading"
        collegeLabel.text = schoolName
        postsLabel.text = user != nil ? String(user!.posts) : String(0)
        pointsLabel.text = user != nil ? String(user!.points) : String(0)
        rankLabel.text = user != nil ? user!.rank : "member"
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/glance-88491.appspot.com/o/school_photos%2FBeloit%20College%2Fbeloit_b_sm.png?alt=media&token=82aab22b-f86e-4158-bec3-87ecbfa2be28")!
        profileImage.sd_setImage(with: url, completed: nil)
    }
}
