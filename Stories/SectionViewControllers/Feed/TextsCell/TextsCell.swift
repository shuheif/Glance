//
//  TextsCell.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/14/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import IGListKit

final class TextsCell: UICollectionViewCell, ListBindable {
    
    @IBOutlet weak var textArea: UITextView!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let size = contentView.systemLayoutSizeFitting(CGSize(width:  layoutAttributes.frame.width,
                                                              height: CGFloat.greatestFiniteMagnitude),
                                                       withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        layoutAttributes.frame.size = size
        return layoutAttributes
    }
    
    // MARK: ListBindable
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? TextsViewModel else { return }
        textArea.text = viewModel.caption
    }
    
}
