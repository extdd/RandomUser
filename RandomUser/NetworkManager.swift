//
//  NetworkManager.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 17.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation

// MARK: - INTERFACE

protocol NetworkManager {
    
    func loadJSON(url: String, completion:@escaping ([String : Any]?) -> Void)
    func loadData(url: String, completion:@escaping (Data?) -> Void)
    
}

// MARK: - IMPLEMENTATION

struct NetworkManagerImpl: NetworkManager {
    
    func loadJSON(url: String, completion:@escaping ([String : Any]?) -> Void) {
        
        loadData(url: url) { data in
            if data != nil {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] else {
                        print(NetworkDataError.InvalidJSON)
                        completion(nil)
                        return
                    }
                    completion(json)
                } catch {
                    print(error)
                }
            }
        }
        
    }
    
    func loadData(url: String, completion:@escaping (Data?) -> Void) {
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard error == nil else {
                print(error!)
                completion(nil)
                return
            }
            guard data != nil else {
                print(NetworkDataError.NoData)
                completion(nil)
                return
            }
            completion(data)
        })
        
        task.resume()
        
    }
    
}

