//
//  NetworkManager.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 17.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - INTERFACE

protocol NetworkManager {
    
    func loadData(url: String) -> Observable<Data>
    
}

// MARK: - IMPLEMENTATION

class NetworkManagerImpl: NetworkManager {
    
    func loadData(url: String) -> Observable<Data> {
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        return Observable<Data>.create { observer -> Disposable in

            let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
                
                if error != nil {
                    observer.onError(error!)
                } else if data == nil {
                    observer.onError(DataError.NoData)
                } else {
                    observer.onNext(data!)
                }
                
                observer.onCompleted()
  
            })
            
            task.resume()
            return Disposables.create(with: {
                task.cancel()
            })
            
        }
   
    }
    
}

