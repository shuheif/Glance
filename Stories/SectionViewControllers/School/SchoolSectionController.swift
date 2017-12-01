//
//  SchoolSectionController.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/19/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import Foundation
import IGListKit

final class SchoolSectionController: ListBindingSectionController<Post>, ListBindingSectionControllerDataSource {
    
    override init() {
        super.init()
        dataSource = self
        self.inset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: ListBindingSectionControllerDataSource
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? School else { fatalError() }
        
        return [SchoolViewModel(school_id: object.school_id, name: object.name, members: object.members, points: object.points, imageURL: object.imageURL, color: object.color)]
        
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        let height: CGFloat = 100// SchoolViewModel
        
        return CGSize(width: width, height: height)
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        
        let nib: String = "SchoolCell"
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: nib, bundle: nil, for: self, at: index) else { fatalError() }
        return cell as! UICollectionViewCell & ListBindable
    }

}
