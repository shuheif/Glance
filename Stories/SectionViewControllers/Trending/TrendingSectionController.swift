//
//  TrendingSectionController.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/20/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit

final class TrendingSectionController: ListBindingSectionController<Post>, ListBindingSectionControllerDataSource {
    
    override init() {
        super.init()
        dataSource = self
        self.inset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }
    
    // MARK: ListBindingSectionControllerDataSource
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? Post else { fatalError() }
        let results: [ListDiffable]
        
        results = [TrendingPostViewModel(post_id: object.post_id, caption: object.caption, image_path: object.image_path)]
        
        return results
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        
        let width: CGFloat = 200
        let height: CGFloat = 130
        return CGSize(width: width, height: height)
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        
        let nib: String = "TrendingPostCell"
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: nib, bundle: nil, for: self, at: index) else { fatalError() }
        return cell as! UICollectionViewCell & ListBindable
    }
}
