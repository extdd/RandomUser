//
//  NetworkManager.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 17.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation

fileprivate enum NetworkManagerError: Error {
    
    case NoData
    case InvalidData
    case InvalidJSON
    case InvalidJSONData
    
}

// MARK: - INTERFACE

protocol NetworkManager {
    
    func loadJSON(url:String, completion:@escaping([String : Any]?) -> Void)
    func loadData(url:String, completion:@escaping(Data?) -> Void)
    
}

// MARK: - IMPLEMENTATION

struct NetworkManagerImpl: NetworkManager {
    
    func loadJSON(url:String, completion:@escaping([String : Any]?) -> Void) {
        
        loadData(url: url) { data in
            
            if data != nil {
                
                do {
                    
                    guard let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] else {
                        throw NetworkManagerError.InvalidJSON
                    }
                    
                    completion(json)
                    
                } catch {
                    
                    printError(error)
                    completion(nil)
                    
                }
            }
            
        }
        
    }
    
    func loadData(url:String, completion:@escaping(Data?) -> Void) {
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                printError(error!)
                completion(nil)
                return
            }
            
            guard data != nil else {
                printError(NetworkManagerError.NoData)
                completion(nil)
                return
            }
            
            completion(data)
            
        })
        
        task.resume()
        
    }
    
}
