//
//  TrendingPostCell.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/19/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import SDWebImage
import IGListKit

class TrendingPostCell: UICollectionViewCell, ListBindable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 1.0
        imageView.clipsToBounds = false
    }

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? TrendingPostViewModel else { return }
        textView.text = viewModel.caption
        if viewModel.image_path != nil {
            imageView.sd_setImage(with: viewModel.image_path!)
        } else {
            imageView.backgroundColor = UIColor.random()
        }
    }
}
