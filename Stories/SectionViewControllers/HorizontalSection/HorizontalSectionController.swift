//
//  HorizontalSectionController.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/20/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit

final class HorizontalSectionController: ListBindingSectionController<Trendings>, ListBindingSectionControllerDataSource,  ListAdapterDataSource {
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    override init() {
        super.init()
        dataSource = self
    }
    
    // MARK: ListBindingSectionControllerDataSource
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? Trendings else { fatalError() }
        
        return [HorizontalViewModel(school_id: object.school_id)]
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        let height: CGFloat = 150
        return CGSize(width: width, height: height)
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        
        let nib: String = "HorizontalCell"
        guard let cell: HorizontalCell = collectionContext?.dequeueReusableCell(withNibName: nib, bundle: nil, for: self, at: index) as? HorizontalCell else { fatalError() }
        cell.collectionView.collectionViewLayout = ListCollectionViewLayout(stickyHeaders: false, scrollDirection: .horizontal, topContentInset: 0, stretchToEdge: false)
        adapter.collectionView = cell.collectionView
        return cell as UICollectionViewCell & ListBindable
    }
    
    // MARK: ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let trendings = object else { fatalError() }
        return trendings.trendingPosts
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return TrendingSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let label = UILabel(frame: CGRect(x: 100, y: 0, width: 200, height: 50))
        label.text = "Coming soon!"
        label.textColor = UIColor.lightGray
        return label
    }
    
    func performUpdate() {
        adapter.performUpdates(animated: true, completion: nil)
    }
}

