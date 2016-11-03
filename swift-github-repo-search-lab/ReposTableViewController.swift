//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        
        store.getRepositoriesFromAPI {
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
                
            })
        }
        
//        store.getSearchedRepositoriesFromAPI(with: "tetris") {
//            OperationQueue.main.addOperation({
//                self.tableView.reloadData()
//                
//            })
//        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)

        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRepo = store.repositories[indexPath.row]
        
        
        store.toggleStarStatus(repository: selectedRepo) { (complete) in
            
            switch complete {
            case true:
                let alertController = UIAlertController(title: "You just starred \(selectedRepo.fullName)", message: "👏🏽", preferredStyle: .alert)
                alertController.accessibilityLabel = "You just starred \(selectedRepo.fullName)"
                let alertControllerAction = UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                    print("You've pressed OK button")
                })
                alertController.addAction(alertControllerAction)
                self.present(alertController, animated: true, completion: nil)
                break
            case false:
                let alertController = UIAlertController(title: "You just unstarred \(selectedRepo.fullName)", message: "👎🏽", preferredStyle: .alert)
                alertController.accessibilityLabel = "You just unstarred \(selectedRepo.fullName)"
                let alertControllerAction = UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                    print("You've pressed OK button")
                })
                alertController.addAction(alertControllerAction)
                self.present(alertController, animated: true, completion: nil)
                break
            }
            
        }
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func searchRepos(_ sender: AnyObject) {
        
        let searchAlert = UIAlertController(title: "Search Repos", message: "Name?", preferredStyle: .alert)
        
        var searchField = UITextField()
        searchAlert.addTextField { (textField) in
            searchField = textField
        }
        
        let search = UIAlertAction(title: "Search", style: .default) { search in
            
            self.store.getSearchedRepositoriesFromAPI(with: searchField.text!, completion: { 
                self.tableView.reloadData()
            })
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        searchAlert.addAction(search)
        searchAlert.addAction(cancel)
        
        self.present(searchAlert, animated: true) {
            
        }
    }
    
    
    
    

}
