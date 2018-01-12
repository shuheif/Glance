//
//  PostSectionController.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/14/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit
import Firebase

final class PostSectionController: ListBindingSectionController<Post>, ListBindingSectionControllerDataSource {
    
    override init() {
        super.init()
        dataSource = self
        self.inset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        if let viewController = self.viewController as? HomeViewController {
            self.selectionDelegate = viewController
        }
    }
    
    // MARK: ListBindingSectionControllerDataSource
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? Post else { fatalError() }
        var results: [ListDiffable] = [UserViewModel(username: object.user.handlename, rank: object.user.rank, date_created: object.date_created)]
        if object.image_path != nil {
            results.append(ImageViewModel(url: object.image_path!))
        }
        results.append(TextsViewModel(caption: object.caption))
        results.append(ActionViewModel(likes: object.likes, downs: object.downs, comments: object.num_comments, haveUpvoted: object.haveUpvoted, haveDownvoted: object.haveDownvoted))
 
        return results + object.comments
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        let height: CGFloat
        switch viewModel {
        case is UserViewModel: height = 30
        case is TextsViewModel: height = textCellHeight(contents: object!.caption, width: width)
        case is ImageViewModel: height = 250
        case is ActionViewModel: height = 35
        case is Comment: height = textCellHeight(contents: object!.caption, width: width) > 50 ? textCellHeight(contents: object!.caption, width: width) + 7 : 50
        default: height = 50
        }
        return CGSize(width: width, height: height)
    }

    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        
        let nib: String
        switch viewModel {
        case is ImageViewModel: nib = "ImageCell"
        case is Comment: nib = "CommentCell"
        case is UserViewModel: nib = "UserCell"
        case is TextsViewModel: nib = "TextsCell"
        default: nib = "ActionCell"
        }
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: nib, bundle: nil, for: self, at: index) else { fatalError() }
        
        if cell is ActionCell {
            (cell as! ActionCell).delegate = self
        }
        return cell as! UICollectionViewCell & ListBindable
    }
    
    private func textCellHeight(contents: String, width: CGFloat) -> CGFloat{
        let numLines = ceil(Double(contents.count / 40))
        return CGFloat(numLines * 20 + 35)
    }
}


extension PostSectionController: ActionCellDelegate {
    
    func didTapLikeButton(cell: ActionCell) {
        let uid = Auth.auth().currentUser!.uid
        let schoolRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id)
        let upvotesRef = schoolRef.child(TableNameStruct.upvotesTable).child(uid)
        let ownerRef = schoolRef.child(TableNameStruct.usersTable).child(object!.user_id)
        let postsRef = schoolRef.child(TableNameStruct.postsTable).child(object!.post_id)
        
        if !object!.haveUpvoted {
            //Submits upvote & increment one points
            // For Lit
            upvotesRef.child(object!.post_id).setValue(true)
            //For each posts
            postsRef.child(TableNameStruct.upvotesInPosts).child(uid).setValue(true)
            //Increment one point for owner
            ownerRef.observeSingleEvent(of: .value, with: { snapshot in
                let user = User(snapshot: snapshot)
                let currentPoints = user.points
                ownerRef.child("points").setValue(currentPoints + 1)
            })
            //Increment one point for the post
            postsRef.observeSingleEvent(of: .value, with: { snapshot in
                let post = Post(snapshot: snapshot)
                let currentPoints = post.points
                postsRef.child("points").setValue(currentPoints + 1)
            })
        } else {
            //Deletes upvote & decrement one point
            // For Lit
            upvotesRef.child(object!.post_id).removeValue()
            // For each posts
            postsRef.child(TableNameStruct.upvotesInPosts).child(uid).removeValue()
            //Decrement one point for owner
            ownerRef.observeSingleEvent(of: .value, with: { snapshot in
                let user = User(snapshot: snapshot)
                let currentPoints = user.points
                ownerRef.child("points").setValue(currentPoints - 1)
            })
            //Decrement one point for the post
            postsRef.observeSingleEvent(of: .value, with: { snapshot in
                let post = Post(snapshot: snapshot)
                let currentPoints = post.points
                postsRef.child("points").setValue(currentPoints - 1)
            })
        }
        if object!.haveDownvoted {
            //Deletes downvote
            postsRef.child(TableNameStruct.downvotesInPosts).child(uid).removeValue()
            //Increment one point for owner
            ownerRef.observeSingleEvent(of: .value, with: { snapshot in
                let user = User(snapshot: snapshot)
                let currentPoints = user.points
                ownerRef.child("points").setValue(currentPoints + 1)
            })
        }
    }
    
    func didTapDislikeButton(cell: ActionCell) {
        let uid = Auth.auth().currentUser!.uid
        let schoolRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id)
        let postsRef = schoolRef.child(TableNameStruct.postsTable).child(object!.post_id)
        let upvotesRef = schoolRef.child(TableNameStruct.upvotesTable).child(uid)
        if !object!.haveDownvoted {
            // Submits downvote
            postsRef.child(TableNameStruct.downvotesInPosts).child(uid).setValue(true)
            //Decrement one point for the post
            postsRef.observeSingleEvent(of: .value, with: { snapshot in
                let post = Post(snapshot: snapshot)
                let currentPoints = post.points
                postsRef.child("points").setValue(currentPoints - 1)
            })
        } else {
            // Deletes downvote
            postsRef.child(TableNameStruct.downvotesInPosts).child(uid).removeValue()
            //Increment one point for the post
            postsRef.observeSingleEvent(of: .value, with: { snapshot in
                let post = Post(snapshot: snapshot)
                let currentPoints = post.points
                postsRef.child("points").setValue(currentPoints + 1)
            })
        }
        if object!.haveUpvoted {
            //Deletes upvote
            postsRef.child(TableNameStruct.upvotesInPosts).child(uid).removeValue()
            upvotesRef.child(object!.post_id).removeValue()
            //Decrement one point for the post
            postsRef.observeSingleEvent(of: .value, with: { snapshot in
                let post = Post(snapshot: snapshot)
                let currentPoints = post.points
                postsRef.child("points").setValue(currentPoints - 1)
            })
        }
    }
}
