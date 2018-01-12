//
//  UserCell.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/15/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import IGListKit

class UserCell: UICollectionViewCell, ListBindable {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? UserViewModel else { return }
        usernameLabel.text = viewModel.username + " | " + viewModel.rank
        timeLabel.text = viewModel.timestamp
    }
}
