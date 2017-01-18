//
//  MainViewController.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var mainViewModel:MainViewModel?
    var apiManager:APIManager?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mainViewModel?.initData()

    }

}
