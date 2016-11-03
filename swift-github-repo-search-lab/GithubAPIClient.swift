//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire



class GithubAPIClient {
    
    class func getRepositories(with completion: @escaping ([[String: Any]])->()) {
        
        let urlString = "\(Secrets.apiURL)/repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)"
        guard let url = URL(string: urlString) else { return }
        
        Alamofire.request(url).responseJSON { response in
            guard let JSON = response.result.value else { return }
            let completeJSON = JSON as! [[String : Any]]
            completion(completeJSON)
        }
    }
    
    class func getSearchedRepositories(with name: String, completion: @escaping ([String:Any])->()) {
        
        let urlString = "\(Secrets.apiURL)/search/repositories?q=\(name)"
        let url = URL(string: urlString)
        guard let checkedURL = url else { return }
        Alamofire.request(checkedURL).validate().responseJSON { response in
            
            if let newData = response.data {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: newData, options: []) as! [String:Any]
                    completion(responseJSON)
                }catch{
                    print("Error")
                }
                
            }
        }
        
        
        /// WHY DOESN'T THIS WORK??
//        let urlString = "\(Secrets.apiURL)/repositories?q=\(name)"
//        guard let url = URL(string: urlString) else { return }
//        
//        Alamofire.request(url).responseData { response in
//            guard let JSON = response.data else { return }
//            dump(JSON)
//            let completeJSON = JSON as! [String:Any]
//            completion(completeJSON)
//        }
    }
    
    class func checkIfRepositoryIsStarred(fullName: String,  completion:  @escaping (Bool) -> () ) {
        
        let urlString = "\(Secrets.apiURL)/user/starred/\(fullName)?access_token=\(Secrets.token)"
        guard let url = URL(string: urlString) else { return }
        
        Alamofire.request(url)
            .validate(statusCode: 200..<405)
            .responseData { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 204:
                    completion(true)
                case 404:
                    completion(false)
                default:
                    print("ERROR: A status code of \(statusCode) was returned *****************")
                    break
                }
        }
    }
    
    class func starRepository(fullName: String, completion: @escaping () -> ()) {
        
        let urlString = "\(Secrets.apiURL)/user/starred/\(fullName)?access_token=\(Secrets.token)"
        guard let url = URL(string: urlString) else { return }

        Alamofire.request(url, method: .put, encoding: URLEncoding.default)
            .validate().responseJSON { _ in
            print("--------  Repository has been STARRED  ------------\n\n")
            completion() }
    }
    
    class func unstarRepository(fullName: String, completion: @escaping () -> ()) {
        
        let urlString = "\(Secrets.apiURL)/user/starred/\(fullName)?access_token=\(Secrets.token)"
        guard let url = URL(string: urlString) else { return }
        
        Alamofire.request(url, method: .delete, encoding: URLEncoding.default)
            .validate().responseJSON { _ in
                print("--------  Repository has been UNSTARRED  ------------\n\n")
                completion() }
    }
}

