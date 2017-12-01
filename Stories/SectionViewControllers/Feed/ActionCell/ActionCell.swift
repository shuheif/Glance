//
//  ActionCell.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/14/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import IGListKit
import FaveButton

final class ActionCell: UICollectionViewCell, ListBindable {
    
    weak var delegate: ActionCellDelegate? = nil
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: FaveButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var reportButton: FaveButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBAction func likeButtonPushed(_ sender: FaveButton) {
        if reportButton.isSelected {
            reportButton.isSelected = false
        }
        delegate?.didTapLikeButton(cell: self)
    }
    
    @IBAction func reportButtonPushed(_ sender: UIButton) {
        delegate?.didTapDislikeButton(cell: self)
    }
    
    // MARK: ListBindable
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ActionViewModel else { return }
        likesLabel.text = String(viewModel.likes)
        commentLabel.text = String(viewModel.comments)
        likeButton.isSelected = viewModel.haveUpvoted
        reportButton.isSelected = viewModel.haveDownvoted
    }
}

protocol ActionCellDelegate: class {
    func didTapLikeButton(cell: ActionCell)
    func didTapDislikeButton(cell: ActionCell)
}
