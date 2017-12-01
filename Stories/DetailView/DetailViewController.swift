//
//  DetailViewController.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/22/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import IGListKit
import Firebase

class DetailViewController: UIViewController {

    var post_id: String?
    var owner_id: String?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let detailLoader = DetailLoader()
    lazy var adapter: ListAdapter = { return ListAdapter(updater: ListAdapterUpdater(), viewController: self) }()
    
    @IBOutlet weak var inputContainerView: UIView!
    var bottomConstraint: NSLayoutConstraint?
    
    @IBAction func postButtonPushed(_ sender: UIButton) {
        textField.endEditing(true)
        if !textField.text!.isEmpty {
            postComment(post_id: post_id!, caption: textField.text!, owner_id: owner_id!)
        }
        textField.text = ""
    }
    
    @IBAction func cancelButtonPushed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        if let view = UINib(nibName: "DetailViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailLoader.delegate = self
        detailLoader.connect(post_id: post_id!)

        bottomConstraint = NSLayoutConstraint(item: inputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
        
        collectionView.keyboardDismissMode = .onDrag
        adapter.dataSource = self
        collectionView?.backgroundColor = UIColor.lightGray
        adapter.collectionView = collectionView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bottomConstraint?.constant = 343
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleKeyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardScreenEndFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    if isKeyboardShowing {
                        //let lastIndex = IndexPath(row: <#T##Int#>, section: <#T##Int#>)
                        //collectionView.scrollToItem(at: lastIndex, at: .bottom, animated: true)
                    }
            })
        }
    }
    
    func postComment(post_id: String, caption: String, owner_id: String) {
        let uid = Auth.auth().currentUser!.uid
        let comment = ["caption": caption,
                       "date_created": ServerValue.timestamp(),
                       "user_id": uid] as [String : Any]
        let schoolRef = Database.database().reference().child(TableNameStruct.dataTable).child(TableNameStruct.beloit_id)
        let commentsRef = schoolRef.child(TableNameStruct.commentsTable)
        commentsRef.child(post_id).childByAutoId().setValue(comment)
        let postRef = schoolRef.child("posts").child(post_id)
        postRef.observeSingleEvent(of: .value, with: { snapshot in
            let post = Post(snapshot: snapshot)
            let num_comment = post.num_comments
            let currentPoints = post.points
            postRef.child("comments").setValue(num_comment + 1)
            postRef.child("points").setValue(currentPoints + 1)
        })
        let currentUserRef = schoolRef.child("users").child(uid)
        currentUserRef.observeSingleEvent(of: .value, with: { snapshot in
            let user = User(snapshot: snapshot)
            let points = user.points
            currentUserRef.child("points").setValue(points + 2)
        })
        let ownerRef = schoolRef.child("users").child(owner_id)
        ownerRef.observeSingleEvent(of: .value, with: { snapshot in
            let user = User(snapshot: snapshot)
            let points = user.points
            currentUserRef.child("points").setValue(points + 2)
        })
    }
}


extension DetailViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return detailLoader.data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PostSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


extension DetailViewController: DetailLoaderDelegate {
    func postChanged() {
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    func commentsChanged() {
        // Has an issue when people change the contents of the comment, which is not the case for the first version.
        adapter.reloadData(completion: nil)
    }
}
