//
//  HomeViewController.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/1/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import IGListKit
import Firebase

class HomeViewController: UIViewController {
    
    var selectedPost: Post? = nil
    let homePostsLoader = HomePostsLoader()
    
    var data = [ListDiffable]()
    lazy var adapter: ListAdapter = { return ListAdapter(updater: ListAdapterUpdater(), viewController: self) }()
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {}
    @IBAction func composeButtonPushed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "HomeToPostSegue", sender: self)
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Beloit College"
        
        homePostsLoader.delegate = self
        homePostsLoader.connect()
        
        adapter.dataSource = self
        adapter.collectionView = collectionView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToDetailSegue" {
            if let navigationController = segue.destination as? UINavigationController {
                if let detailVC = navigationController.viewControllers.first as? DetailViewController {
                    detailVC.post_id = selectedPost?.post_id
                    detailVC.owner_id = selectedPost?.user_id
                }
            }
        }
    }
}


extension HomeViewController: ListBindingSectionControllerSelectionDelegate {
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didSelectItemAt index: Int, viewModel: Any) {
        if let controller = sectionController as? ListBindingSectionController<Post> {
            selectedPost = controller.object
        }
        performSegue(withIdentifier: "HomeToDetailSegue", sender: self)
    }
}


extension HomeViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return homePostsLoader.data as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Trendings {
            let horizontalSectionController = HorizontalSectionController()
            return horizontalSectionController
        } else {
            return PostSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


extension HomeViewController: HomePostsLoaderDelegate {
    
    func homePostsDidUpdate() {
        adapter.performUpdates(animated: true, completion: nil)
    }
}
