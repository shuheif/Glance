//
//  ImageCell.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/14/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import IGListKit
import SDWebImage

final class ImageCell: UICollectionViewCell, ListBindable {

    @IBOutlet weak var imageView: UIImageView!
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ImageViewModel else { return }
        imageView.sd_setImage(with: viewModel.url)
    }

}
