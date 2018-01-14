//
//  ProfileViewController.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/1/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseAuth

class ProfileViewController: UITableViewController {
    
    var user: User?
    var selectedSegmentIndex = 0
    var data = [ListDiffable]()
    lazy var adapter: ListAdapter = { return ListAdapter(updater: ListAdapterUpdater(), viewController: self) }()
    let profilePostsLoader = ProfilePostsLoader()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func controlValueChanged(_ sender: UISegmentedControl) {
        selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        adapter.performUpdates(animated: true, completion: nil)
    }
    @IBAction func settingButtonPushed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Logout", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logout = UIAlertAction(title: "Logout", style: .default, handler: { (action: UIAlertAction!) in
            try! Auth.auth().signOut()
        })
        alert.addAction(cancel)
        alert.addAction(logout)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        profilePostsLoader.delegate = self
        profilePostsLoader.connect()
        
        let profileCellNib = UINib(nibName: "ProfileCell", bundle: nil)
        tableView.register(profileCellNib, forCellReuseIdentifier: "ProfileCell")
        let contentsCellNib = UINib(nibName: "ContentsCell", bundle: nil)
        tableView.register(contentsCellNib, forCellReuseIdentifier: "ContentsCell")
        
        adapter.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140
        } else {
            return tableView.frame.height
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell: ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else {
                fatalError()
            }
            cell.setContents(user: user, schoolName: "Beloit College")
            return cell
        } else {
            guard let cell: ContentsCell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell", for: indexPath) as? ContentsCell else {
                fatalError()
            }
            adapter.collectionView = cell.collectionView
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            return headerView
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension ProfileViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var data: [ListDiffable]
        switch selectedSegmentIndex {
        case 0:
            data = profilePostsLoader.userPostsData
        default:
            data = profilePostsLoader.litPostsData
        }
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PostSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


extension ProfileViewController: ProfilePostsLoaderDelegate {
    
    func litpostsDidUpdate() {
        if selectedSegmentIndex == 1 {
            adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    func userPostsDidUpdate() {
        if selectedSegmentIndex == 0 {
            adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    func userInfoDidUpdate(user: User) {
        self.user = user
        tableView.reloadData()
    }
}
