//
//  SchoolCell.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/19/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import IGListKit
import SDWebImage

class SchoolCell: UICollectionViewCell, ListBindable {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? SchoolViewModel else { return }
        nameLabel.text = viewModel.name
        membersLabel.text = String(viewModel.members)
        //pointsLabel.text = String(viewModel.points)
        pointsLabel.text = "---"
        nameLabel.textColor = viewModel.color
        membersLabel.textColor = viewModel.color
        pointsLabel.textColor = viewModel.color
        imageView.sd_setImage(with: viewModel.imageURL)
    }

}
