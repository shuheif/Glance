//
//  CommunityViewController.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/5/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import IGListKit

class CommunityViewController: UIViewController {

    let communityLoader = CommunityLoader()
    var horizontalController: HorizontalSectionController?
    
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var adapter: ListAdapter = { return ListAdapter(updater: ListAdapterUpdater(), viewController: self) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Community"
        
        communityLoader.delegate = self
        communityLoader.connect()
        
        adapter.dataSource = self
        collectionView.collectionViewLayout = ListCollectionViewLayout(stickyHeaders: false, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: false)
        adapter.collectionView = collectionView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension CommunityViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return communityLoader.data as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is School {
            return SchoolSectionController()
        } else {
            horizontalController = HorizontalSectionController()
            return horizontalController!
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


extension CommunityViewController: CommunityLoaderDelegate {
    func trendingUpdate(school_id: String) {
        horizontalController!.performUpdate()
    }
    
    
    func dataDidUpdate() {
        adapter.performUpdates(animated: true, completion: nil)
    }
}
