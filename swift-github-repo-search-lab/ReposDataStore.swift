//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories: [GithubRepository] = []
    
    func getRepositoriesFromAPI(completion: @escaping () -> () ) {
        GithubAPIClient.getRepositories { repos in
            self.repositories.removeAll()
            for repo in repos {
                self.repositories.append(GithubRepository(dictionary: repo))
            }
            completion()
        }
    }
    
    func getSearchedRepositoriesFromAPI(with name: String, completion: @escaping () -> () ) {
        GithubAPIClient.getSearchedRepositories(with: name) { searchedRepos in
            self.repositories.removeAll()
            let repos = searchedRepos["items"]
            guard let checkedRepos = repos as? [[String : Any]] else { return }
            for repo in checkedRepos {
                self.repositories.append(GithubRepository(dictionary: repo))
            }
            completion()
        }
    }
    
    
    func toggleStarStatus(repository: GithubRepository, completion: @escaping (Bool) -> ()) {
        
        GithubAPIClient.checkIfRepositoryIsStarred(fullName: repository.fullName) { complete in
            
            switch complete {
            case true:
                GithubAPIClient.unstarRepository(fullName: repository.fullName, completion: { 
                    completion(false)
                })
                break
            case false:
                GithubAPIClient.starRepository(fullName: repository.fullName, completion: { 
                    completion(true)
                })
                break
            }
            
        }
    }
    

}
